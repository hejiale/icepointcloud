//
//  IPCPayOrderManager.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderManager.h"

@implementation IPCPayOrderManager

+ (IPCPayOrderManager *)sharedManager
{
    static dispatch_once_t token;
    static IPCPayOrderManager *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray<IPCPayOrderPayType *> *)payTypeArray
{
    if (!_payTypeArray) {
        _payTypeArray = [[NSMutableArray alloc]init];
    }
    return _payTypeArray;
}


-(NSMutableArray<IPCPayRecord *> *)payTypeRecordArray{
    if (!_payTypeRecordArray) {
        _payTypeRecordArray = [[NSMutableArray alloc] init];
    }
    return _payTypeRecordArray;
}

- (double)payRecordTotalPrice
{
    __block double totalPrice = 0;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.payOrderType.payType isEqualToString:@"积分"]) {
            totalPrice += obj.pointPrice;
        }else{
            totalPrice += obj.payPrice;
        }
    }];
    return totalPrice;
}

- (double)remainPayPrice{
    if ([IPCPayOrderManager sharedManager].payAmount - [[IPCPayOrderManager sharedManager] payRecordTotalPrice] < 0) {
        return 0;
    }
    return [IPCPayOrderManager sharedManager].payAmount - [[IPCPayOrderManager sharedManager] payRecordTotalPrice];
}

- (double)calculateDiscount
{
    if ([IPCPayOrderManager sharedManager].payAmount <= 0) {
        return 100;
    }
    double discount = (double)[IPCPayOrderManager sharedManager].payAmount/[[IPCShoppingCart sharedCart] allGlassesTotalPrePrice];
    NSString * discountStr = [NSString stringWithFormat:@"%@",[IPCCommon formatNumber:discount Location:5]];
    return [discountStr doubleValue] * 100;
}

- (BOOL)isCanPayOrder
{
    if (![IPCPayOrderManager sharedManager].currentCustomerId) {
        [IPCCommonUI showError:@"请选择客户!"];
        return NO;
    }else if ([[IPCShoppingCart sharedCart] allGlassesCount] == 0){
        [IPCCommonUI showError:@"购物列表为空!"];
        return NO;
    }else if ([[IPCPayOrderManager sharedManager] payTypeRecordArray].count == 0){
        [IPCCommonUI showError:@"收银记录为空!"];
        return NO;
    }else if ([IPCPayOrderManager sharedManager].isInsertRecord){
        [IPCCommonUI showError:@"请完成确认添加付款记录!"];
        return NO;
    }else if (![IPCPayOrderManager sharedManager].employee){
        [IPCCommonUI showError:@"请选择经办人!"];
        return NO;
    }
    return YES;
}

- (void)clearPayRecord
{
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
}

- (void)queryPayType
{
    [[IPCPayOrderManager sharedManager].payTypeArray removeAllObjects];
    
    [IPCPayOrderRequestManager queryPayListTypeWithSuccessBlock:^(id responseValue)
    {
        if ([responseValue isKindOfClass:[NSArray class]]) {
            [responseValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCPayOrderPayType * payType = [IPCPayOrderPayType mj_objectWithKeyValues:obj];
                [[IPCPayOrderManager sharedManager].payTypeArray addObject:payType];
            }];
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)resetEmployee
{
    [IPCPayOrderManager sharedManager].employee = [[IPCEmployee alloc]init];
    [IPCPayOrderManager sharedManager].employee = [IPCAppManager sharedManager].storeResult.employee;
}

- (void)resetData
{
    [IPCPayOrderManager sharedManager].remark = nil;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
    [IPCPayOrderManager sharedManager].currentCustomerId = nil;
    [IPCPayOrderManager sharedManager].currentOptometryId = nil;
    [IPCPayOrderManager sharedManager].integralTrade = nil;
    [IPCPayOrderManager sharedManager].currentHouse = nil;
    [IPCPayOrderManager sharedManager].payAmount = 0;
    [IPCPayOrderManager sharedManager].discount = 0;
    [IPCPayOrderManager sharedManager].discountAmount = 0;
    [[IPCPayOrderManager sharedManager] resetEmployee];
    [IPCPayOrderManager sharedManager].isInsertRecord = NO;
    [[IPCPayOrderCurrentCustomer sharedManager] clearData];
    [[IPCShoppingCart sharedCart] clear];
}


@end
