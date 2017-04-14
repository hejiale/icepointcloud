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

    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeNone;

    
}


@end
