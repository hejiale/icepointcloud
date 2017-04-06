//
//  HistoryOptometryCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCHistoryOptometryCell.h"

@interface IPCHistoryOptometryCell()


@end

@implementation IPCHistoryOptometryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode
{
    if (optometryMode) {
//        NSArray * optometryContent = @[[NSString stringWithFormat:@"%@",optometryMode.sphRight],[NSString stringWithFormat:@"%@",optometryMode.cylRight],[NSString stringWithFormat:@"%@",optometryMode.axisRight],[NSString stringWithFormat:@"%@",optometryMode.addRight],[NSString stringWithFormat:@"%@",optometryMode.correctedVisionRight],[NSString stringWithFormat:@"%@",optometryMode.sphLeft],[NSString stringWithFormat:@"%@",optometryMode.cylLeft],[NSString stringWithFormat:@"%@",optometryMode.axisLeft],[NSString stringWithFormat:@"%@",optometryMode.addLeft],[NSString stringWithFormat:@"%@",optometryMode.correctedVisionLeft],[NSString stringWithFormat:@"%@",optometryMode.distance]];
//        
//        CGFloat orignX = self.selectButton.hidden ? 48 : self.selectButton.jk_right;
//        
//        
//        self.optometryView = [[IPCEditOptometryView alloc]initWithFrame:CGRectMake(orignX, 15, SCREEN_WIDTH - orignX - 48, 124) LensViewHeight:28 ItemWidth:(SCREEN_WIDTH - 20 * 4 - orignX - 48 - 58)/5 OrignSpace:20 Spaceing:20 OptometryInfo:optometryContent IsCanEdit:NO];
//        [self.contentView addSubview:self.optometryView];
//        
//        [self.dateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[IPCCommon dateFromString:optometryMode.insertDate]  IsTime:YES]]];
    }
}


- (IBAction)selectOptometryAction:(id)sender {
  
}


@end
