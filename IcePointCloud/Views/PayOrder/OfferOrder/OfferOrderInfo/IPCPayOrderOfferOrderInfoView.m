//
//  IPCPayOrderOfferOrderInfoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOfferOrderInfoView.h"
#import "IPCEmployeListView.h"

@interface IPCPayOrderOfferOrderInfoView()<IPCCustomTextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UIView *payAmountView;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (strong, nonatomic)  IPCCustomTextField *discountAmountTextField;
@property (strong, nonatomic)  IPCCustomTextField *payAmountTextField;

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
    
    [self.discountView addBottomLine];
    [self.payAmountView addBottomLine];
    
    [self.memoTextView addBorder:0 Width:1 Color:nil];
    
    [self.discountView addSubview:self.discountAmountTextField];
    [self.payAmountView addSubview:self.payAmountTextField];
}

- (IPCCustomTextField *)discountAmountTextField
{
    if (!_discountAmountTextField) {
        _discountAmountTextField = [[IPCCustomTextField alloc]initWithFrame:self.discountView.bounds];
        [_discountAmountTextField setDelegate:self];
        _discountAmountTextField.textAlignment = NSTextAlignmentRight;
    }
    return _discountAmountTextField;
}

- (IPCCustomTextField *)payAmountTextField
{
    if (!_payAmountTextField) {
        _payAmountTextField = [[IPCCustomTextField alloc]initWithFrame:self.payAmountView.bounds];
        [_payAmountTextField setDelegate:self];
        _payAmountTextField.textAlignment = NSTextAlignmentRight;
    }
    return _payAmountTextField;
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
    [self.payAmountTextField setText:[NSString stringWithFormat:@"￥%@",[IPCCommon formatNumber:[IPCPayOrderManager sharedManager].payAmount Location:3]]];
    [self.discountAmountLabel setText:[NSString stringWithFormat:@"￥%@",[IPCCommon formatNumber:[IPCPayOrderManager sharedManager].discountAmount  Location:3]]];
    if ([IPCPayOrderManager sharedManager].customDiscount > -1) {
        [self.discountAmountTextField setText:[NSString stringWithFormat:@"%@",[IPCCommon formatNumber:[IPCPayOrderManager sharedManager].customDiscount  Location:3]]];
    }else{
        [self.discountAmountTextField setText:[NSString stringWithFormat:@"%@",[IPCCommon formatNumber:[IPCPayOrderManager sharedManager].discount Location:3]]];
    }
    
    [self.employeeNameLabel setText:[IPCPayOrderManager sharedManager].employee.name];
    [self.memoTextView setText:[IPCPayOrderManager sharedManager].remark ? : @""];
}

#pragma mark //UITextField Delegate
- (void)textFieldBeginEditing:(IPCCustomTextField *)textField
{
}

- (void)textFieldPreEditing:(IPCCustomTextField *)textField
{
    if ([textField isEqual:self.payAmountTextField]) {
        [self.discountAmountTextField becomFirstResponder];
    }
}

- (void)textFieldNextEditing:(IPCCustomTextField *)textField
{
    if ([textField isEqual:self.discountAmountTextField]) {
        [self.payAmountTextField becomFirstResponder];
    }
}

- (void)textFieldEndEditing:(IPCCustomTextField *)textField
{
    NSString * str = [textField.text jk_trimmingWhitespace];
    NSString * priceStr = str;
    
    if ([str containsString:@"￥"]) {
        priceStr =  [str substringFromIndex:1];
    }
    
    if (priceStr.length && [IPCShoppingCart sharedCart].allGlassesCount > 0)
    {
        if ([textField isEqual:self.discountAmountTextField]) {
            if ([priceStr integerValue] >= 100) {
                [IPCPayOrderManager sharedManager].discount  = 100;
            }else if ([priceStr integerValue] <= 0){
                [IPCPayOrderManager sharedManager].discount = 0;
            }else{
                [IPCPayOrderManager sharedManager].discount = [priceStr doubleValue];
            }
            ///重新计算金额
            [IPCPayOrderManager sharedManager].payAmount = [IPCCommon floorNumber:[[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] * ([IPCPayOrderManager sharedManager].discount/100)];
            [IPCPayOrderManager sharedManager].discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] - [IPCPayOrderManager sharedManager].payAmount;
            [[IPCPayOrderManager sharedManager] clearPayRecord];
        }else{
            if ([priceStr doubleValue] >= [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice]) {
                [IPCPayOrderManager sharedManager].payAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice];
            }else{
                [IPCPayOrderManager sharedManager].payAmount = [priceStr doubleValue];
            }
            ///重新计算金额
            [IPCPayOrderManager sharedManager].discount = [[IPCPayOrderManager sharedManager] calculateDiscount];
            [IPCPayOrderManager sharedManager].discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] - [IPCPayOrderManager sharedManager].payAmount;
        }
        [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
        [IPCPayOrderManager sharedManager].customDiscount = -1;
    }
    [self updateOrderInfo];
    
    if (self.EndEditingBlock) {
        self.EndEditingBlock();
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
