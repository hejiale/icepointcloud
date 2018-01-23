//
//  IPCPayOrderViewNormalSellCellMode.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewMode.h"

@interface IPCPayOrderViewMode()

@property (nonatomic, copy) void(^CompletePrototyBlock)();
@property (nonatomic, copy) void(^CompletePayCashBlock)();
@property (nonatomic, copy) void(^CompleteOutboundBlock)();
@property (nonatomic, copy) void(^ErrorPayBlock)(IPCPayOrderError);

@end

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

- (void)saveProtyOrder:(BOOL)isProty
               Prototy:(void(^)())prototy
               PayCash:(void(^)())payCash
              Outbound:(void(^)())outbound
                 Error:(void(^)(IPCPayOrderError errorType))error
{
    self.CompletePrototyBlock = prototy;
    self.CompletePayCashBlock = payCash;
    self.CompleteOutboundBlock = outbound;
    self.ErrorPayBlock = error;
    
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager savePrototyOrderWithSuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if (!isProty) {
             if (responseValue) {
                 if ([responseValue isKindOfClass:[NSDictionary class]]) {
                     [weakSelf offertOrderWithOrderId:responseValue[@"id"]];
                 }
             }
         }else{
             [IPCCommonUI showSuccess:@"挂单成功!"];
             
             if (strongSelf.CompletePrototyBlock) {
                 strongSelf.CompletePrototyBlock();
             }
         }
     } FailureBlock:^(NSError *error) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [IPCCommonUI showError:error.domain];
         
         if (strongSelf.ErrorPayBlock) {
             strongSelf.ErrorPayBlock(IPCPayOrderErrorSavePrototy);
         }
     }];
}

- (void)offertOrderWithOrderId:(NSString *)orderId
{
    if (orderId) {
        __weak typeof(self) weakSelf = self;
        [IPCPayOrderRequestManager offerOrderWithOrderId:orderId SuccessBlock:^(id responseValue)
         {
             if (responseValue) {
                 if ([responseValue isKindOfClass:[NSDictionary class]]) {
                     [weakSelf authOrderWithOrderNum:responseValue[@"orderNumber"]];
                 }
             }
         } FailureBlock:^(NSError *error) {
             [IPCCommonUI showError:error.domain];
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if (strongSelf.ErrorPayBlock) {
                 strongSelf.ErrorPayBlock(IPCPayOrderErrorOfferOrder);
             }
         }];
    }
}

- (void)authOrderWithOrderNum:(NSString *)orderNum
{
    if (orderNum) {
        __weak typeof(self) weakSelf = self;
        [IPCPayOrderRequestManager authOrderWithOrderNum:orderNum SuccessBlock:^(id responseValue)
         {
             if (responseValue) {
                 if ([responseValue isKindOfClass:[NSDictionary class]]) {
                     if ([IPCAppManager sharedManager].companyCofig.autoInvOutAfterAudited) {
                         [weakSelf outboundWithOrderNum:responseValue[@"orderNumber"]];
                     }
                     [weakSelf payCashWithOrderNum:responseValue[@"orderNumber"]];
                 }
             }
         } FailureBlock:^(NSError *error) {
             [IPCCommonUI showError:error.domain];
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if (strongSelf.ErrorPayBlock) {
                 strongSelf.ErrorPayBlock(IPCPayOrderErrorAuthOrder);
             }
         }];
    }
}

- (void)outboundWithOrderNum:(NSString *)orderNum
{
    ///出库操作
    if (orderNum) {
        [IPCPayOrderRequestManager outbound:orderNum SuccessBlock:nil FailureBlock:nil];
    }
}

- (void)payCashWithOrderNum:(NSString *)orderNum
{
    if (orderNum) {
        __weak typeof(self) weakSelf = self;
        [IPCPayOrderRequestManager payCashOrderWithOrderNumber:orderNum SuccessBlock:^(id responseValue)
         {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             [IPCCommonUI showSuccess:@"收银成功!"];
             
             if (strongSelf.CompletePayCashBlock) {
                 strongSelf.CompletePayCashBlock();
             }
         } FailureBlock:^(NSError *error) {
             [IPCCommonUI showError:error.domain];
             
             __strong typeof(weakSelf) strongSelf = weakSelf;
             
             if (strongSelf.ErrorPayBlock) {
                 strongSelf.ErrorPayBlock(IPCPayOrderErrorPayCashOrder);
             }
         }];
    }
}

@end
