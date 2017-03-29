//
//  IPCOrder.h
//  IcePointCloud
//
//  Created by mac on 10/8/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//


@interface IPCOrder : NSObject

@property (nonatomic, copy, readonly) NSString *orderID;
@property (nonatomic, copy, readonly) NSString *orderNumber;
@property (nonatomic, copy, readonly) NSString *alipayPhotoURL;
@property (nonatomic, copy, readonly) NSString *wechatURL;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, assign) double  totalPrice;

@end
