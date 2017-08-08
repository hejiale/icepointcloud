//
//  IPCSortCustomer.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCSortCustomer : NSObject

+ (NSMutableArray *) getCustomerListDataBy:(NSMutableArray<IPCCustomerMode *> *)array;
+ (NSMutableArray *)getCustomerListSectionBy:(NSMutableArray<IPCCustomerMode *> *)array;

@end
