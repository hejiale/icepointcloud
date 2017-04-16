//
//  IPCPayOrderMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderMode.h"

@implementation IPCPayOrderMode

+ (IPCPayOrderMode *)sharedManager
{
    static dispatch_once_t token;
    static IPCPayOrderMode *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.payType = IPCOrderPayTypePayAmount;
        self.payStyle = IPCPayStyleTypeCash;
    }
    return self;
}


- (void)clearData
{
    [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypeNone;
    [[IPCPayOrderMode sharedManager].employeeResultArray removeAllObjects];
    [IPCPayOrderMode sharedManager].point = 0;
    [IPCPayOrderMode sharedManager].pointPrice = 0;
    [IPCPayOrderMode sharedManager].usedPoint = 0;
    [IPCPayOrderMode sharedManager].presellAmount = 0;
    [IPCPayOrderMode sharedManager].givingAmount = 0;
    [IPCPayOrderMode sharedManager].orderTotalPrice = 0;
    [IPCPayOrderMode sharedManager].realTotalPrice = 0;
    [IPCPayOrderMode sharedManager].balanceAmount = 0;
    [IPCPayOrderMode sharedManager].isSelectPoint = NO;
    [[IPCPayOrderMode sharedManager] clearPayTypeData];
}


- (void)clearPayTypeData
{
    [[IPCPayOrderMode sharedManager].otherPayTypeArray removeAllObjects];
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCash;
    [IPCPayOrderMode sharedManager].payStyleName = @"";
    [IPCPayOrderMode sharedManager].payTypeAmount = 0;
    [IPCPayOrderMode sharedManager].usedBalanceAmount = 0;
    [IPCPayOrderMode sharedManager].isSelectStoreValue = NO;
    [IPCPayOrderMode sharedManager].isSelectPayType = YES;
}

- (double)judgeEmployeeResult:(double)result Employee:(IPCEmployeeResult *)employeeResult
{
    __block double  remainResult = 0;
    __block double  otherTotalResult = 0;//计算除当前员工下的总份额
    
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( ! [obj.employe.jobID isEqualToString:employeeResult.employe.jobID]) {
            otherTotalResult += obj.employeeResult;
        }
    }];
    
    remainResult = 100 - otherTotalResult;// 剩余份额
    
    if (remainResult < result) {
        if (remainResult > 0) {
            [IPCCustomUI showError:[NSString stringWithFormat:@"该员工至多百分之%.f份额",remainResult]];
        }else{
            [IPCCustomUI showError:@"请调整其他员工的份额"];
        }
    }else{
        remainResult = result;
    }
    
    return remainResult;
}


- (double)totalEmployeeResult
{
    __block double  totalResult = 0;//计算所有员工下的总份额
    
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalResult += obj.employeeResult;
    }];
    return totalResult;
}

- (NSMutableArray<IPCEmployeeResult *> *)employeeResultArray{
    if (!_employeeResultArray) {
        _employeeResultArray= [[NSMutableArray alloc]init];
    }
    return _employeeResultArray;
}

- (double)minimumEmployeeDiscountPrice:(double)originPrice
{
    __block NSMutableArray * discountArray = [[NSMutableArray alloc]init];
    
    if ([IPCPayOrderMode sharedManager].employeeResultArray.count == 0) {
        [IPCCustomUI showError:@"请先选择员工"];
        return 0;
    }
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [discountArray addObject:[NSNumber numberWithDouble:obj.employe.discount]];
    }];
    
    [discountArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 doubleValue] < [obj2 doubleValue];
    }];

    double minimumDiscount = [discountArray[0] doubleValue];

    return  (minimumDiscount/10) * originPrice;
}

- (double)totalOtherPayTypeAmount{
    __block double amount = 0;
    [[IPCPayOrderMode sharedManager].otherPayTypeArray enumerateObjectsUsingBlock:^(IPCOtherPayTypeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        amount += obj.otherPayAmount;
    }];
    return amount;
}

- (NSMutableArray<IPCOtherPayTypeResult *> *)otherPayTypeArray{
    if (!_otherPayTypeArray) {
        _otherPayTypeArray = [[NSMutableArray alloc]init];
    }
    return _otherPayTypeArray;
}

- (void)reloadWithOtherTypeAmount
{
    //待支付金额
    [IPCPayOrderMode sharedManager].payTypeAmount = [[IPCPayOrderMode sharedManager] waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount] - [IPCPayOrderMode sharedManager].usedBalanceAmount;

    if ([IPCPayOrderMode sharedManager].payTypeAmount < 0) {
        [IPCPayOrderMode sharedManager].payTypeAmount = 0;
    }
}

- (double)waitPayAmount{
    if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount) {
        return  [IPCPayOrderMode sharedManager].realTotalPrice;
    }else{
        return  [IPCPayOrderMode sharedManager].presellAmount;
    }
}



@end
