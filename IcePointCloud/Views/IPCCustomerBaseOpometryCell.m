//
//  UserBaseOpometryCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerBaseOpometryCell.h"

@interface IPCCustomerBaseOpometryCell()

@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCCustomerBaseOpometryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.completeButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.completeButton addSignleCorner:UIRectCornerAllCorners Size:45/2];
    
    self.editOptometryView = [[IPCEditOptometryView alloc]initWithFrame:CGRectMake(48, 80, self.optometryView.jk_width-80, 155)
                                                      LensViewHeight:35
                                                           ItemWidth:(self.optometryView.jk_width - 80 - 58 - 20 * 4)/5
                                                          OrignSpace:25
                                                            Spaceing:20
                                                       OptometryInfo:nil
                                                           IsCanEdit:YES];
    [self.contentView addSubview:self.editOptometryView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)completeAction:(id)sender {
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
}


- (void)setAllSubViewDisabled:(BOOL)isDisable Complete:(void (^)())complete{
    self.CompleteBlock = complete;
    
    [self.editOptometryView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setUserInteractionEnabled:!isDisable];
    }];
    [self.completeButton setHidden:isDisable];
}


@end
