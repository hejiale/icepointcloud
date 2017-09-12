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
    
    if ([IPCPayOrderManager sharedManager].payTypeRecordArray.count) {
        [self.payRecordContentView setHidden:NO];
        self.payRecordHeight.constant = [IPCPayOrderManager sharedManager].payTypeRecordArray.count * 35;
        [self.payRecordContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [[IPCPayOrderManager sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull payRecord, NSUInteger idx, BOOL * _Nonnull stop) {
            IPCSwipeView * swipeView = [[IPCSwipeView alloc]initWithFrame:CGRectMake(0, 35*idx, self.payRecordContentView.jk_width, 35)];
            [self.payRecordContentView addSubview:swipeView];
            [self.recordViews addObject:swipeView];
            
            IPCPayTypeRecordView * recordView = [[IPCPayTypeRecordView alloc]initWithFrame:swipeView.bounds];
            recordView.payRecord = payRecord;
            
            [swipeView setContentView:recordView];
            swipeView.swipeBlock = ^{
                [self.recordViews enumerateObjectsUsingBlock:^(IPCSwipeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj isEqual:swipeView]) {
                        obj.isOpen = NO;
                    }
                }];
            };
            
            [[swipeView rac_signalForSelector:@selector(deleteAction)] subscribeNext:^(RACTuple * _Nullable x) {
                [[IPCPayOrderManager sharedManager].payTypeRecordArray removeObjectAtIndex:idx];
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
    
    if ([IPCPayOrderManager sharedManager].isInsertRecordStatus) {
        [self.insertRecordView setHidden:NO];
        self.insertRecordHeight.constant = 40;
        
        if ([IPCPayOrderManager sharedManager].insertPayRecord) {
            [self.payTypeTextField setText:[IPCPayOrderManager sharedManager].insertPayRecord.payTypeInfo];
            [self.payTypeImageView setImage:[[IPCAppManager sharedManager] payTypeImage:[IPCPayOrderManager sharedManager].insertPayRecord.payTypeInfo]];
            
            if ([IPCPayOrderManager sharedManager].insertPayRecord.payPrice > 0) {
                [self.payAmountTextField setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].insertPayRecord.payPrice]];
            }
        }
    }else{
        [self.insertRecordView setHidden:YES];
        self.insertRecordHeight.constant = 0;
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
- (IBAction)sureInsertAction:(id)sender {
    if (!self.payTypeTextField.text.length || !self.payAmountTextField.text.length){
        [IPCCommonUI showError:@"付款方式或付款金额为空!"];
        return;
    }
    
    IPCPayRecord * payRecord = [[IPCPayRecord alloc]init];
    payRecord.payTypeInfo = self.payTypeTextField.text;
    
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= [self.payAmountTextField.text doubleValue]) {
        payRecord.payPrice = [[IPCPayOrderManager sharedManager] remainPayPrice];
    }else{
        payRecord.payPrice = [self.payAmountTextField.text doubleValue];
    }
    
    [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:payRecord];
    [IPCPayOrderManager sharedManager].isInsertRecordStatus = NO;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IBAction)closeInsertAction:(id)sender {
    [IPCPayOrderManager sharedManager].isInsertRecordStatus = NO;
    [IPCPayOrderManager sharedManager].insertPayRecord = nil;
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= [textField.text doubleValue]) {
        [IPCPayOrderManager sharedManager].insertPayRecord.payPrice = [[IPCPayOrderManager sharedManager] remainPayPrice];
    }else{
        [IPCPayOrderManager sharedManager].insertPayRecord.payPrice = [textField.text doubleValue];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}
#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    return @[@"现金",@"刷卡",@"支付宝",@"微信",@"其他"];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    [self.payTypeTextField setText:parameter];
    [IPCPayOrderManager sharedManager].insertPayRecord.payTypeInfo = parameter;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}


@end
