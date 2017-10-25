//
//  VerifyViewController.m
//  IcePointCloud
//
//  Created by mac on 7/28/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCLoginViewController.h"
#import "IPCLoginHistoryViewController.h"
#import "IPCRootViewController.h"

@interface IPCLoginViewController ()<LoginHistoryViewControllerDelegate,UITextFieldDelegate> 

@property (weak, nonatomic) IBOutlet UIView *loginBgView;
@property (nonatomic, weak) IBOutlet UITextField *usernameTf;
@property (nonatomic, weak) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) NSMutableArray<NSString *> * loginHistory;

@end

@implementation IPCLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.usernameTf addBorder:5 Width:0.5 Color:nil];
    [self.passwordTf addBorder:5 Width:0.5 Color:nil];
    [self.usernameTf setLeftSpace:10];
    [self.passwordTf setLeftSpace:10];
    [IPCCommonUI clearAutoCorrection:self.loginBgView];

    if ([NSUserDefaults jk_stringForKey:IPCUserNameKey].length) {
        [self.usernameTf setText:[NSUserDefaults jk_stringForKey:IPCUserNameKey]];
    }
    
    [self.loginHistory addObjectsFromArray:[IPCAppManager sharedManager].loginAccountHistory];
    if ([self.loginHistory count]){
        [self.usernameTf setRightView:self Action:@selector(chooseLoginUserAction:)];
    }
}

- (NSMutableArray<NSString *> *)loginHistory{
    if (!_loginHistory) {
        _loginHistory = [[NSMutableArray alloc]init];
    }
    return _loginHistory;
}

#pragma mark //ClickEvents
- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    [self userLoginMethod];
}

- (void)chooseLoginUserAction:(UIButton *)sender{
    [self.view endEditing:YES];
    
    IPCLoginHistoryViewController * historyVC = [[IPCLoginHistoryViewController alloc]initWithNibName:@"IPCLoginHistoryViewController" bundle:nil];
    [historyVC setDelegate:self];
    [historyVC showWithSize:CGSizeMake(self.loginBgView.jk_width-50, 150) Position:CGPointMake(self.loginBgView.jk_width/2, self.usernameTf.jk_bottom) Owner:self.loginBgView];
}

- (void)showMainRootViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                          duration:0.8f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
            BOOL oldState = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];
            IPCRootViewController * menuVC = [[IPCRootViewController alloc]initWithNibName:@"IPCRootViewController" bundle:nil];
            UINavigationController * menuNav = [[UINavigationController alloc]initWithRootViewController:menuVC];
            [[UIApplication sharedApplication].keyWindow setRootViewController:menuNav];
            [UIView setAnimationsEnabled:oldState];
        } completion:nil];
    });
}

- (void)userLoginMethod
{
    NSString *username = [self.usernameTf.text jk_trimmingWhitespace];
    NSString *password = [self.passwordTf.text jk_trimmingWhitespace];
    
    if (!username.length){
        [IPCCommonUI showError:@"登录帐号不能为空"];
        return;
    }
    if (!password.length) {
        [IPCCommonUI showError:@"登录密码不能为空"];
        return;
    }
    [self.loginButton jk_showIndicator];
    [self signinRequestWithUserName:username Password:password];
}

#pragma mark //Request Methods
- (void)signinRequestWithUserName:(NSString *)userName Password:(NSString *)password
{
    __weak typeof (self) weakSelf = self;
    [IPCUserRequestManager userLoginWithUserName:userName Password:password SuccessBlock:^(id responseValue)
     {
         //query login info
         __strong typeof (weakSelf) strongSelf = weakSelf;
         [IPCAppManager sharedManager].deviceToken = responseValue[@"mobileToken"];
         [IPCAppManager sharedManager].companyName = responseValue[@"companyName"];
         //storeage account info
        [strongSelf syncUserAccountHistory:userName];
         //query responsity wareHouse
         [strongSelf queryEmployeeAccount];
    } FailureBlock:^(NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.loginButton jk_hideIndicator];
        [IPCCommonUI showError:@"用户登录失败,请重新输入!"];
    }];
}

- (void)queryEmployeeAccount
{
    [IPCUserRequestManager queryEmployeeAccountWithSuccessBlock:^(id responseValue)
    {
        //Query Responsity WareHouse
        [IPCAppManager sharedManager].storeResult = [IPCStoreResult mj_objectWithKeyValues:responseValue];
        IPCWareHouse *  wareHouse = [[IPCWareHouse alloc]init];
        wareHouse.wareHouseId       = [IPCAppManager sharedManager].storeResult.wareHouseId;
        wareHouse.wareHouseName = [IPCAppManager sharedManager].storeResult.wareHouseName;
        [IPCAppManager sharedManager].currentWareHouse = wareHouse;
        //load wareHouse
        [self loadWareHouse];
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:@"用户登录失败,请重新输入!"];
    }];
}

- (void)loadWareHouse
{
    [[IPCAppManager sharedManager] loadWareHouse:^(NSError *error) {
        //Load Main View
        if (!error) {
            [self showMainRootViewController];
        }else{
            [IPCCommonUI showError:@"用户登录失败,请重新输入!"];
        }
    }];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTf) {
        [self.passwordTf becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self userLoginMethod];
    }
    return YES;
}

#pragma mark //LoginHistoryViewControllerDelegate
- (void)chooseHistoryLoginName:(NSString *)loginName{
    [self.usernameTf setText:loginName];
    [self.passwordTf setText:@""];
}

#pragma mark //Save UserName History
- (void)syncUserAccountHistory:(NSString *)userName
{
    if ([IPCAppManager sharedManager].deviceToken.length && userName.length)
    {
        [NSUserDefaults jk_setObject:userName forKey:IPCUserNameKey];
        
        if (![self.loginHistory containsObject:userName])
            [self.loginHistory insertObject:userName atIndex:0];
        
        NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.loginHistory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCListLoginHistoryKey];
        [NSUserDefaults jk_setObject:historyData forKey:IPCListLoginHistoryKey];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
