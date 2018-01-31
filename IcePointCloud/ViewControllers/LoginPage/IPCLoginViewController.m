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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.loginViewModel testLogin];
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

- (void)userLoginMethod
{
    [self.loginButton jk_showIndicator];
    
    [self.loginViewModel signinRequestWithUserName:self.usernameTf.text Password:self.passwordTf.text Failed:^{
        [self.loginButton jk_hideIndicator];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
