//
//  OrderMemoViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCartOrderMemoViewCell.h"

@implementation IPCCartOrderMemoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.memoTextView];
    
    __weak typeof(self) weakSelf = self;
    [self.memoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        make.left.equalTo(strongSelf.contentView.mas_left).with.offset(45);
        make.right.equalTo(strongSelf.contentView.mas_right).with.offset(-45);
        make.height.mas_equalTo(@80);
    }];
}


- (YYTextView *)memoTextView{
    if (!_memoTextView) {
        _memoTextView = [[YYTextView alloc]init];
        [_memoTextView setPlaceholderText:@"备注其它信息"];
        [_memoTextView setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
        [_memoTextView setTextColor:[UIColor darkGrayColor]];
        _memoTextView.textAlignment = NSTextAlignmentLeft;
        [_memoTextView setDelegate:self];
        [_memoTextView addBorder:5 Width:0.6];
    }
    return _memoTextView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark //UITextViewDelegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        NSString * trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [textView setText:trimmedString];
        [textView resignFirstResponder];
        [IPCPayOrderMode sharedManager].orderMemo = trimmedString;
        return NO;
    }
    return YES;
}

@end
