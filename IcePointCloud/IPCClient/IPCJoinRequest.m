//
//  IPCRequest.m
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCJoinRequest.h"

/**
 *  Port parameters
 */
#define    kAPIParamFormatKey             @"jsonrpc"
#define    kAPIParamMethodKey            @"method"
#define    kAPIParamIDKey                    @"id"
#define    kAPIInnerParamsKey              @"params"
#define    kAPIQueryKey                        @"query"
#define    kAPIParamOSTypeValue         @"ios"
#define    kAPIParamFormatValue          @"2.0"
#define    kAPIParamDeviceToken          @"access_token"

@implementation IPCJoinRequest


- (instancetype)initWithRequestMethod:(NSString *)requestMethod Parameter:(id)parameter
{
    self = [super init];
    if (self) {
        self.requestMethod    = requestMethod;
        self.parameters          = parameter;
        [self buildRequestParameters];
    }
    return self;
}


- (void)buildRequestParameters
{
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{kAPIParamFormatKey: kAPIParamFormatValue,
                                                                                                                                kAPIParamMethodKey: self.requestMethod,
                                                                                                                                kAPIParamIDKey: [NSString jk_UUIDTimestamp]
                                                                                                                               }];
    if (self.parameters) {
        if ([self.parameters isKindOfClass:[NSArray class]])
            [query setObject:self.parameters forKey:kAPIInnerParamsKey];
        else
            [query setObject:@[self.parameters] forKey:kAPIInnerParamsKey];
    }else{
        [query setObject:@[] forKey:kAPIInnerParamsKey];
    }
    NSLog(@"-----request parameter %@",query);
    
    NSDictionary * requestParameter = @{kAPIQueryKey: [query JSONString],
                              kAPIParamDeviceToken:[IPCAppManager sharedManager].profile.deviceToken ?  : @""};
    self.requestParameter = requestParameter;
}


@end
