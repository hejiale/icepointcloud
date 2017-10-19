//
//  IPCPointValueMode.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/16.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPointValueMode.h"

@implementation IPCPointValueMode

- (instancetype)initWithResponseObject:(id)responseObject
{
    self = [super init];
    if (self) {
        [self.pointArray removeAllObjects];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCPointValue * point = [IPCPointValue mj_objectWithKeyValues:obj];
                [self.pointArray addObject:point];
            }];
        }
    }
    return self;
}



- (NSMutableArray<IPCPointValue *> *)pointArray{
    if (!_pointArray) {
        _pointArray = [[NSMutableArray alloc]init];
    }
    return _pointArray;
}

@end

@implementation IPCPointValue



@end
