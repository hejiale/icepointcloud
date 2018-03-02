//
//  CurrentCustomerOpometry.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderCurrentCustomer.h"

@implementation IPCPayOrderCurrentCustomer

+ (IPCPayOrderCurrentCustomer *)sharedManager
{
    static dispatch_once_t token;
    static IPCPayOrderCurrentCustomer *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

- (void)loadCurrentCustomer:(IPCDetailCustomer *)detailCustomer
{
    [self clearData];
    
    self.currentCustomer = detailCustomer;
    self.currentOpometry = [IPCOptometryMode mj_objectWithKeyValues:detailCustomer.optometrys[0]];
}

- (void)clearData{
    self.currentCustomer = nil;
    self.currentOpometry = nil;
    self.currentMember = nil;
}


@end
