//
//  IPCCustomsizedManager.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCCustomsizedEye.h"

typedef NS_ENUM(NSInteger, IPCCustomsizedType){
    IPCCustomsizedTypeNone = 0,
    IPCCustomsizedTypeUnified,//统一定制
    IPCCustomsizedTypeLeftOrRightEye//左右眼分别定制
};

@interface IPCCustomsizedItem : NSObject

+ (IPCCustomsizedItem *)sharedItem;

@property (assign, nonatomic, readwrite) IPCPayOrderType              payOrderType;//订单支付商品类型
@property (nonatomic, assign, readwrite) IPCCustomsizedType        customsizdType;//定制类型
@property (nonatomic, strong, readwrite) IPCCustomsizedProduct * customsizedProduct;//定制商品
@property (nonatomic, strong, readwrite) NSMutableArray<IPCShoppingCartItem *> * normalProducts;//新增普通类商品
@property (nonatomic, strong, readwrite) IPCCustomsizedEye        * unifiedEye;//统一定制
@property (nonatomic, strong, readwrite) IPCCustomsizedEye        * leftEye;//左眼
@property (nonatomic, strong, readwrite) IPCCustomsizedEye        * rightEye;//右眼

- (double)totalPrice;

- (void)resetData;

@end
