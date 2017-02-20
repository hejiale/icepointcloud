//
//  IPCNetworkCache.m
//  IcePointCloud
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCNetworkCache.h"

static NSString *const NetworkResponseCache = @"NetworkResponseCache";

@interface IPCNetworkCache()

@property (nonatomic, strong) YYCache * dataCache;

@end

@implementation IPCNetworkCache

+ (IPCNetworkCache *)sharedCache
{
    static dispatch_once_t token;
    static IPCNetworkCache *_cache;
    dispatch_once(&token, ^{
        _cache = [[self alloc] init];
        _cache.dataCache = [[YYCache alloc]initWithName:NetworkResponseCache];
    });
    return _cache;
}


- (void)setHttpCache:(id)httpData RequestMethod:(NSString *)requestMethod parameters:(NSDictionary *)parameters UserID:(NSString *)userID
{
    if ( [self.dataCache containsObjectForKey:[self cacheKeyWithRequestMethod:requestMethod Parameters:parameters UserID:userID]])
        [self.dataCache removeObjectForKey:[self cacheKeyWithRequestMethod:requestMethod Parameters:parameters UserID:userID]];
    
    [self.dataCache setObject:httpData forKey:[self cacheKeyWithRequestMethod:requestMethod Parameters:parameters UserID:userID]];
}


- (id)httpCacheForRequestMethod:(NSString *)requestMethod parameters:(NSDictionary *)parameters  UserID:(NSString *)userID
{
    if ([self.dataCache containsObjectForKey:[self cacheKeyWithRequestMethod:requestMethod Parameters:parameters UserID:userID]])
        return  [self.dataCache objectForKey:[self cacheKeyWithRequestMethod:requestMethod Parameters:parameters UserID:userID]];
    return nil;
}


- (NSInteger)getAllHttpCacheSize{
    return [self.dataCache .diskCache totalCost];
}


- (void)removeAllHttpCache{
    [self.dataCache removeAllObjects];
}


- (void)removeCacheForRequestMethod:(NSString *)requestMethod parameters:(NSDictionary *)parameters  UserID:(NSString *)userID
{
    if ([self.dataCache containsObjectForKey:[self cacheKeyWithRequestMethod:requestMethod Parameters:parameters UserID:userID]]) {
        [self.dataCache removeObjectForKey:[self cacheKeyWithRequestMethod:requestMethod Parameters:parameters UserID:userID]];
    }
}

- (NSString *)cacheKeyWithRequestMethod:(NSString *)requestMethod Parameters:(id)parameter UserID:(NSString *)userID
{
    //Different userID to login every time to save the user's network corresponding cached data
    NSMutableString *cacheKey = [[NSMutableString alloc]initWithFormat:@"%@_%@_%@_%@",[self jk_version],IPC_DevelopmentAPI_URL,requestMethod,userID ? userID : @""];
    
    if (parameter != nil) {
        if ([parameter isKindOfClass:[NSDictionary class]] || [parameter isKindOfClass:[NSArray class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [cacheKey appendString:str];
        }else if ([parameter isKindOfClass:[NSString class]]){
            [cacheKey appendString:parameter];
        }
    }
    return cacheKey;
}

@end
