//
//  IPCPayOrderCoupon.h
//  IcePointCloud
//
//  Created by gerry on 2018/6/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayOrderCoupon : NSObject

@property (nonatomic, copy) NSString * couponId;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) double denomination;
@property (nonatomic, copy) NSString * cashCouponCode;
@property (nonatomic, copy) NSString * cashCouponSceneType;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * effectiveStartTime;
@property (nonatomic, copy) NSString * effectiveEndTime;
@property (nonatomic, assign) double sillPrice;
@property (nonatomic, assign) BOOL isUsable;
@property (nonatomic, assign) BOOL sceneStatus;
@property (nonatomic, copy) NSString * launchScene;
@property (nonatomic, copy) NSString * scopeType;
@property (nonatomic, copy) id   scopeBeans;
@property (nonatomic, assign) BOOL  isMatch;//是否适用卡券
@property (nonatomic, assign) BOOL  isSelected;
@property (nonatomic, assign) double couponAmount;//卡券真实价格

@end




