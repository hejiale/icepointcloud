//
//  DetailCustomerObject.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCDetailCustomer.h"

@implementation IPCDetailCustomer

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"customerID": @"id",
             @"memberLevel":@"memberLevel.memberLevel",
             @"discount":@"memberLevel.discount",
             @"customerType":@"customerType.customerType"
             };
}

@end
