//
//  IPCShowOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCShowOptometryView.h"

@interface IPCShowOptometryView()

@property (weak, nonatomic) IBOutlet UILabel *rightSphLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftSphLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCylLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCylLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAxisLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAxisLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctedVisionLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctedVisionRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBasalLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBasalLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPrismRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPrismLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceHeightRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceHeightLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *comprehensiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceAFMLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;


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

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode
{
    _optometryMode = optometryMode;
    
    if (_optometryMode) {
        [self.leftSphLabel setText:_optometryMode.sphLeft];
        [self.rightSphLabel setText:_optometryMode.sphRight];
        [self.leftCylLabel setText:_optometryMode.cylLeft];
        [self.rightCylLabel setText:_optometryMode.cylRight];
        [self.leftAxisLabel setText:_optometryMode.axisLeft];
        [self.rightAxisLabel setText:_optometryMode.axisRight];
        [self.leftAddLabel setText:_optometryMode.addLeft];
        [self.rightAddLabel setText:_optometryMode.addRight];
        [self.correctedVisionLeftLabel setText:_optometryMode.correctedVisionLeft];
        [self.correctedVisionRightLabel setText:_optometryMode.correctedVisionRight];
        [self.distanceAFMLabel setText:_optometryMode.distanceAFM];
        [self.distanceHeightLeftLabel setText:_optometryMode.distanceHeightLeft];
        [self.distanceHeightRightLabel setText:_optometryMode.distanceHeightRight];
        [self.glassPrismLeftLabel setText:_optometryMode.glassPrismLeft];
        [self.glassPrismRightLabel setText:_optometryMode.glassPrismRight];
        [self.rightDistanceLabel setText:_optometryMode.distanceRight];
        [self.leftDistanceLabel setText:_optometryMode.distanceLeft];
        [self.rightBasalLabel setText:_optometryMode.baseGlassesRight];
        [self.leftBasalLabel setText:_optometryMode.baseGlassesLeft];
        [self.comprehensiveLabel setText:_optometryMode.comprehensive];
        [self.purposeLabel setText:[IPCCommon formatPurpose:_optometryMode.purpose]];
        
        if (_optometryMode.optometryEmployee && _optometryMode.optometryInsertDate) {
            [self.employeeNameLabel setText:[NSString stringWithFormat:@"%@ | %@", _optometryMode.optometryEmployee, [IPCCommon formatDate:[IPCCommon dateFromString:_optometryMode.optometryInsertDate] IsTime:YES]]];
        }
    }
    
}

@end
