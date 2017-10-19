//
//  IPCMemberLevelList.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCMemberLevelList.h"

@implementation IPCMemberLevelList

- (instancetype)initWithResponseValue:(id)responseValue{
    self = [super init];
    if (self) {
        if ([self.list count] > 0)[self.list removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSArray class]]) {
            [responseValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCMemberLevel * glasses = [IPCMemberLevel mj_objectWithKeyValues:obj];
                [self.list addObject:glasses];
            }];
        }
    }
    return self;
}

- (NSMutableArray<IPCMemberLevel *> *)list{
    if (!_list) {
        _list = [[NSMutableArray alloc]init];
    }
    return _list;
}

@end

@implementation IPCMemberLevel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"memberLevelId": @"id"};
}

@end
