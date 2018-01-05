//
//  IPCUpdateCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/5.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCUpdateCustomerView.h"

@interface IPCUpdateCustomerView()

@property (weak, nonatomic) IBOutlet UITextField *customerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiel;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UITextField *customerTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *encryptedPhoneTextField;
@property (weak, nonatomic) IBOutlet UIView *editContentView;

@end

@implementation IPCUpdateCustomerView

- (instancetype)initWithFrame:(CGRect)frame DetailCustomer:(IPCDetailCustomer *)customer UpdateBlock:(void (^)(NSString *))update
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpdateCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.editContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
        
        [self.birthdayTextField setRightButton:self Action:@selector(showDatePickerAction) OnView:self.editContentView];
        [self.customerTypeTextField setRightButton:self Action:@selector(selectCustomTypeAction) OnView:self.editContentView];
        
        [[IPCCustomerManager sharedManager] queryCustomerType];
        [self.customerTypeTextField setText: @"自然进店"];
    }
    return self;
}

@end
