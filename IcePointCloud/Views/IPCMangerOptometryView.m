//
//  IPCMangerOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCMangerOptometryView.h"

@interface IPCMangerOptometryView()

@property (weak, nonatomic) IBOutlet UILabel *insertDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (strong, nonatomic) IBOutlet UIView  *optometryContentView;

@end

@implementation IPCMangerOptometryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCMangerOptometryView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)createUIWithOptometry:(IPCOptometryMode *)optometry
{
    [self.optometryContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (optometry.isUpdateStatus) {
        if (optometry && optometry.optometryEmployee.length) {
            NSString * employeeStr = [NSString stringWithFormat:@"验光师 %@",optometry.optometryEmployee];
            [self.employeeLabel subStringWithText:employeeStr BeginRang:4 Font:nil Color:[UIColor darkGrayColor]];
        }
        if (optometry && optometry.optometryInsertDate.length) {
            NSString * dateStr = [NSString stringWithFormat:@"验光日期 %@",[IPCCommon formatDate:[IPCCommon dateFromString:optometry.optometryInsertDate] IsTime:YES]];
            [self.insertDateLabel subStringWithText:dateStr BeginRang:5 Font:nil Color:[UIColor darkGrayColor]];
        }
    }else{
        if (optometry && optometry.employeeName.length) {
            NSString * employeeStr = [NSString stringWithFormat:@"验光师 %@",optometry.employeeName];
            [self.employeeLabel subStringWithText:employeeStr BeginRang:4  Font:nil Color:[UIColor darkGrayColor]];
        }
        if (optometry && optometry.insertDate.length) {
            NSString * dateStr = [NSString stringWithFormat:@"验光日期 %@",[IPCCommon formatDate:[IPCCommon dateFromString:optometry.insertDate] IsTime:YES]];
            [self.insertDateLabel subStringWithText:dateStr BeginRang:5 Font:nil Color:[UIColor darkGrayColor]];
        }
    }
    
    NSArray *lensItems = @[@"球镜/SPH", @"柱镜/CYL", @"轴位/AXIS", @"矫正视力/VA",@"瞳距/PD", @"下加光/ADD"];
    CGFloat  itemWidth = 130;
    CGFloat  spaceWidth   = (self.optometryContentView.jk_width - 34 - 20 -itemWidth * 6) /5;
    CGFloat  spaceHeight  = 15;
    
    
    for (int i = 0; i < 3; i++) {
        UIView *lensView = [[UIView alloc] initWithFrame:CGRectMake(0, (20 + spaceHeight) * i, self.optometryContentView.jk_width, 20)];
        [self.optometryContentView addSubview:lensView];
        
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
                [lensView addSubview:[self createLensView:CGRectMake(34 + 20 + (itemWidth + spaceWidth) * j, 0, itemWidth, lensView.jk_height) Label:lensItems[j] Value:[self optometryInfo:optometry][j + 1 + (i-1)*6] Tag:(j + 1 + (i-1)*6)]];
            }
        }else{
            [lensView addSubview:[self createFunctionView:CGRectMake(34 + 20, 0, itemWidth, lensView.jk_height) Value:[self optometryInfo:optometry][0]]];
        }
        [IPCCommonUI clearAutoCorrection:lensView];
    }
}

- (UIView *)createLensView:(CGRect)rect Label:(NSString *)label Value:(NSString *)value Tag:(NSInteger)tag
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView setBackgroundColor:[UIColor clearColor]];
    
    UIFont * font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    
    CGFloat width = [label jk_sizeWithFont:font constrainedToHeight:itemView.jk_height].width;
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width+5, itemView.jk_height)];
    lbl.textColor = [UIColor lightGrayColor];
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
    valueLabel.font = font;
    [itemView addSubview:valueLabel];
    
    return itemView;
}

- (UIView *)createFunctionView:(CGRect)rect Value:(NSString *)value
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    
    UILabel * valueLabel = [[UILabel alloc] initWithFrame:itemView.bounds];
    valueLabel.textColor = [UIColor darkGrayColor];
    valueLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    [valueLabel setText:value];
    [itemView addSubview:valueLabel];
    
    return itemView;
}

- (NSArray *)optometryInfo:(IPCOptometryMode *)optometry
{
    return @[[IPCCommon formatPurpose:optometry.purpose],
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
             optometry.addLeft,];
}


@end
