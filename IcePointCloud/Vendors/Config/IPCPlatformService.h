//
//  IPCPlatformService.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPlatformService : NSObject<WXApiDelegate>

+ (IPCPlatformService *)instance;

- (void)setUp;

@end
