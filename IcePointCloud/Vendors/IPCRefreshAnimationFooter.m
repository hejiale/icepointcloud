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

    self.mj_h = 30;
    
    [self.stateLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"～没有更多商品了～" forState:MJRefreshStateNoMoreData];
}

- (void)resetDataStatus{
    [self resetNoMoreData];
}


- (void)noticeNoDataStatus
{
    [self endRefreshingWithNoMoreData];
}

@end
