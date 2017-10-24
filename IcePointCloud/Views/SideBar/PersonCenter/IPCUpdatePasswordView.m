//
//  UpdatePwView.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCUpdatePasswordView.h"

@interface IPCUpdatePasswordView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *oldWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *insertWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation IPCUpdatePasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpdatePasswordView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView addBottomLine];
    [self.oldWordTextField addBorder:3 Width:0.5 Color:nil];
    [self.insertWordTextField addBorder:3 Width:0.5 Color:nil];
    [self.confirmWordTextField addBorder:3 Width:0.5 Color:nil];
    [self.oldWordTextField setLeftSpace:10];
    [self.insertWordTextField setLeftSpace:10];
    [self.confirmWordTextField setLeftSpace:10];
}

#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    [self dismiss];
}

- (IBAction)saveAction:(id)sender {
    [self updateNewPassword];
}

#pragma mark //Request Data
- (void)updateNewPassword{
    __block NSString *oldPwd = [self.oldWordTextField.text jk_trimmingWhitespace];
    __block NSString *pwd     = [self.insertWordTextField.text jk_trimmingWhitespace];
    __block NSString *cofirmpwd   = [self.confirmWordTextField.text jk_trimmingWhitespace];
    
    if (oldPwd.length && pwd.length && cofirmpwd.length) {
        if ([pwd isEqualToString:cofirmpwd]) {
            [IPCCommonUI show];
            [IPCUserRequestManager updatePasswordWithOldPassword:oldPwd
                                                  UpdatePassword:cofirmpwd
                                                    SuccessBlock:^(id responseValue)
             {
                 [IPCCommonUI showSuccess:@"修改用户密码成功!"];
                 [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.f];
             } FailureBlock:^(NSError *error) {
                 if ([error code] != NSURLErrorCancelled) {
                     [IPCCommonUI showError:@"修改用户密码失败!"];
                 }
             }];
        }else{
            [IPCCommonUI showError:@"两次输入新密码不一致!"];
        }
    }
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.oldWordTextField]) {
        [self.insertWordTextField becomeFirstResponder];
    }else if ([textField isEqual:self.insertWordTextField]){
        [self.confirmWordTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

@end
