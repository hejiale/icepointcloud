//
//  IPCShowOptometryInfoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryInfoView.h"

@interface IPCPayOrderOptometryInfoView()

@property (weak, nonatomic) IBOutlet UILabel *leftSphLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCylLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAxisLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCorrectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightSphLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCylLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAxisLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCorrectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBasalLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBasalLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPrismLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPrismRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceHeightRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceHeightLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceAFMLabel;
@property (weak, nonatomic) IBOutlet UILabel *comprehensiveLabel;

@end


@implementation IPCPayOrderOptometryInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOptometryInfoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateOptometryInfo];
}

- (void)updateOptometryInfo
{
    IPCOptometryMode * optometry = [IPCPayOrderCurrentCustomer sharedManager].currentOpometry;
    
    if (optometry)
    {
        [self.leftSphLabel setText:optometry.sphLeft];
        [self.leftCylLabel setText:optometry.cylLeft];
        [self.leftAxisLabel setText:optometry.axisLeft];
        [self.leftAddLabel setText:optometry.addLeft];
        [self.leftCorrectionLabel setText:optometry.correctedVisionLeft];
        [self.leftDistanceLabel setText:optometry.distanceLeft];
        [self.leftBasalLabel setText:optometry.baseGlassesLeft];
        [self.distanceHeightLeftLabel setText:optometry.distanceHeightLeft];
        [self.glassPrismLeftLabel setText:optometry.glassPrismLeft];
        
        [self.rightSphLabel setText:optometry.sphRight];
        [self.rightCylLabel setText:optometry.cylRight];
        [self.rightAxisLabel setText:optometry.axisRight];
        [self.rightAddLabel setText:optometry.addRight];
        [self.rightCorrectionLabel setText:optometry.correctedVisionRight];
        [self.rightDistanceLabel setText:optometry.distanceRight];
        [self.rightBasalLabel setText:optometry.baseGlassesRight];
        [self.distanceHeightRightLabel setText:optometry.distanceHeightRight];
        [self.glassPrismRightLabel setText:optometry.glassPrismRight];
        
        [self.distanceAFMLabel setText:optometry.distanceAFM];
        [self.comprehensiveLabel setText:optometry.comprehensive];
    }
}




@end
