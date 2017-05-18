//
//  IPCPayOrderParameter.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderParameter.h"

@implementation IPCPayOrderParameter


- (NSDictionary *)offOrderParameter
{
    BOOL isChooseCustomer = YES;
    
    if (![IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID)isChooseCustomer = NO;
    
    //员工份额
    NSMutableArray * employeeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * employeeResultDic = [[NSMutableDictionary alloc]init];
        [employeeResultDic setObject:@(obj.employeeResult) forKey:@"achievement"];
        [employeeResultDic setObject:obj.employe.jobID forKey:@"employeeId"];
        [employeeList addObject:employeeResultDic];
    }];
    
    //其它支付方式
    NSMutableArray * otherTypeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].otherPayTypeArray enumerateObjectsUsingBlock:^(IPCOtherPayTypeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.otherPayAmount > 0) {
            NSMutableDictionary * otherResultDic = [[NSMutableDictionary alloc]init];
            [otherResultDic setObject:@(obj.otherPayAmount) forKey:@"price"];
            [otherResultDic setObject:obj.otherPayTypeName forKey:@"payTypeInfo"];
            [otherTypeList addObject:otherResultDic];
        }
    }];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    if (isChooseCustomer) {
        if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID.length) {
            [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID forKey:@"customerId"];
        }
        if ([IPCCurrentCustomerOpometry sharedManager].currentOpometry.optometryID.length) {
            [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
        }
        if ([IPCCurrentCustomerOpometry sharedManager].currentAddress.addressID.length) {
            [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentAddress.addressID forKey:@"addressId"];
        }
    }
    [parameters setObject:@"FOR_SALES" forKey:@"orderType"];
    [parameters setObject:[self productListParamter] forKey:@"detailList"];
    [parameters setObject:employeeList forKey:@"employeeAchievements"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].realTotalPrice) forKey:@"orderFinalPrice"];
    [parameters setObject:([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount ? @"false" : @"true") forKey:@"isAdvancePayment"];
    [parameters setObject:@([[IPCPayOrderMode sharedManager] waitPayAmount]) forKey:@"payAmount"];
    [parameters setObject:[IPCPayOrderMode sharedManager].payStyleName forKey:@"payType"];
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint]) {//积分兑换置为0
        [parameters setObject:@(0) forKey:@"integral"];
    }else{
        [parameters setObject:@([IPCPayOrderMode sharedManager].usedPoint) forKey:@"integral"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%.2f",[IPCPayOrderMode sharedManager].givingAmount] forKey:@"donationAmount"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].usedBalanceAmount) forKey:@"usebalanceAmount"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].payTypeAmount) forKey:@"payTypeAmount"];
    [parameters setObject:otherTypeList forKey:@"payTypeDetails"];
    [parameters setObject:([[IPCShoppingCart sharedCart] isHaveUsedPoint] ? @"true" : @"false") forKey:@"isIntegralExchange"];

    return parameters;
}



- (NSArray *)productListParamter
{
    __block NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    
    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens)
    {
        for (int i = 0; i < [IPCCustomsizedItem sharedItem].normalProducts.count; i++) {
            IPCShoppingCartItem * item = [IPCCustomsizedItem sharedItem].normalProducts[i];
            [itemParams addObject:[item paramtersJSONForOrderRequest]];
        }
    }else{
        for (int i = 0; i < [[IPCShoppingCart sharedCart] selectPayItemsCount]; i++) {
            IPCShoppingCartItem *item = [[IPCShoppingCart sharedCart] selectedPayItemAtIndex:i];
            [itemParams addObject:[item paramtersJSONForOrderRequest]];
        }
    }
    return itemParams;
}

@end
