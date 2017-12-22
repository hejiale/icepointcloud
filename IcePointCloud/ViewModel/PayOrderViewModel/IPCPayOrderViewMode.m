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
             [strongSelf offertOrderWithOrderId:responseValue[@"id"]];
         }else{
             [IPCCommonUI showSuccess:@"挂单成功!"];
             
             if (strongSelf.CompletePrototyBlock) {
                 strongSelf.CompletePrototyBlock();
             }
         }
     } FailureBlock:^(NSError *error) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [IPCCommonUI showError:@"保存草稿订单失败!"];
         
         if (strongSelf.ErrorPayBlock) {
             strongSelf.ErrorPayBlock(IPCPayOrderErrorSavePrototy);
         }
     }];
}

- (void)offertOrderWithOrderId:(NSString *)orderId
{
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager offerOrderWithOrderId:orderId SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf authOrderWithOrderNum:responseValue[@"orderNumber"]];
     } FailureBlock:^(NSError *error) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         
         if (strongSelf.ErrorPayBlock) {
             strongSelf.ErrorPayBlock(IPCPayOrderErrorOfferOrder);
         }
     }];
}

- (void)authOrderWithOrderNum:(NSString *)orderNum
{
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager authOrderWithOrderNum:orderNum SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if ([IPCAppManager sharedManager].companyCofig.autoInvOutAfterAudited) {
             [strongSelf outboundWithOrderNum:responseValue[@"orderNumber"]];
         }
         [strongSelf payCashWithOrderNum:responseValue[@"orderNumber"]];
         
     } FailureBlock:^(NSError *error) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         
         if (strongSelf.ErrorPayBlock) {
             strongSelf.ErrorPayBlock(IPCPayOrderErrorAuthOrder);
         }
     }];
}

- (void)outboundWithOrderNum:(NSString *)orderNum
{
    ///出库操作
    [IPCPayOrderRequestManager getAuthsWithOrderNum:orderNum WithSuccessBlock:nil FailureBlock:nil];
}

- (void)payCashWithOrderNum:(NSString *)orderNum
{
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager payCashOrderWithOrderNumber:orderNum SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [IPCCommonUI showSuccess:@"收银成功!"];
         
         if (strongSelf.CompletePayCashBlock) {
             strongSelf.CompletePayCashBlock();
         }
     } FailureBlock:^(NSError *error) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [IPCCommonUI showError:@"订单收银失败!"];
         
         if (strongSelf.ErrorPayBlock) {
             strongSelf.ErrorPayBlock(IPCPayOrderErrorPayCashOrder);
         }
     }];
}




@end
