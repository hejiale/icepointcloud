//
//  IPCResponse.m
//  IcePointCloud
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCResponse.h"

@implementation IPCResponse


+ (void)parseResponseData:(id)responseData Complete:(void (^)(id responseValue))complete Failed:(void(^)(NSError * _Nonnull error))failed
{
    if (responseData) {
        if ([responseData isKindOfClass:[NSDictionary class]]){
            if ([[responseData allKeys] containsObject:kIPCNetworkResult])
            {
//                NSLog(@"---responseValue --- \n %@",responseData[kIPCNetworkResult]);
                id responseValue = [NSDictionary changeType:responseData[kIPCNetworkResult]];
                
                if (responseValue) {
                    if (complete) {
                        complete(responseValue);
                    }
                }
            }else if ([[responseData allKeys] containsObject:kIPCNetworkError]){
                if (failed) {
                    failed([self parseErrorResponse:responseData]);
                }
            }
        }else if ([responseData isKindOfClass:[NSArray class]] || [responseData isKindOfClass:[NSString class]]){
            if (complete) {
                complete(responseData);
            };
        }
    }
}


+ (NSError *)parseErrorResponse:(id)responseValue
{
    if (responseValue) {
        IPCError * errorMessage = [IPCError mj_objectWithKeyValues:responseValue[kIPCNetworkError]];
//        NSLog(@"---error %@",errorMessage.message);
        
        if (errorMessage){
            if (errorMessage.message) {
                return HTTPError(errorMessage.message, NSURLErrorDomain);
            }
        }
    }
    return nil;
}





@end
