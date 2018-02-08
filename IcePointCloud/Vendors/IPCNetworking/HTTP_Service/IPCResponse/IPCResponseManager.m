//
//  IPCResponse.m
//  IcePointCloud
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCResponseManager.h"

static NSString * const kIPCNetworkResult       =  @"result";
static NSString * const kIPCNetworkError         =  @"error";
static NSError *HTTPError(NSString *domain, int code) {
    return [NSError errorWithDomain:domain code:code userInfo:nil];
}


@implementation IPCResponseManager


+ (void)parseResponseData:(id)responseData Complete:(void (^)(id responseValue))complete Failed:(void(^)(NSError * _Nonnull error))failed
{

    DLog(@"%@", responseData);
    
    if (responseData && ![responseData isKindOfClass:[NSNull class]]) {
        if ([responseData isKindOfClass:[NSDictionary class]]){
            if ([[responseData allKeys] containsObject:kIPCNetworkResult])
            {
                id responseValue = [NSDictionary changeType:responseData[kIPCNetworkResult]];
                
                if (responseValue) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) {
                            complete(responseValue);
                        }
                    });
                }
            }else if ([[responseData allKeys] containsObject:kIPCNetworkError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed([IPCResponseManager parseErrorResponse:responseData]);
                    }
                });
            }
        }else if ([responseData isKindOfClass:[NSArray class]] || [responseData isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete(responseData);
                };
            });
        }else{
            if (complete) {
                complete(nil);
            }
        }
    }else{
        if (complete) {
            complete(nil);
        }
    }
}


+ (NSError *)parseErrorResponse:(id)responseValue
{
    if (responseValue) {
        IPCError * errorMessage = [IPCError mj_objectWithKeyValues:responseValue[kIPCNetworkError]];
        DLog(@"%@",errorMessage.message);
        
        if (errorMessage){
            if (errorMessage.message) {
                return HTTPError(errorMessage.message, NSURLErrorDomain);
            }
        }
    }
    return nil;
}





@end
