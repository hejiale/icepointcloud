//
//  IPCCustomsizedOtherView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedOtherView.h"

@implementation IPCCustomsizedOtherView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomsizedOtherView" owner:self];
        [self addSubview:view];
    }
    return self;
}


- (IBAction)deleteAction:(id)sender {
}

@end
