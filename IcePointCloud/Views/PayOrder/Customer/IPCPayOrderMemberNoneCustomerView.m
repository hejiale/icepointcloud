//
//  IPCPayOrderMemberNoneCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderMemberNoneCustomerView.h"

@interface IPCPayOrderMemberNoneCustomerView()

@property (weak, nonatomic) IBOutlet UIButton *createCustomerButton;
@property (weak, nonatomic) IBOutlet UIButton *createTouristsButton;


@end

@implementation IPCPayOrderMemberNoneCustomerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderMemberNoneCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.createCustomerButton addBorder:18 Width:1 Color:COLOR_RGB_BLUE];
        [self.createTouristsButton addBorder:18 Width:1 Color:COLOR_RGB_BLUE];
    }
    return self;
}

@end
