//
//  IPCPayOrderMemoCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/5/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderMemoCell.h"

@implementation IPCPayOrderMemoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.memoTextView setPlaceholder:@"请输入订单备注信息..."];
    [self.memoTextView addBorder:3 Width:0.5 Color:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.memoTextView setText:[IPCPayOrderManager sharedManager].remark];
}

#pragma mark //UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString * str = [textView.text jk_trimmingWhitespace];
    if (str.length) {
        [IPCPayOrderManager sharedManager].remark = str;
    }
}


@end
