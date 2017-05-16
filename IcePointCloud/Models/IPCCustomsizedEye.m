//
//  IPCCustomsizedItem.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedEye.h"

@implementation IPCCustomsizedEye

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}


- (NSMutableArray<IPCCustomsizedOther *> *)otherArray{
    if (!_otherArray) {
        _otherArray = [[NSMutableArray alloc]init];
    }
    return _otherArray;
}

@end

@implementation IPCCustomsizedOther



@end
