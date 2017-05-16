//
//  IPCCustomsizedManager.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedItem.h"

@implementation IPCCustomsizedItem

+ (IPCCustomsizedItem *)sharedItem
{
    static IPCCustomsizedItem *cart;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        cart = [[IPCCustomsizedItem alloc] init];
    });
    return cart;
}

- (NSMutableArray<IPCShoppingCartItem *> *)normalProducts{
    if (!_normalProducts) {
        _normalProducts = [[NSMutableArray alloc] init];
    }
    return _normalProducts;
}


- (void)resetData{
    self.customsizdType = IPCCustomsizedTypeNone;
    self.payOrderType = IPCPayOrderTypeNormal;
    self.customsizedProduct = nil;
    [self.normalProducts removeAllObjects];
    self.normalProducts = nil;
    self.leftEye       = nil;
    self.rightEye     = nil;
}

- (double)totalPrice
{
    __block double price = 0;
    [self.normalProducts enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += obj.totalPrice;
    }];
    if (self.customsizdType == IPCCustomsizedTypeUnified) {
        price += self.rightEye.customsizedCount * self.rightEye.customsizedPrice;
    }else if(self.customsizdType == IPCCustomsizedTypeLeftOrRightEye){
        price += self.rightEye.customsizedCount * self.rightEye.customsizedPrice;
        price += self.leftEye.customsizedCount * self.leftEye.customsizedPrice;
    }
    return price;
}


@end
