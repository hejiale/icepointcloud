//
//  CustomerListObject.m
//  IcePointCloud
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerList.h"

@implementation IPCCustomerList


- (instancetype)initWithResponseValue:(id)responseValue{
    self = [super init];
    if (self) {
        if ([self.list count] > 0)[self.list removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSDictionary class]]) {
            if ([responseValue[@"resultList"] isKindOfClass:[NSArray class]]) {
                [responseValue[@"resultList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IPCCustomerMode * glasses = [IPCCustomerMode mj_objectWithKeyValues:obj];
                    [self.list addObject:glasses];
                }];
            }
            self.totalCount = [responseValue[@"rowCount"] integerValue];
        }
    }
    return self;
}

- (NSMutableArray<IPCCustomerMode *> *)list{
    if (!_list) {
        _list = [[NSMutableArray alloc]init];
    }
    return _list;
}

@end

@implementation IPCCustomerMode

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"customerID": @"id", @"memberLevel": @"memberLevel.memberLevel"};
}

@end
