//
//  IPCMainMemberLevel.h
//  IcePointCloud
//
//  Created by gerry on 2018/1/31.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCMainMemberLevel : NSObject

@property (nonatomic, copy) NSString * customerId;
@property (nonatomic, copy) NSString * memberLevel;
@property (nonatomic, copy) NSString * membergrowth;
@property (nonatomic, assign) BOOL      status;
@property (nonatomic, copy) NSString * memberPhone;
@property (nonatomic, assign) double    discount;
@property (nonatomic, assign) double    customerIntegral;
@property (nonatomic, assign) double    balance;

@end
