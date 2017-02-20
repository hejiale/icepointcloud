//
//  CustomOrderDetailObject.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomOrderDetailList.h"

@implementation IPCCustomOrderDetailList

- (instancetype)initWithResponseValue:(id)responseValue{
    self = [super init];
    if (self) {
        [self.products removeAllObjects];
        self.orderInfo = nil;
        
        if ([responseValue isKindOfClass:[NSDictionary class]]) {
            if ([responseValue[@"detailList"] isKindOfClass:[NSArray class]]) {
                [responseValue[@"detailList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IPCGlasses * glass = [IPCGlasses mj_objectWithKeyValues:obj];
                    [self.products addObject:glass];
                }];
            }
            
            if ([responseValue[@"order"] isKindOfClass:[NSDictionary class]]) {
                self.orderInfo = [IPCCustomerOrderInfo mj_objectWithKeyValues:responseValue[@"order"]];
            }
        }
    }
    return self;
}

- (NSMutableArray<IPCGlasses *> *)products{
    if (!_products)
        _products = [[NSMutableArray alloc]init];
    return _products;
}

@end

@implementation IPCCustomerOrderInfo



@end


