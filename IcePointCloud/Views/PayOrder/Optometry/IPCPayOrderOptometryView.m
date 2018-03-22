//
//  IPCPayOrderOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryView.h"

#define DefaultColor   [UIColor colorWithHexString:@"CFCFCF"]

@interface IPCPayOrderOptometryView()

@property (weak, nonatomic) IBOutlet UIView *purposeView;
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabl;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;

@end

@implementation IPCPayOrderOptometryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOptometryView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.purposeView addBorder:self.purposeView.jk_height/2 Width:0 Color:nil];
    
    __weak typeof(self) weakSelf = self;
    [self jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer)
     {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = _optometry;
        [weakSelf updateStatus];
    }];
}

- (void)setOptometry:(IPCOptometryMode *)optometry
{
    _optometry = optometry;
    
    if (_optometry) {
        [self updateStatus];
    
        [self.createDateLabl setText:[IPCCommon formatDate:[IPCCommon dateFromString:optometry.insertDate] IsTime:NO]];
        [self.employeeLabel setText:_optometry.employeeName];
    }
}

- (void)updateStatus
{
    if (![_optometry.optometryID isEqualToString:[IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID]) {
        [self addBorder:5 Width:1 Color: DefaultColor];
        [self.createDateLabl setTextColor:DefaultColor];
        [self.employeeLabel setTextColor:DefaultColor];
        [self.purposeView setBackgroundColor:DefaultColor];
    }else{
        [self addBorder:5 Width:1 Color:COLOR_RGB_BLUE];
        [self.createDateLabl setTextColor:COLOR_RGB_BLUE];
        [self.employeeLabel setTextColor:COLOR_RGB_BLUE];
        [self.purposeView setBackgroundColor:COLOR_RGB_BLUE];
    }
}



@end
