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

@property (assign, nonatomic, readwrite) IPCPayOrderType payOrderType;
@property (nonatomic, assign, readwrite) IPCCustomsizedType customsizdType;

@property (nonatomic, strong, readwrite) IPCCustomsizedProduct * customsizedProduct;
@property (nonatomic, strong, readwrite) IPCCustomsizedEye * unifiedEye;
@property (nonatomic, strong, readwrite) IPCCustomsizedEye * leftEye;
@property (nonatomic, strong, readwrite) IPCCustomsizedEye * rightEye;


@end
