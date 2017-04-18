//
//  IPCOtherPayTypeView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOtherPayTypeView.h"

@interface IPCOtherPayTypeView()

@property (copy, nonatomic) void(^UpdateBlock)(IPCOtherPayTypeResult *);

@end

@implementation IPCOtherPayTypeView


- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)(IPCOtherPayTypeResult * result))update
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCOtherPayTypeView" owner:self];
        [self addSubview:view];
        
        self.UpdateBlock = update;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.payTypeNameTextField addBorder:3 Width:0.5];
    [self.payAmountTextField addBorder:3 Width:0.5];
    [self.payAmountTextField setLeftSpace:5];
    [self.payTypeNameTextField setLeftSpace:5];
    [self.selectStyleButton setSelected:YES];
    [self.payAmountTextField setLeftText:@"￥"];
}

- (void)updateUI
{
    [self.payTypeNameTextField setText:self.otherPayTypeResult.otherPayTypeName];
    [self.payAmountTextField setText:[NSString stringWithFormat:@"%.f",self.otherPayTypeResult.otherPayAmount]];
    
    NSString * payText = [NSString stringWithFormat:@"支付￥%.f",self.otherPayTypeResult.otherPayAmount];

    [self.payAmountLabel setAttributedText:[IPCCustomUI subStringWithText:payText BeginRang:2 Rang:payText.length - 2 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:COLOR_RGB_RED]];
}

#pragma mark //Clicked Events
- (IBAction)onSelectPayTypeAction:(id)sender {
    
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([textField isEqual:self.payTypeNameTextField]) {
            self.otherPayTypeResult.otherPayTypeName = str;
        }else{
            NSInteger index = [[IPCPayOrderMode sharedManager].otherPayTypeArray indexOfObject:self.otherPayTypeResult];
            __block double otherTotalAmout = 0;
            [[IPCPayOrderMode sharedManager].otherPayTypeArray enumerateObjectsUsingBlock:^(IPCOtherPayTypeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != index) {
                    otherTotalAmout += obj.otherPayAmount;
                }
            }];
            
            double minum = [[IPCPayOrderMode sharedManager] waitPayAmount] - [IPCPayOrderMode sharedManager].usedBalanceAmount -  otherTotalAmout;
            
            if (minum > 0) {
                if (minum < [str doubleValue]) {
                    self.otherPayTypeResult.otherPayAmount = minum;
                }else{
                    self.otherPayTypeResult.otherPayAmount = [str doubleValue];
                }
            }else{
                self.otherPayTypeResult.otherPayAmount = 0;
            }
        }
    }
    
    if (self.UpdateBlock) {
        self.UpdateBlock(self.otherPayTypeResult);
    }
}


@end
