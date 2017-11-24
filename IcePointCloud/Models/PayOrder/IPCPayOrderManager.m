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
        self.insertOptometry = [[IPCOptometryMode alloc]init];
        self.employee = [[IPCEmployee alloc]init];
        self.employee = [IPCAppManager sharedManager].storeResult.employee;
    }
    return self;
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
        if ([obj.payTypeInfo isEqualToString:@"积分"]) {
            totalPrice += obj.pointPrice;
        }else{
            totalPrice += obj.payPrice;
        }
    }];
    return totalPrice;
}

- (double)remainPayPrice{
    return [IPCPayOrderManager sharedManager].payAmount - [[IPCPayOrderManager sharedManager] payRecordTotalPrice];
}

- (double)calculateDiscount
{
    if ([IPCPayOrderManager sharedManager].payAmount <= 0 || [IPCPayOrderManager sharedManager].payAmount >= [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice]) {
        return 0;
    }
    double discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] - [IPCPayOrderManager sharedManager].payAmount;
    double discount = (double)discountAmount/[[IPCShoppingCart sharedCart] allGlassesTotalPrePrice];
    NSString * discountStr = [NSString stringWithFormat:@"%.4f",discount];
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
    }
    return YES;
}

- (BOOL)judgeIsHaveEditPayRecord
{
    __block BOOL isHaveEdit = NO;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (obj.isEditStatus) {
            isHaveEdit = YES;
            *stop = YES;
        }
    }];
    return isHaveEdit;
}

- (void)clearPayRecord
{
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
}

- (void)resetData
{
    [IPCPayOrderManager sharedManager].remark = nil;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
    [[IPCCurrentCustomer sharedManager] clearData];
    [IPCPayOrderManager sharedManager].currentCustomerId = nil;
    [IPCPayOrderManager sharedManager].payAmount = 0;
    [IPCPayOrderManager sharedManager].discount = 0;
    [IPCPayOrderManager sharedManager].discountAmount = 0;
    [IPCPayOrderManager sharedManager].employee = [IPCAppManager sharedManager].storeResult.employee;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
    [[IPCShoppingCart sharedCart] clear];
}


@end
