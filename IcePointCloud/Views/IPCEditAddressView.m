//
//  IPCEditAddressView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditAddressView.h"

typedef  void(^CompleteBlock)();
typedef  void(^DismissBlock)();

@interface IPCEditAddressView()<IPCDataPickerViewDataSource,IPCDataPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *editAddressView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveAddressButton;
@property (copy,  nonatomic) NSString * customerID;
@property (copy,  nonatomic) CompleteBlock  completeBlock;
@property (copy,  nonatomic) DismissBlock   dismissBlock;

@end

@implementation IPCEditAddressView


- (instancetype)initWithFrame:(CGRect)frame CustomerID:(NSString *)customerID Complete:(void(^)())complete Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.completeBlock = complete;
        self.dismissBlock = dismiss;
        self.customerID = customerID;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCEditAddressView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
        
        self.editAddressView.layer.cornerRadius = 10;
        [self.saveAddressButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateNormal];
        [IPCUIKit clearAutoCorrection:self.editAddressView];
        [IPCUIKit textFieldRightButton:self Action:@selector(showGenderPickerAction) InTextField:self.genderTextField OnView:self.editAddressView];
        
        RAC(self.saveAddressButton,enabled) = [RACSignal combineLatest:@[self.contactTextField.rac_textSignal,self.phoneTextField.rac_textSignal,self.addressTextField.rac_textSignal,RACObserve(self, self.genderTextField.text)] reduce:^id(NSString *contactName,NSString *phone,NSString *address,NSString *gender){
            return @(contactName.length && phone.length && address.length && gender.length);
        }];
    }
    return self;
}


#pragma mark //Requst Method
- (void)saveNewAddress{
    [IPCCustomerRequestManager saveNewCustomerAddressWithAddressID:@""
                                                          CustomID:self.customerID
                                                       ContactName:self.contactTextField.text
                                                            Gender:[IPCCommon gender:self.genderTextField.text]
                                                             Phone:self.phoneTextField.text
                                                           Address:self.addressTextField.text
                                                      SuccessBlock:^(id responseValue)
     {
         if (self.completeBlock) {
             self.completeBlock();
         }
         [IPCUIKit showSuccess:@"新建地址成功!"];
     } FailureBlock:^(NSError *error) {
         [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
     }];
}

#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


- (IBAction)completeAction:(id)sender {
    [self saveNewAddress];
}

- (void)showGenderPickerAction{
    [self endEditing:YES];
    
    IPCDataPickViewController * pickerVC = [[IPCDataPickViewController alloc]initWithNibName:@"IPCDataPickViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate = self;
    [pickerVC showWithPosition:CGPointMake(self.editAddressView.jk_width/2, self.genderTextField.jk_bottom) Size:CGSizeMake(self.editAddressView.jk_width, 150) Owner:self.editAddressView];
}

#pragma mark //CustomPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView{
    return 1;
}

- (NSInteger)pickerViewNumberOfRowsInComponent:(NSInteger)component{
    return 2;
}

#pragma mark //CustomPickerViewDelegate
- (NSString *)pickerViewTitleForRow:(NSInteger)row{
    return row == 0 ? @"男":@"女";
}

- (void)didSelectContent:(NSString *)content titleForRow:(NSInteger)row{
    [self.genderTextField setText:content];
}


#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneTextField]) {
        if (![IPCCommon checkTelNumber:[textField.text jk_trimmingWhitespace]]) {
            [IPCUIKit showError:@"请输入有效的手机号码!"];
            [textField setText:@""];
        }
    }
}


@end
