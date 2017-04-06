//
//  OptometryListObject.m
//  IcePointCloud
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOptometryList.h"

@implementation IPCOptometryList

- (instancetype)initWithResponseValue:(id)responseValue{
    self = [super init];
    if (self) {
        if ([self.listArray count] > 0)[self.listArray removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSDictionary class]]) {
            if ([responseValue[@"resultList"] isKindOfClass:[NSArray class]]) {
                [responseValue[@"resultList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IPCOptometryMode * optometry = [IPCOptometryMode mj_objectWithKeyValues:[NSDictionary changeType:obj]];
                    [self.listArray addObject:optometry];
                }];
            }
            
            self.totalCount = [responseValue[@"rowCount"]integerValue];
        }
    }
    return self;
}

- (NSMutableArray<IPCOptometryMode *> *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
}

@end

@implementation IPCOptometryMode

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"optometryID": @"id"};
}

@end
