//
//  IPCUpgradeMemberView.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/8.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCUpgradeMemberView.h"

@interface IPCUpgradeMemberView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UITextField *encryptedPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *growthValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *pointValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *storeValueTextField;
@property (copy, nonatomic) void(^UpdateBlock)();

@end

@implementation IPCUpgradeMemberView

- (instancetype)initWithFrame:(CGRect)frame UpdateBlock:(void (^)())update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.UpdateBlock = update;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpgradeMemberView" owner:self];
        [self addSubview:view];
        
        [self.editContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
        
        if ([IPCCommon checkTelNumber:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer.customerPhone]) {
            [self.encryptedPhoneTextField setText:[IPCPayOrderCurrentCustomer sharedManager].currentCustomer.customerPhone];
        }
    }
    return self;
}

#pragma mark //Request Data
- (void)upgradeMemberRequest
{
    [IPCCustomerRequestManager upgradeMemberWithCustomerId:[IPCPayOrderManager sharedManager].currentCustomerId
                                              MemberGrowth:[self.growthValueTextField.text doubleValue]
                                               MemberPhone:self.encryptedPhoneTextField.text
                                                  Integral:[self.pointValueTextField.text integerValue]
                                                   Balance:[self.storeValueTextField.text doubleValue]
                                              SuccessBlock:^(id responseValue) {
                                                  if (self.UpdateBlock) {
                                                      self.UpdateBlock();
                                                  }
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:error.localizedDescription];
    }];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)saveAction:(id)sender {
    [self upgradeMemberRequest];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 13) {
        [textField resignFirstResponder];
    }else{
        UITextField * nextField = (UITextField *)[self.editContentView viewWithTag:textField.tag+1];
        [nextField becomeFirstResponder];
    }
    return YES;
}


@end
