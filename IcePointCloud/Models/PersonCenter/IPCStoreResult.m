//
//  IPCStoreResult.m
//  IcePointCloud
//
//  Created by gerry on 2017/10/25.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCStoreResult.h"

@implementation IPCStoreResult

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"wareHouseName" : @"storeObject.repositoryStore.storeName",
             @"employeeId"                : @"storeObject.repositoryStore.storeDirector.id",
             @"wareHouseId"       : @"storeObject.repositoryStore.id",
             @"contacterPhone"   : @"storeObject.repositoryStore.storeDirector.contactMobilePhone",
             @"employeeName"    : @"storeObject.repositoryStore.storeDirector.contactName",
             @"storeName"          : @"storeObject.storeName",
             @"storePhone"         : @"storeObject.storePhone",
             @"sex"                     : @"storeObject.repositoryStore.storeDirector.role.gender",
             @"companyName"    : @"storeObject.belongedCompany.name",
             @"storeId"                : @"storeObject.id"
             };
}

@end
