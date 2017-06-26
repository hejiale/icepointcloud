//
//  IPCOrderDetailOptometryCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOrderDetailOptometryCell.h"

@implementation IPCOrderDetailOptometryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    IPCOptometryMode * optometry = [IPCCustomOrderDetailList instance].optometryMode;
    
    NSArray * optometryInfo = @[[IPCCommon formatPurpose:optometry.purpose],
                                optometry.sphRight,
                                optometry.cylRight,
                                optometry.axisRight,
                                optometry.correctedVisionRight,
                                optometry.distanceRight,
                                optometry.addRight,
                                optometry.sphLeft,
                                optometry.cylLeft,
                                optometry.axisLeft,
                                optometry.correctedVisionLeft,
                                optometry.distanceLeft,
                                optometry.addLeft];
    [self createUI:optometryInfo];
    
    if (optometry && optometry.optometryEmployee.length) {
        [self.employeeNameLabel setText:[NSString stringWithFormat:@"验光师 %@",optometry.optometryEmployee]];
    }
    
    if (optometry && optometry.optometryInsertDate.length) {
        [self.insertDateLabel setText:[NSString stringWithFormat:@"验光日期 %@",[IPCCommon formatDate:[IPCCommon dateFromString:optometry.optometryInsertDate] IsTime:YES]]];
    }
}

- (void)createUI:(NSArray *)info
{
    [self.optometryContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSArray *lensItems = @[@"球镜/SPH", @"柱镜/CYL", @"轴位/AXIS", @"矫正视力/VA",@"瞳距/PD", @"下加光/ADD"];
    CGFloat  itemWidth = (self.optometryContentView.jk_width - 34 - 10)/3;
    CGFloat  spaceWidth   = 0;
    CGFloat  spaceHeight  = 30;
    
    
    for (int i = 0; i < 3; i++) {
        UIView *lensView = [[UIView alloc] initWithFrame:CGRectMake(0, (20 + spaceHeight) * i + 10, self.optometryContentView.jk_width, 40)];
        [self.optometryContentView addSubview:lensView];
        
        UIImageView *imgView = nil;
        if ( i < 3) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 20)];
            if (i == 0) {
                [imgView setImage:[UIImage imageNamed:@"icon_optometry_function"]];
            }else if (i == 1){
                [imgView setImage:[UIImage imageNamed:@"icon_right_optometry"]];
            }else{
                [imgView setImage:[UIImage imageNamed:@"icon_left_optometry"]];
            }
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [lensView addSubview:imgView];
        }
        
        if ( i > 0) {
            for (int j = 0; j < lensItems.count; j++) {
                if (j < 3) {
                    [lensView addSubview:[self createLensView:CGRectMake(34 + 10 + (itemWidth + spaceWidth) * j, 0, itemWidth, 15) Label:lensItems[j] Value:info[(i-1)*6 +j + 1]]];
                }else{
                    [lensView addSubview:[self createLensView:CGRectMake(34 + 10 + (itemWidth + spaceWidth) *( j-3), 20, itemWidth, 15) Label:lensItems[j] Value:info[(i-1)*6 +j + 1]]];
                }
            }
        }else{
            [lensView addSubview:[self createFunctionView:CGRectMake(34 + 10, 0, itemWidth, 20) Value:info[0]]];
        }
        [IPCCustomUI clearAutoCorrection:lensView];
    }
}

- (UIView *)createLensView:(CGRect)rect Label:(NSString *)label Value:(NSString *)value
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView setBackgroundColor:[UIColor clearColor]];
    
    UIFont * font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    CGFloat width = [label jk_sizeWithFont:font constrainedToHeight:itemView.jk_height].width;
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, itemView.jk_height)];
    lbl.textColor = [UIColor darkGrayColor];
    lbl.text = label;
    lbl.font = font;
    lbl.backgroundColor = [UIColor clearColor];
    [itemView addSubview:lbl];
    
    UILabel * valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(lbl.jk_right, 0, itemView.jk_width - lbl.jk_right, itemView.jk_height)];
    valueLabel.textColor = [UIColor darkGrayColor];
    [valueLabel setText:value];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightThin];
    [itemView addSubview:valueLabel];
    
    return itemView;
}

- (UIView *)createFunctionView:(CGRect)rect Value:(NSString *)value
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    
    UIFont * font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    
    UILabel * valueLabel = [[UILabel alloc] initWithFrame:itemView.bounds];
    valueLabel.textColor = [UIColor darkGrayColor];
    valueLabel.font = font;
    [valueLabel setText:value];
    [itemView addSubview:valueLabel];
    
    return itemView;
}


@end
