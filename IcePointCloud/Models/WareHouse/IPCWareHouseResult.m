//
//  IPCWareHouseResult.m
//  IcePointCloud
//
//  Created by gerry on 2017/9/22.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCWareHouseResult.h"

@implementation IPCWareHouseResult

- (NSMutableArray<IPCWareHouse *> *)wareHouseArray{
    if (!_wareHouseArray) {
        _wareHouseArray = [[NSMutableArray alloc]init];
    }
    return _wareHouseArray;
}

- (instancetype)initWithResponseValue:(id)responseValue
{
    self  = [super init];
    if (self) {
        [self.wareHouseArray removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSArray class]]) {
            [responseValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCWareHouse * wareHouse = [IPCWareHouse mj_objectWithKeyValues:obj];
                [self.wareHouseArray addObject:wareHouse];
            }];
        }
    }
    return self;
}

@end
