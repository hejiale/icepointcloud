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
                 Error:(void(^)(IPCPayOrderError errorType))error
{
    self.CompletePrototyBlock = prototy;
    self.CompletePayCashBlock = payCash;
    self.ErrorPayBlock = error;
    
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager savePrototyOrderWithSuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if (!isProty) {
             [strongSelf offertOrderWithOrderId:responseValue[@"id"]];
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
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager offerOrderWithOrderId:orderId SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf authOrderWithOrderNum:responseValue[@"orderNumber"]];
     } FailureBlock:^(NSError *error) {
         if (self.ErrorPayBlock) {
             self.ErrorPayBlock(IPCPayOrderErrorOfferOrder);
         }
     }];
}

- (void)authOrderWithOrderNum:(NSString *)orderNum
{
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager authOrderWithOrderNum:orderNum SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf payCashWithOrderNum:responseValue[@"orderNumber"]];
     } FailureBlock:^(NSError *error) {
         if (self.ErrorPayBlock) {
             self.ErrorPayBlock(IPCPayOrderErrorAuthOrder);
         }
     }];
}

- (void)payCashWithOrderNum:(NSString *)orderNum
{
    __weak typeof(self) weakSelf = self;
    [IPCPayOrderRequestManager payCashOrderWithOrderNumber:orderNum SuccessBlock:^(id responseValue)
     {
         [IPCCommonUI showSuccess:@"收银成功!"];
         __strong typeof(weakSelf) strongSelf = weakSelf;
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
