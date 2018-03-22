//
//  IPCShowOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCShowOptometryView.h"

@interface IPCShowOptometryView()

@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertDateLabel;
@property (strong, nonatomic) UIView *optometryContentView;

@end

@implementation IPCShowOptometryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCShowOptometryView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}
//
//- (UIView *)optometryContentView{
//    if (!_optometryContentView) {
//        _optometryContentView = [[UIView alloc]initWithFrame:CGRectZero];
//    }
//    return _optometryContentView;
//}
//
//
//- (void)createUIWithOptometry:(IPCOptometryMode *)optometry
//{
//    if (optometry) {
//        NSArray * optometryInfo = @[[IPCCommon formatPurpose:optometry.purpose],
//                                    optometry.sphRight,
//                                    optometry.cylRight,
//                                    optometry.axisRight,
//                                    optometry.correctedVisionRight,
//                                    optometry.distanceRight,
//                                    optometry.addRight,
//                                    optometry.sphLeft,
//                                    optometry.cylLeft,
//                                    optometry.axisLeft,
//                                    optometry.correctedVisionLeft,
//                                    optometry.distanceLeft,
//                                    optometry.addLeft,
//                                    optometry.comprehensive ? : @""];
//        [self createUI:optometryInfo];
//
//        if (optometry && optometry.optometryEmployee.length) {
//            NSString * employeeStr = [NSString stringWithFormat:@"验光师 %@",optometry.optometryEmployee];
//            [self.employeeNameLabel subStringWithText:employeeStr BeginRang:4 Font:nil Color:[UIColor darkGrayColor]];
//        }
//
//        if (optometry && optometry.employeeName.length) {
//            NSString * employeeStr = [NSString stringWithFormat:@"验光师 %@",optometry.employeeName];
//            [self.employeeNameLabel subStringWithText:employeeStr BeginRang:4 Font:nil Color:[UIColor darkGrayColor]];
//        }
//
//        if (optometry && optometry.optometryInsertDate.length) {
//            NSString * dateStr = [NSString stringWithFormat:@"验光日期 %@",[IPCCommon formatDate:[IPCCommon dateFromString:optometry.optometryInsertDate] IsTime:YES]];
//            [self.insertDateLabel subStringWithText:dateStr BeginRang:5  Font:nil Color:[UIColor darkGrayColor]];
//        }
//
//        if (optometry && optometry.insertDate.length) {
//            NSString * dateStr = [NSString stringWithFormat:@"验光日期 %@",[IPCCommon formatDate:[IPCCommon dateFromString:optometry.insertDate] IsTime:YES]];
//            [self.insertDateLabel subStringWithText:dateStr BeginRang:5 Font:nil Color:[UIColor darkGrayColor]];
//        }
//    }
//}
//
//- (void)createUI:(NSArray *)info
//{
//    [self.optometryContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
//
//    NSArray *lensItems = @[@"球镜/SPH", @"柱镜/CYL", @"轴位/AXIS", @"矫正视力/VA",@"瞳距/PD", @"下加光/ADD"];
//    CGFloat  itemWidth = (self.optometryContentView.jk_width - 42 - 10)/3;
//    CGFloat  spaceHeight  = 45;
//
//
//    for (int i = 0; i < 3; i++) {
//        UIView *lensView = [[UIView alloc] init];
//        if (i == 0) {
//            [lensView setFrame:CGRectMake(0, 0, self.optometryContentView.jk_width, 20)];
//        }else if (i == 1) {
//            [lensView setFrame:CGRectMake(0, 35, self.optometryContentView.jk_width, spaceHeight)];
//        }else{
//            [lensView setFrame:CGRectMake(0, spaceHeight * i + 5, self.optometryContentView.jk_width, spaceHeight)];
//        }
//        [self.optometryContentView addSubview:lensView];
//
//        UIImageView *imgView = nil;
//        if ( i < 3) {
//            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 20)];
//            if (i == 0) {
//                [imgView setImage:[UIImage imageNamed:@"icon_optometry_function"]];
//            }else if (i == 1){
//                [imgView setImage:[UIImage imageNamed:@"icon_right_optometry"]];
//            }else{
//                [imgView setImage:[UIImage imageNamed:@"icon_left_optometry"]];
//            }
//            imgView.contentMode = UIViewContentModeScaleAspectFit;
//            [lensView addSubview:imgView];
//        }
//
//        if ( i > 0) {
//            for (int j = 0; j < lensItems.count; j++) {
//                if (j < 3) {
//                    [lensView addSubview:[self createLensView:CGRectMake(42 + 10 + itemWidth * j, 0, itemWidth, 15) Label:lensItems[j] Value:info[(i-1)*6 +j + 1]]];
//                }else{
//                    [lensView addSubview:[self createLensView:CGRectMake(42 + 10 + itemWidth *( j-3), 30, itemWidth, 15) Label:lensItems[j] Value:info[(i-1)*6 +j + 1]]];
//                }
//            }
//        }else{
//            [lensView addSubview:[self createFunctionView:CGRectMake(42 + 10, 0, lensView.jk_width, 20) Function:info[0] Comprehensive:info[13]]];
//        }
//        [IPCCommonUI clearAutoCorrection:lensView];
//    }
//}
//
//- (UIView *)createLensView:(CGRect)rect Label:(NSString *)label Value:(NSString *)value
//{
//    UIView *itemView = [[UIView alloc] initWithFrame:rect];
//    [itemView setBackgroundColor:[UIColor clearColor]];
//
//    UIFont * font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
//    CGFloat width = [label jk_sizeWithFont:font constrainedToHeight:itemView.jk_height].width;
//
//    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, itemView.jk_height)];
//    lbl.textColor = [UIColor lightGrayColor];
//    lbl.text = label;
//    lbl.font = font;
//    lbl.backgroundColor = [UIColor clearColor];
//    [itemView addSubview:lbl];
//
//    UILabel * valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(lbl.jk_right, 0, itemView.jk_width - lbl.jk_right, itemView.jk_height)];
//    valueLabel.textColor = [UIColor darkGrayColor];
//    [valueLabel setText:value];
//    valueLabel.textAlignment = NSTextAlignmentCenter;
//    valueLabel.font = font;
//    [itemView addSubview:valueLabel];
//
//    return itemView;
//}
//
//- (UIView *)createFunctionView:(CGRect)rect Function:(NSString *)function Comprehensive:(NSString *)comprehensive
//{
//    UIView *itemView = [[UIView alloc] initWithFrame:rect];
//
//    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, itemView.jk_height)];
//    lbl.textColor = [UIColor lightGrayColor];
//    lbl.text = @"用途";
//    lbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
//    lbl.backgroundColor = [UIColor clearColor];
//    [itemView addSubview:lbl];
//
//    UILabel * functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(lbl.jk_right, 0, 60, itemView.jk_height)];
//    functionLabel.textColor = [UIColor darkGrayColor];
//    functionLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
//    [functionLabel setText:function];
//    [itemView addSubview:functionLabel];
//
//    lbl = [[UILabel alloc] initWithFrame:CGRectMake(functionLabel.jk_right, 0, 60, itemView.jk_height)];
//    lbl.textColor = [UIColor lightGrayColor];
//    lbl.text = @"综合瞳距";
//    lbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
//    lbl.backgroundColor = [UIColor clearColor];
//    [itemView addSubview:lbl];
//
//    UILabel * comprehensiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(lbl.jk_right, 0, 150, itemView.jk_height)];
//    comprehensiveLabel.textColor = [UIColor darkGrayColor];
//    comprehensiveLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
//    [comprehensiveLabel setText:comprehensive];
//    [itemView addSubview:comprehensiveLabel];
//
//    return itemView;
//}

@end
