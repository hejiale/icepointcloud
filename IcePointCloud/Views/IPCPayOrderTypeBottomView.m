//
//  IPCPayOrderTypeBottomView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderTypeBottomView.h"

@implementation IPCPayOrderTypeBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderTypeBottomView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (IBAction)selectOtherPayStyleAction:(id)sender {
    
}

- (IBAction)payOrderAction:(id)sender {
}


@end
