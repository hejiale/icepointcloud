//
//  IPCProfileResult.m
//  IcePointCloud
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCProfileResult.h"

@implementation IPCProfileResult


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"userID"         : @"owner.id",
             @"contacterName" : @"owner.contactName",
             @"contacterPhone" : @"owner.contactMobilePhone",
             @"token"                : @"mobileToken",
             @"company"           : @"companyName",
             @"QRCodeURL"       : @"store.alipayPhoto.photoURL",
             @"headImageURL"   : @"roleIconData.normal.dataURI",
             @"deviceToken"      : @"mobileToken",
             @"storeName"         : @"store.storeName",
             @"storeId"            :@"store.id"};
}

@end
