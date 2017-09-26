//
//  IPCNetworkCache.h
//  IcePointCloud
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCNetworkCache : NSObject

+ (IPCNetworkCache *)sharedCache;

/**
 *  ADD (URL、PARAMETERS、USERID)   SAVE CACHE
 *
 *  @param httpData
 *  @param URL
 *  @param parameters 
 */
- (void)setHttpCache:(id)httpData RequestMethod:(NSString *)requestMethod parameters:(NSDictionary *)parameters;

/**
 *   ADD (URL、PARAMETERS、USERID)   QUERY CACHE
 *
 *  @param URL
 *  @param parameters
 */
- (id)httpCacheForRequestMethod:(NSString *)requestMethod parameters:(NSDictionary *)parameters;


/**
 *  REMOVE CACHE
 */
- (void)removeAllHttpCache;


@end
