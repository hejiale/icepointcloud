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

- (NSMutableArray<IPCEmployeeResult *> *)employeeResultArray{
    if (!_employeeResultArray) {
        _employeeResultArray= [[NSMutableArray alloc]init];
    }
    return _employeeResultArray;
}

-(NSMutableArray<IPCPayRecord *> *)payTypeRecordArray{
    if (!_payTypeRecordArray) {
        _payTypeRecordArray = [[NSMutableArray alloc] init];
    }
    return _payTypeRecordArray;
}

- (double)judgeEmployeeResult:(double)result Employee:(IPCEmployeeResult *)employeeResult
{
    __block double  remainResult = 0;
    __block double  otherTotalResult = 0;//计算除当前员工下的总份额
    
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( ! [obj.employee.jobID isEqualToString:employeeResult.employee.jobID]) {
            otherTotalResult += obj.achievement;
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
    
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalResult += obj.achievement;
    }];
    return totalResult;
}

- (double)minimumEmployeeDiscountPrice:(double)originPrice
{
    __block NSMutableArray * discountArray = [[NSMutableArray alloc]init];
    
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [discountArray addObject:[NSNumber numberWithDouble:obj.employee.discount]];
    }];
    
    [discountArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 doubleValue] < [obj2 doubleValue];
    }];

    double minimumDiscount = [discountArray[0] doubleValue];

    return  (minimumDiscount/10) * originPrice;
}

- (double)realTotalPrice{
    return [[IPCShoppingCart sharedCart] allGlassesTotalPrice] - [IPCPayOrderManager sharedManager].pointPrice - [IPCPayOrderManager sharedManager].givingAmount;
}

- (double)remainPayPrice{
    return [[IPCPayOrderManager sharedManager] realTotalPrice] - [[IPCPayOrderManager sharedManager] payRecordTotalPrice];
}

- (double)payRecordTotalPrice
{
    __block double totalPrice = 0;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalPrice += obj.payPrice;
    }];
    return totalPrice;
}

- (void)calculatePointValue:(IPCPointValueMode *)pointValue{
    __block double pointPrice = 0;
    __block NSInteger point = 0;
    [pointValue.pointArray enumerateObjectsUsingBlock:^(IPCPointValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        pointPrice += obj.integralDeductionAmount;
        point += obj.deductionIntegral;
    }];
    
    [IPCPayOrderManager sharedManager].pointPrice = pointPrice;
    [IPCPayOrderManager sharedManager].usedPoint = point;
    [IPCPayOrderManager sharedManager].point -= point;
}

- (double)minumEmployeeResult
{
    __block double totalResult = 0;
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalResult += obj.achievement;
    }];
    return MAX(100 - totalResult, 0);
}

- (BOOL)isExistEmptyEmployeeResult{
    __block BOOL isExist = NO;
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.achievement == 0 ) {
            isExist = YES;
        }
    }];
    return isExist;
}

- (void)resetData
{
    [[IPCPayOrderManager sharedManager].employeeResultArray removeAllObjects];
    [IPCPayOrderManager sharedManager].point = 0;
    [IPCPayOrderManager sharedManager].isInsertRecordStatus = NO;
    [IPCPayOrderManager sharedManager].insertPayRecord = nil;
    [IPCPayOrderManager sharedManager].customerDiscount = 0;
    [IPCPayOrderManager sharedManager].remark = nil;
    [IPCPayOrderManager sharedManager].isSelectPoint = NO;
    [IPCPayOrderManager sharedManager].usedPoint = 0;
    [IPCPayOrderManager sharedManager].pointPrice = 0;
    [IPCPayOrderManager sharedManager].givingAmount = 0;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
    [IPCPayOrderManager sharedManager].customerDiscount = 1;
    [IPCPayOrderManager sharedManager].isTrade = NO;
    [[IPCCurrentCustomer sharedManager] clearData];
    [IPCPayOrderManager sharedManager].currentCustomerId = nil;
    [[IPCShoppingCart sharedCart] clear];
}


@end
