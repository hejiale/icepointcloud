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
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x -= self.jk_width;
        self.frame = frame;
    } completion:nil];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x += self.jk_width;
        self.frame = frame;
    } completion:nil];
}


- (void)dismiss:(void(^)())finishedBlock
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x += self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (finishedBlock) {
                finishedBlock();
            }
        }
    }];
}

@end
