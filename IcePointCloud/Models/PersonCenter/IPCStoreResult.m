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
             @"storeId"                : @"storeObject.repositoryStore.storeDirector.id",
             @"wareHouseId"       : @"storeObject.repositoryStore.id",
             @"contacterPhone"   : @"storeObject.repositoryStore.storeDirector.contactMobilePhone",
             @"companyName"    : @"storeObject.repositoryStore.storeDirector.contactName"
             };
}

@end
