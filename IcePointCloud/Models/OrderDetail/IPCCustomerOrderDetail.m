//
//  CustomOrderDetailObject.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerOrderDetail.h"

@implementation IPCCustomerOrderDetail

+ (IPCCustomerOrderDetail *)instance
{
    static dispatch_once_t token;
    static IPCCustomerOrderDetail *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}


- (void)parseResponseValue:(id)responseValue
{
    [self.products removeAllObjects];
    [self.recordArray removeAllObjects];
    self.optometryMode = nil;
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
            self.optometryMode = [IPCOptometryMode mj_objectWithKeyValues:responseValue[@"order"]];
        }
        
        self.orderInfo.totalPayAmount = 0;
        self.orderInfo.totalPointAmount = 0;
        
        [self.products enumerateObjectsUsingBlock:^(IPCGlasses * _Nonnull glass, NSUInteger idx, BOOL * _Nonnull stop) {
            self.orderInfo.totalPayAmount += glass.afterDiscountPrice * glass.productCount;
        }];
        
        __block double totalPayTypePrice = 0;
        
        if ([responseValue[@"detailInfos"] isKindOfClass:[NSArray class]]) {
            [responseValue[@"detailInfos"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCPayRecord * payType = [IPCPayRecord mj_objectWithKeyValues:obj];
                [self.recordArray addObject:payType];
                totalPayTypePrice += payType.payPrice;
            }];
        }
        self.orderInfo.remainAmount = self.orderInfo.totalPrice - totalPayTypePrice;
    }
}

- (NSMutableArray<IPCGlasses *> *)products{
    if (!_products)
        _products = [[NSMutableArray alloc]init];
    return _products;
}

-(NSMutableArray<IPCPayRecord *> *)recordArray{
    if (!_recordArray) {
        _recordArray = [[NSMutableArray alloc]init];
    }
    return _recordArray;
}

- (void)clearData{
    [self.products removeAllObjects];
    [self.recordArray removeAllObjects];
    self.orderInfo = nil;
    self.optometryMode = nil;
}


@end

@implementation IPCCustomerOrderInfo

- (NSString *)orderStatus{
    if ([self.auditStatus isEqualToString:@"UN_AUDITED"]) {
        return @"未审核";
    }else if ([self.auditStatus isEqualToString:@"AUDITED"]){
        return @"已审核";
    }
    return @"草稿";
}

@end



