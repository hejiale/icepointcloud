//
//  IPCWareHouse.m
//  IcePointCloud
//
//  Created by gerry on 2017/9/22.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCWareHouse.h"

@implementation IPCWareHouse

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"wareHouseId"    : @"id",
             @"wareHouseName" : @"storeName"};
}

@end
