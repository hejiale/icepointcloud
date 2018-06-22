//
//  IPCPayOrderViewNormalSellCellMode.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewMode.h"

static NSError *HTTPError(NSString *domain, int code) {
    return [NSError errorWithDomain:domain code:code userInfo:nil];
}

@implementation IPCPayOrderViewMode

- (instancetype)init{
    self = [super init];
    if (self) {
  
    }
    return self;
}

#pragma mark //Request Data
- (void)queryIntegralRule
{
    [IPCPayOrderRequestManager queryIntegralRuleWithSuccessBlock:^(id responseValue){
        [IPCPayOrderManager sharedManager].integralTrade = [IPCPayCashIntegralTrade mj_objectWithKeyValues:responseValue];
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:error.domain];
    }];
}

- (void)payOrderWithCurrentStatus:(NSString *)currentStatus EndStatus:(NSString *)endStatus Complete:(void (^)(NSError * error))complete
{
    [IPCPayOrderRequestManager payOrderWithCurrentStatus:currentStatus
                                               EndStatus:endStatus
                                            SuccessBlock:^(id responseValue)
    {
        if (responseValue[@"errorMsg"]) {
            if (complete) {
                complete(HTTPError(responseValue[@"errorMsg"], 200));
            }
        }else{
            if (complete) {
                complete(nil);
            }
        }
    } FailureBlock:^(NSError *error) {
        if (complete) {
            complete(error);
        }
    }];
}

@end
