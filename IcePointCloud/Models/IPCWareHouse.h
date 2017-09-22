//
//  IPCWareHouse.h
//  IcePointCloud
//
//  Created by gerry on 2017/9/22.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCWareHouse : NSObject

@property (nonatomic, copy, readonly) NSString * wareHouseName;
@property (nonatomic, copy, readonly) NSString * wareHouseId;
@property (nonatomic, copy, readonly) NSString * storeStatus;

@end
