//
//  IPCOrder.h
//  IcePointCloud
//
//  Created by mac on 10/8/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//


@interface IPCOrder : NSObject

@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *alipayPhotoURL;
@property (nonatomic, copy) NSString *wechatURL;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) double  totalPrice;

@end
