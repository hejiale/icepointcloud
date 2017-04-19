//
//  IPCCustomsizedProductList.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedProductList.h"

@implementation IPCCustomsizedProductList

- (instancetype)initWithResponseObject:(id)responseObject{
    self = [super init];
    if (self) {
        [self.productsList removeAllObjects];
        
        if ([responseObject[@"resultList"] isKindOfClass:[NSArray class]]) {
            id resultList = responseObject[@"resultList"];
            [resultList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCCustomsizedProduct * product = [IPCCustomsizedProduct mj_objectWithKeyValues:obj];
                [self.productsList addObject:product];
            }];
        }
    }
    return self;
}

- (NSMutableArray<IPCCustomsizedProduct *> *)productsList{
    if (!_productsList) {
        _productsList = [[NSMutableArray alloc] init];
    }
    return _productsList;
}

@end

@implementation IPCCustomsizedProduct

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"customsizedId"    : @"id"};
}

@end
