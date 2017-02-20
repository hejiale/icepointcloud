//
//  MJRefreshAnimationHeader.m
//  IcePointCloud
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRefreshAnimationHeader.h"

@implementation IPCRefreshAnimationHeader

- (void)prepare{
    [super prepare];
    
    NSMutableArray<UIImage *> * loadingArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 1 ; i< 17; i++) {
        UIImage * loadImg = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%ld",(long)i]];
        [loadingArray addObject:loadImg];
    }
    
    self.automaticallyChangeAlpha = YES;
    [self.lastUpdatedTimeLabel setHidden:YES];
    [self.stateLabel setHidden:YES];
    [self setImages:@[[UIImage imageNamed:@"loading_normal"]] forState:MJRefreshStateIdle];
    [self setImages:loadingArray duration:1.6 forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
}


@end
