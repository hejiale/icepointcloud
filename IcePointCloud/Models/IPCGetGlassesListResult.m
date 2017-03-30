//
//  IPCGetGlassesListResult.m
//  IcePointCloud
//
//  Created by mac on 8/2/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGetGlassesListResult.h"

@implementation IPCGetGlassesListResult

- (instancetype)initWithResponseValue:(id)responseValue{
    self = [super init];
    if (self) {
        [self.glassesList removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSDictionary class]]) {
            id listValue = responseValue[@"list"];
            if ([listValue isKindOfClass:[NSArray class]] && listValue) {
                [listValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ( ![obj isKindOfClass:[NSNull class]]) {
                        IPCGlasses * glasses = [IPCGlasses mj_objectWithKeyValues:obj];
                        [self.glassesList addObject:glasses];
                    }
                }];
            }
        }
    }
    return self;
}


- (NSMutableArray<IPCGlasses *> *)glassesList{
    if (!_glassesList)
        _glassesList = [[NSMutableArray alloc]init];
    return _glassesList;
}

@end

