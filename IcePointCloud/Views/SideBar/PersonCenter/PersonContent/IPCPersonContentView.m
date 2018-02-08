//
//  PersonContentView.m
//  IcePointCloud
//
//  Created by gerry on 2017/10/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPersonContentView.h"

@implementation IPCPersonContentView


- (void)show
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGRect frame = strongSelf.frame;
        frame.origin.x -= strongSelf.jk_width;
        strongSelf.frame = frame;
    } completion:nil];
}

- (void)dismiss
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGRect frame = strongSelf.frame;
        frame.origin.x += strongSelf.jk_width;
        strongSelf.frame = frame;
    } completion:nil];
}


- (void)dismiss:(void(^)())finishedBlock
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGRect frame = strongSelf.frame;
        frame.origin.x += strongSelf.jk_width;
        strongSelf.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (finishedBlock) {
                finishedBlock();
            }
        }
    }];
}

@end
