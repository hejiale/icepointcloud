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
    
    if (![IPCCurrentCustomer sharedManager].currentCustomer.customerID)isChooseCustomer = NO;
    
    //员工份额
    NSMutableArray * employeeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * employeeResultDic = [[NSMutableDictionary alloc]init];
        [employeeResultDic setObject:@(obj.employeeResult) forKey:@"achievement"];
        [employeeResultDic setObject:obj.employe.jobID forKey:@"employeeId"];
        [employeeList addObject:employeeResultDic];
    }];
    
    //支付方式
    NSMutableArray * otherTypeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * otherResultDic = [[NSMutableDictionary alloc]init];
        [otherResultDic setObject:[NSString stringWithFormat:@"%.2f",obj.payAmount] forKey:@"payAmount"];
        [otherResultDic setObject:obj.payStyleName forKey:@"payType"];
        [otherTypeList addObject:otherResultDic];
    }];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    if (isChooseCustomer) {
        if ([IPCCurrentCustomer sharedManager].currentCustomer.customerID.length) {
            [parameters setObject:[IPCCurrentCustomer sharedManager].currentCustomer.customerID forKey:@"customerId"];
        }
        if ([IPCCurrentCustomer sharedManager].currentOpometry.optometryID.length) {
            [parameters setObject:[IPCCurrentCustomer sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
        }
        if ([IPCCurrentCustomer sharedManager].currentAddress.addressID.length) {
            [parameters setObject:[IPCCurrentCustomer sharedManager].currentAddress.addressID forKey:@"addressId"];
        }
    }
    [parameters setObject:@"FOR_SALES" forKey:@"orderType"];
    [parameters setObject:[self productListParamter] forKey:@"detailList"];
    if (employeeList.count) {
        [parameters setObject:employeeList forKey:@"employeeAchievements"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%.2f",[IPCPayOrderMode sharedManager].realTotalPrice] forKey:@"orderFinalPrice"];
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint]) {//积分兑换置为0
        [parameters setObject:@(0) forKey:@"integral"];
    }else{
        [parameters setObject:@([IPCPayOrderMode sharedManager].usedPoint) forKey:@"integral"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%.2f",[IPCPayOrderMode sharedManager].givingAmount] forKey:@"donationAmount"];
    if (otherTypeList.count) {
        [parameters setObject:otherTypeList forKey:@"orderPayInfos"];
    }
    [parameters setObject:([[IPCShoppingCart sharedCart] isHaveUsedPoint] ? @"true" : @"false") forKey:@"isIntegralExchange"];
    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) {
        [parameters setObject:@"true" forKey:@"isCustomizedLens"];
    }
    [parameters setObject:[IPCPayOrderMode sharedManager].remark ? : @"" forKey:@"orderRemark"];

    return parameters;
}



- (NSArray *)productListParamter
{
    __block NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    
    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens)
    {
        [itemParams addObject:[[IPCCustomsizedItem sharedItem] paramtersJSONForOrderRequest]];
        
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
