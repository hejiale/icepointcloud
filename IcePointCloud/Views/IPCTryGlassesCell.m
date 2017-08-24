//
//  IPCTryGlassesCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCTryGlassesCell.h"

@implementation IPCTryGlassesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __block CGFloat height = (SCREEN_HEIGHT - 70)/4;
        
        __weak typeof(self) weakSelf = self;
        IPCTryGlassesView * glassView = [[IPCTryGlassesView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.jk_width, height) ChooseParameter:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(chooseParameter:)]) {
                [strongSelf.delegate chooseParameter:self];
            }
        } EditParameter:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(editBatchParameter:)]) {
                [strongSelf.delegate editBatchParameter:self];
            }
        } AddCart:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(reloadProductList)]) {
                [strongSelf.delegate reloadProductList];
            }
        } ReduceCart:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(reloadProductList)]) {
                [strongSelf.delegate reloadProductList];
            }
        } TryGlasses:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(tryGlasses:)]) {
                [strongSelf.delegate tryGlasses:self];
            }
        }];
        glassView.glasses = _glasses;
        [self.contentView addSubview:glassView];
    }
}


@end
