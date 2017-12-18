//
//  IPCPriceStrategyResult.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCPriceStrategy;
@interface IPCPriceStrategyResult : NSObject

@property (nonatomic, strong) NSMutableArray<IPCPriceStrategy *> * strategyArray;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCPriceStrategy : NSObject

@property (nonatomic, copy) NSString * belongedCompany;
@property (nonatomic, copy) NSString * strategyName;
@property (nonatomic, copy) NSString * strategyId;

@end
