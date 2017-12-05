//
//  IPCShowOptometryInfoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryInfoView.h"

@interface IPCPayOrderOptometryInfoView()

@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
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
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
@property (nonatomic, copy) void(^ChooseOptometryBlock)();

@end


@implementation IPCPayOrderOptometryInfoView

- (instancetype)initWithFrame:(CGRect)frame ChooseBlock:(void(^)())choose
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ChooseOptometryBlock = choose;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOptometryInfoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self updateOptometryInfo];
    }
    return self;
}

- (IBAction)selectOptometryAction:(id)sender {
    if (self.ChooseOptometryBlock) {
        self.ChooseOptometryBlock();
    }
}

- (void)updateOptometryInfo
{
    IPCOptometryMode * optometry = [IPCCurrentCustomer sharedManager].currentOpometry;
    
    if (optometry) {
        [self.employeeNameLabel setText:optometry.employeeName];
        [self.functionLabel setText:[IPCCommon formatPurpose:optometry.purpose]];
        
        [self.leftSphLabel setText:optometry.sphLeft];
        [self.leftCylLabel setText:optometry.cylLeft];
        [self.leftAxisLabel setText:optometry.axisLeft];
        [self.leftAddLabel setText:optometry.addLeft];
        [self.leftCorrectionLabel setText:optometry.correctedVisionLeft];
        [self.leftDistanceLabel setText:optometry.distanceLeft];
        
        [self.rightSphLabel setText:optometry.sphRight];
        [self.rightCylLabel setText:optometry.cylRight];
        [self.rightAxisLabel setText:optometry.axisRight];
        [self.rightAddLabel setText:optometry.addRight];
        [self.rightCorrectionLabel setText:optometry.correctedVisionRight];
        [self.rightDistanceLabel setText:optometry.distanceRight];
        
        [self.memoLabel setText:optometry.remark];
    }
}

@end
