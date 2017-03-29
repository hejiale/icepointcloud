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
//                NSLog(@"-----json %@",[responseData jk_JSONString]);
                
                NSLog(@"---responseValue --- \n %@",responseData[kIPCNetworkResult]);
                if (complete) {
                    if (responseData[kIPCNetworkResult]) {
                        complete(responseData[kIPCNetworkResult]);
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
    IPCError * errorMessage = [IPCError mj_objectWithKeyValues:responseValue[kIPCNetworkError]];
    NSLog(@"----request Local Error message %@",errorMessage.message);
    
    if (errorMessage){
        if (errorMessage.code == kIPCServiceErrorCode){
            if (errorMessage.message) {
                NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:kIPCServiceErrorCode userInfo:@{kIPCNetworkErrorMessage:errorMessage.message}];
                return error;
            }
        }
    }
    return nil;
}





@end
