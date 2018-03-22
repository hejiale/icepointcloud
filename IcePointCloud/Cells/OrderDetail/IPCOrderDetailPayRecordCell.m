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

- (void)setRecordList:(NSArray<IPCPayRecord *> *)recordList
{
    _recordList = recordList;

    if (_recordList.count) {
        __block CGFloat originY = 30;
        
        [_recordList enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            IPCCustomDetailOrderPayRecordView * recordView  = [[IPCCustomDetailOrderPayRecordView alloc]init];
            recordView.payType = obj;
            [self.contentView addSubview:recordView];
            
            [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).with.offset(28);
                make.right.equalTo(self.contentView.mas_right).with.offset(-28);
                make.top.equalTo(self.contentView.mas_top).with.offset(originY*idx);
                make.height.mas_equalTo(originY);
            }];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
