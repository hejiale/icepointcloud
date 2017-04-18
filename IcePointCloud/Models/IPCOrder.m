//
//  IPCOrder.m
//  IcePointCloud
//
//  Created by mac on 10/8/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCOrder.h"

@implementation IPCOrder


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"orderID"    : @"order.id",
             @"alipayPhotoURL":@"order.store.alipayPhoto.photoURL",
             @"wechatURL":@"order.store.wechatPhoto.photoURL"};
}


@end
