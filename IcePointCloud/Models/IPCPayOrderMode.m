//
//  IPCPayOrderMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderMode.h"

@implementation IPCPayOrderMode

+ (IPCPayOrderMode *)sharedManager
{
    static dispatch_once_t token;
    static IPCPayOrderMode *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}


- (void)clearData{
    [IPCPayOrderMode sharedManager].employeAmount = 0;
    [IPCPayOrderMode sharedManager].prepaidAmount = 0;
    [IPCPayOrderMode sharedManager].orderMemo = @"";
    [IPCPayOrderMode sharedManager].currentEmploye = nil;
    [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypePayAmount;
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeNone;
    [IPCPayOrderMode sharedManager].isSelectEmploye = NO;
    [IPCPayOrderMode sharedManager].payStyleName = nil;
    [IPCPayOrderMode sharedManager].isOrder = NO;
}


@end
