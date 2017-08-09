//
//  IPCSortCustomer.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCSortCustomer : NSObject

+ (NSMutableArray *)PinYingData:(NSMutableArray<IPCCustomerMode *> *)array;
+ (NSMutableArray *)PinYingSection:(NSMutableArray<IPCCustomerMode *> *)array;

@end
