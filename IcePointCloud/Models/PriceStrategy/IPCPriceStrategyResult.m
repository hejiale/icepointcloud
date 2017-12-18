//
//  IPCPriceStrategyResult.m
//  IcePointCloud
//
//  Created by gerry on 2017/12/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPriceStrategyResult.h"

@implementation IPCPriceStrategyResult

- (instancetype)initWithResponseValue:(id)responseValue
{
    self = [super init];
    if (self) {
        [self.strategyArray removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSArray class]]) {
            [responseValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCPriceStrategy * strategy = [IPCPriceStrategy mj_objectWithKeyValues:obj];
                [self.strategyArray addObject:strategy];
            }];
        }
    }
    return self;
}

- (NSMutableArray<IPCPriceStrategy *> *)strategyArray
{
    if (!_strategyArray) {
        _strategyArray = [[NSMutableArray alloc]init];
    }
    return _strategyArray;
}

@end

@implementation IPCPriceStrategy

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"strategyId"    :  @"id"};
}

@end
