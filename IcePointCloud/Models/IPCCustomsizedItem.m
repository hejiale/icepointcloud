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





@end
