//
//  IPCPayOrderOptometryHeadView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryHeadView.h"

@interface IPCPayOrderOptometryHeadView()

@property (nonatomic, copy) void(^ChooseOptometryBlock)();
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;

@end

@implementation IPCPayOrderOptometryHeadView

- (instancetype)initWithFrame:(CGRect)frame ChooseBlock:(void(^)())choose
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ChooseOptometryBlock = choose;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOptometryHeadView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)updateOptometryInfo
{
    IPCOptometryMode * optometry = [IPCCurrentCustomer sharedManager].currentOpometry;
    
    if (optometry) {
        [self.employeeNameLabel setText:optometry.employeeName];
        [self.functionLabel setText:[IPCCommon formatPurpose:optometry.purpose]];
    }
}

- (IBAction)selectOptometryAction:(id)sender {
    if (self.ChooseOptometryBlock) {
        self.ChooseOptometryBlock();
    }
}


@end
