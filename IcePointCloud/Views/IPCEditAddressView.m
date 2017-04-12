//
//  IPCEditAddressView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditAddressView.h"
#import "IPCAddressView.h"

typedef  void(^CompleteBlock)();
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
        [self.saveAddressButton setBackgroundColor:COLOR_RGB_BLUE];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self createAddressView];
}

#pragma mark //Set UI
- (void)createAddressView{
    self.addressView = [[IPCAddressView alloc]initWithFrame:CGRectMake(0, 20, self.addressContentView.jk_width, 80)];
    [self.addressContentView addSubview:self.addressView];
}

#pragma mark //Requst Method
- (void)saveNewAddress{
//    [IPCCustomerRequestManager saveNewCustomerAddressWithAddressID:@""
//                                                          CustomID:self.customerID
//                                                       ContactName:self.addressV
//                                                            Gender:[IPCCommon gender:self.genderTextField.text]
//                                                             Phone:self.phoneTextField.text
//                                                           Address:self.addressTextField.text
//                                                      SuccessBlock:^(id responseValue)
//     {
//         if (self.completeBlock) {
//             self.completeBlock();
//         }
//         [IPCCustomUI showSuccess:@"新建地址成功!"];
//     } FailureBlock:^(NSError *error) {
//         [IPCCustomUI showError:error.domain];
//     }];
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


@end
