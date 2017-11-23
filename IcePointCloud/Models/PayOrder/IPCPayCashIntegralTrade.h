//
//  IPCPayCashIntegralTrade.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayCashIntegralTrade : NSObject

@property (nonatomic, assign, readonly) double integral;
@property (nonatomic, assign, readonly) double money;
@property (nonatomic, copy, readonly) NSString * companyId;
@property (nonatomic, copy, readonly) NSString * tradeId;


@end
