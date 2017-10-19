//
//  IPCOrderDetailPayRecordCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOrderDetailPayRecordCell.h"

@implementation IPCOrderDetailPayRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setRecordList:(NSArray<IPCPayRecord *> *)recordList{
    _recordList = recordList;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_recordList.count) {
        [_recordList enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IPCCustomDetailOrderPayRecordView * recordView  = [[IPCCustomDetailOrderPayRecordView alloc]initWithFrame:CGRectMake(28, 40*idx, self.jk_width-56, 40)];
            recordView.payType = obj;
            [self.contentView addSubview:recordView];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
