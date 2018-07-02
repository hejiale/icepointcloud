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
@property (strong, nonatomic) IPCCustomerMode * customer;
@property (copy, nonatomic) void(^UpdateBlock)(IPCCustomerMode *customer);

@end

@implementation IPCUpgradeMemberView

- (instancetype)initWithFrame:(CGRect)frame Customer:(IPCCustomerMode *)customer  UpdateBlock:(void (^)(IPCCustomerMode *customer))update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.UpdateBlock = update;
        self.customer = customer;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpgradeMemberView" owner:self];
        [self addSubview:view];
        
        [self.editContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
        
        if ([IPCCommon checkTelNumber:self.customer.customerPhone]) {
            [self.encryptedPhoneTextField setText:self.customer.customerPhone];
        }
    }
    return self;
}

#pragma mark //Request Data
- (void)upgradeMemberRequest
{
    [IPCCustomerRequestManager upgradeMemberWithCustomerId:self.customer.customerID
                                              MemberGrowth:[self.growthValueTextField.text doubleValue]
                                               MemberPhone:self.encryptedPhoneTextField.text
                                                  Integral:0
                                                   Balance:0
                                              SuccessBlock:^(id responseValue)
     {
         IPCCustomerMode * customer = [IPCCustomerMode mj_objectWithKeyValues:responseValue];
         if (self.UpdateBlock) {
             self.UpdateBlock(customer);
         }
         [self removeFromSuperview];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:error.domain];
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
    if (textField.tag == 11) {
        [textField resignFirstResponder];
    }else{
        UITextField * nextField = (UITextField *)[self.editContentView viewWithTag:textField.tag+1];
        [nextField becomeFirstResponder];
    }
    return YES;
}


@end
