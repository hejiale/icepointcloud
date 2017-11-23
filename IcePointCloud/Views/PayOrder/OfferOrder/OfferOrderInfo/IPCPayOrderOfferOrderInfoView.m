//
//  IPCPayOrderOfferOrderInfoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOfferOrderInfoView.h"
#import "IPCEmployeListView.h"

@interface IPCPayOrderOfferOrderInfoView()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *discountAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *payAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (copy, nonatomic) void(^EndEditingBlock)();

@end

@implementation IPCPayOrderOfferOrderInfoView

- (instancetype)initWithFrame:(CGRect)frame EndEditing:(void(^)())end
{
    self = [super initWithFrame:frame];
    if (self) {
        self.EndEditingBlock = end;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOfferOrderInfoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.discountAmountTextField addBottomLine];
    [self.payAmountTextField addBottomLine];
    [self.memoTextView addBorder:0 Width:1 Color:nil];
}

#pragma mark //Clicked Events
- (IBAction)selectEmployeeAction:(id)sender
{
    IPCEmployeListView * listView = [[IPCEmployeListView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds
                                                                DismissBlock:^(IPCEmployee *employee)
                                     {
                                         [IPCPayOrderManager sharedManager].employee = employee;
                                         [self.employeeNameLabel setText:employee.name];
                                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:listView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:listView];
}

- (void)updateOrderInfo
{
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice]]];
    [self.payAmountTextField setText:[NSString stringWithFormat:@"￥%.2f", [IPCPayOrderManager sharedManager].payAmount]];
    [self.discountAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[IPCPayOrderManager sharedManager].discountAmount]];
    [self.discountAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].discount]];
    [self.employeeNameLabel setText:[IPCPayOrderManager sharedManager].employee.name];
}

#pragma mark //UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![IPCCommon judgeIsFloatNumber:string]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([textField isEqual:self.discountAmountTextField]) {
            if ([str integerValue] >= 100) {
                [IPCPayOrderManager sharedManager].discount  = 100;
            }else if ([str integerValue] <= 0){
                [IPCPayOrderManager sharedManager].discount = 0;
            }else{
                [IPCPayOrderManager sharedManager].discount = [str doubleValue];
            }
            [IPCPayOrderManager sharedManager].discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] * ([IPCPayOrderManager sharedManager].discount/100);
            [IPCPayOrderManager sharedManager].payAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] - [IPCPayOrderManager sharedManager].discountAmount;
        }else{
            if ([str doubleValue] >= [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] || [str doubleValue] <= 0) {
                [IPCPayOrderManager sharedManager].payAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice];
            }else{
                [IPCPayOrderManager sharedManager].payAmount = [str doubleValue];
            }
            [IPCPayOrderManager sharedManager].discount = [[IPCPayOrderManager sharedManager] calculateDiscount];
            [IPCPayOrderManager sharedManager].discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] * ([IPCPayOrderManager sharedManager].discount/100);
        }
        [self updateOrderInfo];
        
        if (self.EndEditingBlock) {
            self.EndEditingBlock();
        }
    }
}

#pragma mark //UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [IPCPayOrderManager sharedManager].remark =  [textView.text jk_trimmingWhitespace];
}


@end
