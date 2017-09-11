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
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self createAddressView];
}

#pragma mark //Set UI
- (void)createAddressView{
    self.addressView = [[IPCAddressView alloc]initWithFrame:CGRectMake(0, 20, self.addressContentView.jk_width, 80) Update:nil];
    [self.addressContentView addSubview:self.addressView];
    [self.addressView.maleButton setSelected:YES];
}

#pragma mark //Requst Method
- (void)saveNewAddress
{
    [self.saveAddressButton jk_showIndicator];
    [IPCCustomerRequestManager saveNewCustomerAddressWithAddressID:@""
                                                          CustomID:self.customerID
                                                       ContactName:self.addressView.contacterTextField.text
                                                            Gender:self.addressView.maleButton.selected ? @"MALE" : @"FEMALE"
                                                             Phone:self.addressView.phoneTextField.text
                                                           Address:self.addressView.addressTextField.text
                                                      SuccessBlock:^(id responseValue)
     {
         [self.saveAddressButton jk_hideIndicator];
         if (self.completeBlock) {
             self.completeBlock(responseValue[@"id"]);
         }
     } FailureBlock:^(NSError *error) {
         [self.saveAddressButton jk_hideIndicator];
         [IPCCommonUI showInfo:@"新建地址失败!"];
     }];
}

#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


- (IBAction)completeAction:(id)sender {
    if (self.addressView.addressTextField.text.length) {
        if (self.customerID) {
            [self saveNewAddress];
        }else{
            if (self.completeBlock) {
                self.completeBlock(nil);
            }
        }
    }
}


@end
