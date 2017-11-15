//
//  IPCRequest.m
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCRequestParameter.h"

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


@interface IPCRequestParameter()

@property (nonatomic, strong) NSLock * lock;

@end

@implementation IPCRequestParameter


- (instancetype)initWithRequestMethod:(NSString *)requestMethod Parameter:(id)parameter
{
    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc]init];
        self.lock.name = @"com.request.parameter.lock";
        
        self.requestMethod    = requestMethod;
        self.parameters          = parameter;
        [self buildRequestParameters];
    }
    return self;
}


- (void)buildRequestParameters
{
    [self.lock lock];
    
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:@{kAPIParamFormatKey: kAPIParamFormatValue,
                                                                                                                                kAPIParamMethodKey: self.requestMethod,
                                                                                                                                kAPIParamIDKey: [NSString jk_UUIDTimestamp]
                                                                                                                               }];
    if (self.parameters && ![self.parameters isKindOfClass:[NSNull class]]){
        if ([self.parameters isKindOfClass:[NSArray class]])
            [query setObject:self.parameters forKey:kAPIInnerParamsKey];
        else
            [query setObject:@[self.parameters] forKey:kAPIInnerParamsKey];
    }else{
        [query setObject:@[] forKey:kAPIInnerParamsKey];
    }
    DLog(@"%@",query);
    
    NSDictionary * requestParameter = @{kAPIQueryKey: [query JSONString],
                              kAPIParamDeviceToken:[IPCAppManager sharedManager].deviceToken ?  : @""};
    self.requestParameter = requestParameter;
    
    [self.lock unlock];
}


@end
