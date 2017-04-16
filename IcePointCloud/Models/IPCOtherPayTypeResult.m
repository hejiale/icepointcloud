//
//  IPCOtherPayTypeResult.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/16.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOtherPayTypeResult.h"

@implementation IPCOtherPayTypeResult

- (instancetype)init{
    self  = [super init];
    if (self) {
        self.otherPayTypeName = @"";
        self.otherPayAmount = 0;
    }
    return self;
}

@end
