//
//  IPCPayOrderOptometryMemoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryMemoView.h"

@interface IPCPayOrderOptometryMemoView()

@property (weak, nonatomic) IBOutlet UILabel *memoLabel;

@end

@implementation IPCPayOrderOptometryMemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOptometryMemoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)updateOptometryInfo
{
    IPCOptometryMode * optometry = [IPCCurrentCustomer sharedManager].currentOpometry;
    
    if (optometry) {
        [self.memoLabel setText:optometry.remark];
    }
}

@end
