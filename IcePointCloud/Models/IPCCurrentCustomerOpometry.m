//
//  CurrentCustomerOpometry.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCurrentCustomerOpometry.h"

@implementation IPCCurrentCustomerOpometry

+ (IPCCurrentCustomerOpometry *)sharedManager
{
    static dispatch_once_t token;
    static IPCCurrentCustomerOpometry *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

- (void)clearData{
    [IPCCurrentCustomerOpometry sharedManager].currentAddress  = nil;
    [IPCCurrentCustomerOpometry sharedManager].currentCustomer = nil;
    [IPCCurrentCustomerOpometry sharedManager].currentOpometry = nil;
}


@end
