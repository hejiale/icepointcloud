//
//  IPCPayTypeRecordCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayTypeRecordCell.h"

@implementation IPCPayTypeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.payTypeTextField setRightButton:self Action:@selector(selectPayTypeAction) OnView:self.insertRecordView];
    [self.payAmountTextField setLeftText:@"￥"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([IPCPayOrderMode sharedManager].payTypeRecordArray.count) {
        [self.payRecordContentView setHidden:NO];
        self.payRecordHeight.constant = [IPCPayOrderMode sharedManager].payTypeRecordArray.count * 50;
        [self.payRecordContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [[IPCPayOrderMode sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IPCSwipeView * swipeView = [[IPCSwipeView alloc]initWithFrame:CGRectMake(0, 50*idx, self.payRecordContentView.jk_width, 50)];
            [self.payRecordContentView addSubview:swipeView];
            [self.recordViews addObject:swipeView];
            
            IPCPayTypeRecordView * recordView = [[IPCPayTypeRecordView alloc]initWithFrame:swipeView.bounds];
            recordView.payRecord = obj;
            
            [swipeView setContentView:recordView];
            swipeView.swipeBlock = ^{
                [self.recordViews enumerateObjectsUsingBlock:^(IPCSwipeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj isEqual:swipeView]) {
                        obj.isOpen = NO;
                    }
                }];
            };
            
            [[swipeView rac_signalForSelector:@selector(deleteAction)] subscribeNext:^(RACTuple * _Nullable x) {
                [IPCPayOrderMode sharedManager].remainAmount += obj.payAmount;
                [[IPCPayOrderMode sharedManager].payTypeRecordArray removeObjectAtIndex:idx];
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
                        [self.delegate reloadUI];
                    }
                }
            }];
        }];
    }else{
        [self.payRecordContentView setHidden:YES];
        self.payRecordHeight.constant = 0;
    }
    
    if ([IPCPayOrderMode sharedManager].isInsertRecordStatus) {
        [self.insertRecordView setHidden:NO];
        if ([IPCPayOrderMode sharedManager].insertPayRecord) {
            [self.payTypeTextField setText:[IPCPayOrderMode sharedManager].insertPayRecord.payStyleName];
            if ([IPCPayOrderMode sharedManager].insertPayRecord.payAmount > 0) {
                [self.payAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderMode sharedManager].insertPayRecord.payAmount]];
            }
            if ([[IPCPayOrderMode sharedManager].insertPayRecord.payStyleName isEqualToString:@"储值余额"]) {
                [self.payAmountTextField setPlaceholder:[NSString stringWithFormat:@"可用余额%.2f",[IPCPayOrderMode sharedManager].balanceAmount - [IPCPayOrderMode sharedManager].usedBalanceAmount]];
            }
        }
    }else{
        [self.insertRecordView setHidden:YES];
    }
}


- (NSMutableArray<IPCSwipeView *> *)recordViews{
    if (!_recordViews) {
        _recordViews = [[NSMutableArray alloc]init];
    }
    return _recordViews;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark //Clicked Events
- (IBAction)insertRecordAction:(id)sender
{
    if ([IPCPayOrderMode sharedManager].remainAmount <= 0) {
        return;
    }
    if ([IPCPayOrderMode sharedManager].isInsertRecordStatus){
        return;
    }
    [IPCPayOrderMode sharedManager].isInsertRecordStatus = YES;
    [IPCPayOrderMode sharedManager].insertPayRecord = [[IPCPayRecord alloc]init];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IBAction)sureInsertAction:(id)sender {
    if (!self.payTypeTextField.text.length || !self.payAmountTextField.text.length)return;
    
    IPCPayRecord * payRecord = [[IPCPayRecord alloc]init];
    payRecord.payStyleName = self.payTypeTextField.text;
    payRecord.payStyle = [self payStyle];
    
    if ([IPCPayOrderMode sharedManager].remainAmount <= [self.payAmountTextField.text doubleValue]) {
        payRecord.payAmount = [IPCPayOrderMode sharedManager].remainAmount;
    }else{
        payRecord.payAmount = [self.payAmountTextField.text doubleValue];
    }
    [IPCPayOrderMode sharedManager].remainAmount -= payRecord.payAmount;
    if ([IPCPayOrderMode sharedManager].remainAmount <= 0) {
        [IPCPayOrderMode sharedManager].remainAmount = 0;
    }
    
    [[IPCPayOrderMode sharedManager].payTypeRecordArray addObject:payRecord];
    [IPCPayOrderMode sharedManager].isInsertRecordStatus = NO;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IBAction)closeInsertAction:(id)sender {
    [IPCPayOrderMode sharedManager].isInsertRecordStatus = NO;
    [IPCPayOrderMode sharedManager].insertPayRecord = nil;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (void)selectPayTypeAction{
    [self showParameterTabelView:self.payTypeTextField];
}

- (void)showParameterTabelView:(UITextField *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCParameterTableViewController * pickerVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate     = self;
    [pickerVC showWithPosition:CGPointMake(sender.jk_width/2, 0) Size:CGSizeMake(sender.jk_width, 150) Owner:sender Direction:UIPopoverArrowDirectionDown];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.payTypeTextField.text isEqualToString:@"储值余额"]) {
        if ([IPCPayOrderMode sharedManager].balanceAmount > 0) {
            if ([IPCPayOrderMode sharedManager].balanceAmount - [IPCPayOrderMode sharedManager].usedBalanceAmount <= 0) {
                [IPCPayOrderMode sharedManager].insertPayRecord.payAmount = 0;
            }else{
                [IPCPayOrderMode sharedManager].usedBalanceAmount += [textField.text doubleValue];
                [IPCPayOrderMode sharedManager].insertPayRecord.payAmount = [textField.text doubleValue];
            }
        }else{
            [IPCPayOrderMode sharedManager].insertPayRecord.payAmount = 0;
        }
    }else{
        if ([IPCPayOrderMode sharedManager].remainAmount <= [textField.text doubleValue]) {
            [IPCPayOrderMode sharedManager].insertPayRecord.payAmount = [IPCPayOrderMode sharedManager].remainAmount;
        }else{
            [IPCPayOrderMode sharedManager].insertPayRecord.payAmount = [textField.text doubleValue];
        }
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    return @[@"储值余额",@"现金",@"刷卡",@"支付宝",@"微信",@"其他"];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    [self.payTypeTextField setText:parameter];
    [IPCPayOrderMode sharedManager].insertPayRecord.payStyleName = parameter;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IPCPayStyleType)payStyle{
    if ([self.payTypeTextField.text isEqualToString:@"储值余额"]) {
        return IPCPayStyleTypeStoreValue;
    }else if ([self.payTypeTextField.text isEqualToString:@"现金"]){
        return IPCPayStyleTypeCash;
    }else if ([self.payTypeTextField.text isEqualToString:@"刷卡"]){
        return IPCPayStyleTypeCard;
    }else if ([self.payTypeTextField.text isEqualToString:@"支付宝"]){
        return IPCPayStyleTypeAlipay;
    }else if ([self.payTypeTextField.text isEqualToString:@"微信"]){
        return IPCPayStyleTypeWechat;
    }else if ([self.payTypeTextField.text isEqualToString:@"其它"]){
        return IPCPayStyleTypeOther;
    }
    return IPCPayStyleTypeNone;
}


@end
