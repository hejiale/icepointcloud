//
//  CurrentCustomerOpometry.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCurrentCustomer.h"

@implementation IPCCurrentCustomer

+ (IPCCurrentCustomer *)sharedManager
{
    static dispatch_once_t token;
    static IPCCurrentCustomer *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

- (void)clearData{
    [IPCCurrentCustomer sharedManager].currentAddress  = nil;
    [IPCCurrentCustomer sharedManager].currentCustomer = nil;
    [IPCCurrentCustomer sharedManager].currentOpometry = nil;
}


@end
