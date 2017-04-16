//
//  IPCPointValueMode.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/16.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCPointValue;
@interface IPCPointValueMode : NSObject

@property (nonatomic, strong) NSMutableArray<IPCPointValue *> * pointArray;

- (instancetype)initWithResponseObject:(id)responseObject;

@end


@interface IPCPointValue : NSObject

@property (nonatomic, assign, readonly) double integralDeductionAmount;//积分抵现金
@property (nonatomic, assign, readonly) double deductionIntegral;//抵用积分

@end

