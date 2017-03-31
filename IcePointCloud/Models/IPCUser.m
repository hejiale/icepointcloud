//
//  IPCUser.m
//  IcePointCloud
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCUser.h"

@implementation IPCUser

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"userID": @"id"};
}

@end
