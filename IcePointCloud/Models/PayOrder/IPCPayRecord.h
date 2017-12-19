//
//  IPCPayRecord.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPayOrderPayType.h"

@interface IPCPayRecord : NSObject

@property (nonatomic, strong) IPCPayOrderPayType * payOrderType;
@property (nonatomic, assign) double   payPrice;
@property (nonatomic, copy) NSDate * payDate;
@property (nonatomic, assign) NSInteger  integral;
@property (nonatomic, assign) double   pointPrice;
@property (nonatomic, copy) NSDate *   orderTime;
@property (nonatomic, copy) NSString *  customerId;

@end
