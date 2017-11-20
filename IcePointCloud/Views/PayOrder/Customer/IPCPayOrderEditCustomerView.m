//
//  IPCPayOrderEditCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderEditCustomerView.h"

@interface IPCPayOrderEditCustomerView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *customerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextField;
@property (weak, nonatomic) IBOutlet UIView *editContentView;

@end

@implementation IPCPayOrderEditCustomerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderEditCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.editContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
    }
    return self;
}


#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)completeAction:(id)sender {
    [self removeFromSuperview];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
