//
//  MJRefreshAnimationFooter.m
//  IcePointCloud
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRefreshAnimationFooter.h"


@implementation IPCRefreshAnimationFooter

- (void)prepare{
    [super prepare];
    
    [self.stateLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
    [self.stateLabel setTextColor:[UIColor lightGrayColor]];
    [self setTitle:@"" forState: MJRefreshStateIdle];
    [self setTitle:@"" forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
}

@end
