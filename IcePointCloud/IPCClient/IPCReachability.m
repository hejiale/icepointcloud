//
//  IPCReachability.m
//  IcePointCloud
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCReachability.h"

@implementation IPCReachability

+ (IPCReachability *)manager
{
    static dispatch_once_t token;
    static IPCReachability * reachability;
    dispatch_once(&token, ^{
        reachability = [[self alloc] init];
    });
    return reachability;
}


- (void)monitoringNetwork:(NetworkStatusBlock)status
{
    self.statusBlock = status;
}

- (void)startMonitoringNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.currentNetStatus = status;
        
        if (self.statusBlock) {
            self.statusBlock(self.currentNetStatus);
        }
    }];
    [manager startMonitoring];
}



@end
