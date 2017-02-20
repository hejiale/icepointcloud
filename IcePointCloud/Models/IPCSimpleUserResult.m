//
//  IPCSimpleUserResult.m
//  IcePointCloud
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCSimpleUserResult.h"

@implementation IPCSimpleUserResult

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"userID"   : @"id",
             @"photoURL" : @"roleIconData.normal.dataURI"
             };
}

@end
