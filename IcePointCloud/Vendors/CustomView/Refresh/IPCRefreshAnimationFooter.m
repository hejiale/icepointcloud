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

    self.mj_h = 35;
    
    NSMutableArray<UIImage *> * loadingArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 1 ; i< 17; i++) {
        UIImage * loadImg = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ld",(long)i]];
        [loadingArray addObject:loadImg];
    }
    
    [self setImages:@[[UIImage imageNamed:@"loading_normal"]] forState:MJRefreshStateIdle];
    [self setImages:loadingArray duration:1.6 forState:MJRefreshStateRefreshing];
    
    self.labelLeftInset = 10;
    [self.stateLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"～抱歉，没有更多了～" forState:MJRefreshStateNoMoreData];
}

- (void)resetDataStatus{
    [self resetNoMoreData];
}


- (void)noticeNoDataStatus
{
    [self endRefreshingWithNoMoreData];
}

@end
