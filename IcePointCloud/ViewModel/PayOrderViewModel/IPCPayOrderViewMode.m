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
    
    [IPCPayOrderRequestManager savePrototyOrderWithSuccessBlock:^(id responseValue)
     {
         if (!isProty) {
             [self offertOrderWithOrderId:responseValue[@"id"]];
         }else{
             [IPCCommonUI showSuccess:@"挂单成功!"];
             
             if (self.CompletePrototyBlock) {
                 self.CompletePrototyBlock();
             }
         }
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:@"保存草稿订单失败!"];
         
         if (self.ErrorPayBlock) {
             self.ErrorPayBlock(IPCPayOrderErrorSavePrototy);
         }
     }];
}

- (void)offertOrderWithOrderId:(NSString *)orderId
{
    [IPCPayOrderRequestManager offerOrderWithOrderId:orderId SuccessBlock:^(id responseValue)
     {
         [self authOrderWithOrderNum:responseValue[@"orderNumber"]];
     } FailureBlock:^(NSError *error) {
         if (self.ErrorPayBlock) {
             self.ErrorPayBlock(IPCPayOrderErrorOfferOrder);
         }
     }];
}

- (void)authOrderWithOrderNum:(NSString *)orderNum
{
    [IPCPayOrderRequestManager authOrderWithOrderNum:orderNum SuccessBlock:^(id responseValue)
     {
         if ([IPCAppManager sharedManager].companyCofig.autoInvOutAfterAudited) {
             [self outboundWithOrderNum:responseValue[@"orderNumber"]];
         }
         [self payCashWithOrderNum:responseValue[@"orderNumber"]];
         
     } FailureBlock:^(NSError *error) {
         if (self.ErrorPayBlock) {
             self.ErrorPayBlock(IPCPayOrderErrorAuthOrder);
         }
     }];
}

- (void)outboundWithOrderNum:(NSString *)orderNum
{
    ///出库操作
    [IPCPayOrderRequestManager outbound:orderNum SuccessBlock:nil FailureBlock:nil];
}

- (void)payCashWithOrderNum:(NSString *)orderNum
{
    [IPCPayOrderRequestManager payCashOrderWithOrderNumber:orderNum SuccessBlock:^(id responseValue)
     {
         [IPCCommonUI showSuccess:@"收银成功!"];
         
         if (self.CompletePayCashBlock) {
             self.CompletePayCashBlock();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:@"订单收银失败!"];
         
         if (self.ErrorPayBlock) {
             self.ErrorPayBlock(IPCPayOrderErrorPayCashOrder);
         }
     }];
}




@end
