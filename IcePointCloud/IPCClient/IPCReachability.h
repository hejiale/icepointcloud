//
//  IPCReachability.h
//  IcePointCloud
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkStatusBlock)(AFNetworkReachabilityStatus status);

@interface IPCReachability : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus currentNetStatus;
@property (nonatomic, copy) NetworkStatusBlock  statusBlock;

+ (IPCReachability *)manager;


/**
 Start Monitoring Network
 */
- (void)startMonitoringNetwork;

- (void)monitoringNetwork:(NetworkStatusBlock)status;

@end
