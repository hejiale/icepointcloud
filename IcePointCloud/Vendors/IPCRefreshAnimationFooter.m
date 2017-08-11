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
    [self setTitle:@"全部加载完毕!" forState:MJRefreshStateNoMoreData];
    [self.stateLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
    [self.stateLabel setTextColor:[UIColor lightGrayColor]];
    self.refreshingTitleHidden = YES;
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
