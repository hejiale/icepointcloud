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

    self.mj_h = 0;
    [self.stateLabel setHidden:YES];
    self.refreshingTitleHidden = YES;
    self.pullingPercent = 0;
}

- (void)resetDataStatus{
    self.mj_h = 0;
    [self resetNoMoreData];
}


- (void)noticeNoDataStatus
{
    self.mj_h = 50;
    [self endRefreshingWithNoMoreData];
}

@end
