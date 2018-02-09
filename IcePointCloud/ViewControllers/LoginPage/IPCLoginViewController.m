//
//  VerifyViewController.m
//  IcePointCloud
//
//  Created by mac on 7/28/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCLoginViewController.h"
#import "IPCLoginHistoryViewController.h"
#import "IPCLoginViewModel.h"
#import "IPCCustomKeyboard.h"

@interface IPCLoginViewController ()<LoginHistoryViewControllerDelegate,UITextFieldDelegate> 

@property (weak, nonatomic) IBOutlet UIView *loginBgView;
@property (nonatomic, weak) IBOutlet UITextField *usernameTf;
@property (nonatomic, weak) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *valityCodeCoverView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic, strong) IPCLoginViewModel * loginViewModel;

@end

@implementation IPCLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.loginViewModel = [[IPCLoginViewModel alloc]init];
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
    
    if ([self.loginViewModel.loginHistory count]){
        [self.usernameTf setRightView:self Action:@selector(chooseLoginUserAction:)];
    }
    [self.usernameTf setText:[self.loginViewModel userName]];
}

#pragma mark //Set UI
- (void)loadValityCodeView
{
    [self.valityCodeCoverView setFrame:self.view.bounds];
    [self.view addSubview:self.valityCodeCoverView];
}


#pragma mark //ClickEvents
- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    [self userLoginMethod];
}

- (IBAction)valityAction:(id)sender {
    [self.loginViewModel valityActiveCode:self.codeTextField.text];
}

- (IBAction)backValityCodeAction:(id)sender {
    [self.valityCodeCoverView removeFromSuperview];
}

- (void)chooseLoginUserAction:(UIButton *)sender{
    [self.view endEditing:YES];
    
    IPCLoginHistoryViewController * historyVC = [[IPCLoginHistoryViewController alloc]initWithNibName:@"IPCLoginHistoryViewController" bundle:nil];
    [historyVC setDelegate:self];
    [historyVC showWithSize:CGSizeMake(self.loginBgView.jk_width-50, 150) Position:CGPointMake(self.loginBgView.jk_width/2, self.usernameTf.jk_bottom) Owner:self.loginBgView];
}

- (void)userLoginMethod
{
    [self.loginButton jk_showIndicator];
    
    __weak typeof(self) weakSelf = self;
    [self.loginViewModel signinRequestWithUserName:self.usernameTf.text
                                          Password:self.passwordTf.text
                                        NeedVality:^
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
         [weakSelf loadValityCodeView];
         [strongSelf.loginButton jk_hideIndicator];
     }  Failed:^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf.loginButton jk_hideIndicator];
     }];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTf) {
        [self.passwordTf becomeFirstResponder];
    }else if(textField == self.passwordTf){
        [textField resignFirstResponder];
        [self userLoginMethod];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark //LoginHistoryViewControllerDelegate
- (void)chooseHistoryLoginName:(NSString *)loginName{
    [self.usernameTf setText:loginName];
    [self.passwordTf setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.view = nil;
    self.loginViewModel = nil;
    [IPCHttpRequest cancelAllRequest];
}


@end
