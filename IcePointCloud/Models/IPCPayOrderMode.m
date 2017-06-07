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


- (void)resetData
{
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCash;
    [IPCPayOrderMode sharedManager].payStyleName = @"CASH";
    [[IPCPayOrderMode sharedManager].employeeResultArray removeAllObjects];
    [IPCPayOrderMode sharedManager].point = 0;
    [IPCPayOrderMode sharedManager].pointPrice = 0;
    [IPCPayOrderMode sharedManager].usedPoint = 0;
    [IPCPayOrderMode sharedManager].givingAmount = 0;
    [IPCPayOrderMode sharedManager].orderTotalPrice = 0;
    [IPCPayOrderMode sharedManager].realTotalPrice = 0;
    [IPCPayOrderMode sharedManager].balanceAmount = 0;
    [IPCPayOrderMode sharedManager].isSelectPoint = NO;
    [IPCPayOrderMode sharedManager].isPayOrderStatus = NO;
    [IPCPayOrderMode sharedManager].isSelectPayType = YES;
    [IPCPayOrderMode sharedManager].isInsertRecordStatus = NO;
    [IPCPayOrderMode sharedManager].insertPayRecord = nil;
    [IPCPayOrderMode sharedManager].customerDiscount = 0;
    [IPCPayOrderMode sharedManager].remainAmount = 0;
    [[IPCPayOrderMode sharedManager] clearPayTypeData];
}


- (void)clearPayTypeData
{
    [[IPCPayOrderMode sharedManager].otherPayTypeArray removeAllObjects];
    [[IPCPayOrderMode sharedManager].payTypeRecordArray removeAllObjects];
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCash;
    [IPCPayOrderMode sharedManager].payStyleName = @"CASH";
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

-(NSMutableArray<IPCPayRecord *> *)payTypeRecordArray{
    if (!_payTypeRecordArray) {
        _payTypeRecordArray = [[NSMutableArray alloc] init];
    }
    return _payTypeRecordArray;
}


- (void)reloadWithOtherTypeAmount
{
    //待支付金额
    if ([IPCPayOrderMode sharedManager].isSelectPayType)
    {
        [IPCPayOrderMode sharedManager].payTypeAmount = [IPCPayOrderMode sharedManager].realTotalPrice - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount] - [IPCPayOrderMode sharedManager].usedBalanceAmount;
        if ([IPCPayOrderMode sharedManager].payTypeAmount < 0) {
            [IPCPayOrderMode sharedManager].payTypeAmount = 0;
        }
    }else{
        [IPCPayOrderMode sharedManager].payTypeAmount = 0;
    }
}

- (void)calculatePointValue:(IPCPointValueMode *)pointValue{
    __block double pointPrice = 0;
    __block NSInteger point = 0;
    [pointValue.pointArray enumerateObjectsUsingBlock:^(IPCPointValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        pointPrice += obj.integralDeductionAmount;
        point += obj.deductionIntegral;
    }];
    
    [IPCPayOrderMode sharedManager].pointPrice = pointPrice;
    [IPCPayOrderMode sharedManager].usedPoint = point;
    
    if ([[IPCShoppingCart sharedCart] selectedPayItemTotalPrice] - [IPCPayOrderMode sharedManager].pointPrice <= 0) {
        [IPCPayOrderMode sharedManager].realTotalPrice = 0;
    }else{
        [IPCPayOrderMode sharedManager].realTotalPrice = [[IPCShoppingCart sharedCart] selectedPayItemTotalPrice] - [IPCPayOrderMode sharedManager].pointPrice;
    }
    [IPCPayOrderMode sharedManager].givingAmount = 0;
    [IPCPayOrderMode sharedManager].remainAmount = [IPCPayOrderMode sharedManager].realTotalPrice;
    [[IPCPayOrderMode sharedManager].payTypeRecordArray removeAllObjects];
}

- (double)minumEmployeeResult
{
    __block double totalResult = 0;
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalResult += obj.employeeResult;
    }];
    return MAX(100 - totalResult, 0);
}

- (BOOL)isExistEmptyEmployeeResult{
    __block BOOL isExist = NO;
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.employeeResult == 0 ) {
            isExist = YES;
        }
    }];
    return isExist;
}


- (BOOL)isExistZeroOtherTypeAmount{
    __block BOOL isExist = NO;
    [[IPCPayOrderMode sharedManager].otherPayTypeArray enumerateObjectsUsingBlock:^(IPCOtherPayTypeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.otherPayAmount <= 0 ) {
            isExist = YES;
        }
    }];
    return isExist;
}


- (BOOL)isExistEmptyOtherTypeName{
    __block BOOL isExist = NO;
    [[IPCPayOrderMode sharedManager].otherPayTypeArray enumerateObjectsUsingBlock:^(IPCOtherPayTypeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.otherPayTypeName.length == 0 ) {
            isExist = YES;
        }
    }];
    return isExist;
}

@end
