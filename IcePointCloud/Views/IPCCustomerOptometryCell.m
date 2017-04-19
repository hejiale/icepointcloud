//
//  HistoryOptometryCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerOptometryCell.h"


@implementation IPCCustomerOptometryCell

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
    _optometryMode = optometryMode;
    
    if (_optometryMode) {
        [self createUI];
        [self.employeeLabel setText:_optometryMode.employeeName];
        if (_optometryMode.insertDate && _optometryMode.insertDate.length) {
            [self.insertDateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[IPCCommon dateFromString:_optometryMode.insertDate]  IsTime:YES]]];
        }else{
            [self.insertDateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[NSDate date] IsTime:YES]]];
        }
        
    }
}

#pragma mark //Set Data
- (NSArray *)optometryInfo{
    return @[self.optometryMode.purpose,
             self.optometryMode.sphRight,
             self.optometryMode.cylRight,
             self.optometryMode.axisRight,
             self.optometryMode.correctedVisionRight,
             self.optometryMode.distanceRight,
             self.optometryMode.addRight,
             self.optometryMode.sphLeft,
             self.optometryMode.cylLeft,
             self.optometryMode.axisLeft,
             self.optometryMode.correctedVisionLeft,
             self.optometryMode.distanceLeft,
             self.optometryMode.addLeft,];
}

#pragma mark //Set UI
- (UIButton *)defaultButton{
    if (!_defaultButton) {
        _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultButton setTitle:@"默认验光单" forState:UIControlStateNormal];
        [_defaultButton setImage:[UIImage imageNamed:@"icon_undefault"] forState:UIControlStateNormal];
        [_defaultButton setImage:[UIImage imageNamed:@"icon_default"] forState:UIControlStateSelected];
        [_defaultButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
        [_defaultButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_defaultButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        _defaultButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _defaultButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_defaultButton setBackgroundColor:[UIColor clearColor]];
        [_defaultButton addTarget:self action:@selector(setDefaultOptometryAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultButton;
}

- (void)createUI
{
   [self.optometryContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [obj removeFromSuperview];
   }];
    
    NSArray *lensItems = @[@"球镜/SPH", @"柱镜/CYL", @"轴位/AXIS", @"矫正视力/VA",@"单眼瞳距/PD", @"下加光/ADD"];
    CGFloat  itemWidth = 130;
    CGFloat  spaceWidth   = (self.optometryContentView.jk_width - 34 - 20 -itemWidth * 6) /5;
    CGFloat  spaceHeight  = 15;
    
    
    for (int i = 0; i < 3; i++) {
        UIView *lensView = [[UIView alloc] initWithFrame:CGRectMake(0, (20 + spaceHeight) * i, self.optometryContentView.jk_width, 20)];
        [self.optometryContentView addSubview:lensView];
        
        if (i == 0) {
            [lensView addSubview:self.defaultButton];
            [self.defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lensView.mas_right).offset(0);
                make.top.equalTo(lensView.mas_top).offset(-5);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(30);
            }];
        }
        
        UIImageView *imgView = nil;
        if ( i < 3) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, lensView.jk_height)];
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
                [lensView addSubview:[self createLensView:CGRectMake(34 + 20 + (itemWidth + spaceWidth) * j, 0, itemWidth, lensView.jk_height) Label:lensItems[j] Value:[self optometryInfo][j + 1 + (i-1)*6] Tag:(j + 1 + (i-1)*6)]];
            }
        }else{
            [lensView addSubview:[self createFunctionView:CGRectMake(34 + 20, 0, itemWidth, lensView.jk_height) Value:[self optometryInfo][0]]];
        }
        [IPCCustomUI clearAutoCorrection:lensView];
    }
}

- (UIView *)createLensView:(CGRect)rect Label:(NSString *)label Value:(NSString *)value Tag:(NSInteger)tag
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView setBackgroundColor:[UIColor clearColor]];
    
    UIFont * font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    
    CGFloat width = [label jk_sizeWithFont:font constrainedToHeight:itemView.jk_height].width;
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width+5, itemView.jk_height)];
    lbl.textColor = [UIColor darkGrayColor];
    lbl.text = label;
    lbl.font = font;
    lbl.backgroundColor = [UIColor clearColor];
    [itemView addSubview:lbl];
    
    UILabel * valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(lbl.jk_right, 0, itemView.jk_width - lbl.jk_right, itemView.jk_height)];
    valueLabel.textColor = [UIColor darkGrayColor];
    [valueLabel setText:value];
    if (tag == 6 || tag == 12) {
        [valueLabel setTextAlignment:NSTextAlignmentRight];
    }else{
        [valueLabel setTextAlignment:NSTextAlignmentCenter];
    }
    valueLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
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

#pragma mark //Clicked Events
- (void)setDefaultOptometryAction:(id)sender{
}


@end
