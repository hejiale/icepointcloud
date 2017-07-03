//
//  IPCEditAddressView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditAddressView.h"
#import "IPCAddressView.h"

typedef  void(^CompleteBlock)(NSString *);
typedef  void(^DismissBlock)();

@interface IPCEditAddressView()

@property (strong, nonatomic) IBOutlet UIView *editAddressView;
@property (weak, nonatomic) IBOutlet UIButton *saveAddressButton;
@property (weak, nonatomic) IBOutlet UIView *addressContentView;
@property (strong, nonatomic) IPCAddressView * addressView;

@property (copy,  nonatomic) NSString * customerID;
@property (copy,  nonatomic) CompleteBlock  completeBlock;
@property (copy,  nonatomic) DismissBlock   dismissBlock;

@end

@implementation IPCEditAddressView


- (instancetype)initWithFrame:(CGRect)frame CustomerID:(NSString *)customerID Complete:(void(^)(NSString *))complete Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.completeBlock = complete;
        self.dismissBlock = dismiss;
        self.customerID = customerID;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCEditAddressView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        self.editAddressView.layer.cornerRadius = 10;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self createAddressView];
}

#pragma mark //Set UI
- (void)createAddressView{
    self.addressView = [[IPCAddressView alloc]initWithFrame:CGRectMake(0, 20, self.addressContentView.jk_width, 80) Update:^{
        
    }];
    [self.addressContentView addSubview:self.addressView];
    [self.addressView.maleButton setSelected:YES];
}

#pragma mark //Requst Method
- (void)saveNewAddress
{
    [IPCCustomerRequestManager saveNewCustomerAddressWithAddressID:@""
                                                          CustomID:self.customerID
                                                       ContactName:self.addressView.contacterTextField.text
                                                            Gender:self.addressView.maleButton.selected ? @"MALE" : @"FEMALE"
                                                             Phone:self.addressView.phoneTextField.text
                                                           Address:self.addressView.addressTextField.text
                                                      SuccessBlock:^(id responseValue)
     {
         [self insertPayOrderAddress:responseValue[@"id"]];
         if (self.completeBlock) {
             self.completeBlock(responseValue[@"id"]);
         }
         [IPCCustomUI showSuccess:@"新建地址成功!"];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


- (IBAction)completeAction:(id)sender {
    if (self.customerID) {
        [self saveNewAddress];
    }else{
        [self insertPayOrderAddress:nil];
        if (self.completeBlock) {
            self.completeBlock(nil);
        }
    }
}

- (void)insertPayOrderAddress:(NSString *)addressId
{
    IPCCustomerAddressMode * currentAddress = [[IPCCustomerAddressMode alloc]init];
    currentAddress.contactorName = self.addressView.contacterTextField.text;
    currentAddress.contactorPhone = self.addressView.phoneTextField.text;
    currentAddress.gender = (self.addressView.maleButton.selected ? @"MALE" : @"FEMALE");
    currentAddress.genderString = [IPCCommon formatGender:currentAddress.gender];
    currentAddress.detailAddress = self.addressView.addressTextField.text;
    if (addressId) {
        currentAddress.addressID = addressId;
    }
    [IPCCurrentCustomer sharedManager].currentAddress = currentAddress;
}


@end
