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
    //员工份额
    __block NSMutableArray * employeeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * employeeResultDic = [[NSMutableDictionary alloc]init];
        [employeeResultDic setObject:@(obj.achievement) forKey:@"achievement"];
        [employeeResultDic setObject:obj.employee.jobID forKey:@"employeeId"];
        [employeeList addObject:employeeResultDic];
    }];
    
    //支付方式
    __block NSMutableArray * otherTypeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderManager sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * otherResultDic = [[NSMutableDictionary alloc]init];
        [otherResultDic setObject:[NSString stringWithFormat:@"%.2f",obj.payPrice] forKey:@"payAmount"];
        [otherResultDic setObject:obj.payTypeInfo forKey:@"payType"];
        [otherTypeList addObject:otherResultDic];
    }];
    
    __block NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    if ([IPCCurrentCustomer sharedManager].currentCustomer) {
        [parameters setObject:[IPCCurrentCustomer sharedManager].currentCustomer.customerID forKey:@"customerId"];
    }
    if ([IPCCurrentCustomer sharedManager].currentOpometry) {
        [parameters setObject:[IPCCurrentCustomer sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
    }
    if ([IPCCurrentCustomer sharedManager].currentAddress) {
        [parameters setObject:[IPCCurrentCustomer sharedManager].currentAddress.addressID forKey:@"addressId"];
    }
    
    [parameters setObject:@"FOR_SALES" forKey:@"orderType"];
    [parameters setObject:@"PayAmount" forKey:@"allPay"];
    [parameters setObject:[self productListParamter] forKey:@"detailList"];
    
    if (employeeList.count) {
        [parameters setObject:employeeList forKey:@"employeeAchievements"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%.2f",[[IPCPayOrderManager sharedManager] realTotalPrice]] forKey:@"orderFinalPrice"];
    
    if ([[IPCShoppingCart sharedCart] isHaveUsedPoint]) {//积分兑换置为0
        [parameters setObject:@(0) forKey:@"integral"];
    }else{
        [parameters setObject:@([IPCPayOrderManager sharedManager].usedPoint) forKey:@"integral"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].givingAmount] forKey:@"donationAmount"];
    
    if (otherTypeList.count) {
        [parameters setObject:otherTypeList forKey:@"orderPayInfos"];
    }
    [parameters setObject:([[IPCShoppingCart sharedCart] isHaveUsedPoint] ? @"true" : @"false") forKey:@"isIntegralExchange"];
    [parameters setObject:[IPCPayOrderManager sharedManager].remark ? : @"" forKey:@"orderRemark"];
    [parameters setObject:[IPCPayOrderManager sharedManager].currentHouse.wareHouseId ? : @"" forKey:@"repository"];
    
    return parameters;
}



- (NSArray *)productListParamter
{
    __block NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [[IPCShoppingCart sharedCart] itemsCount]; i++) {
        IPCShoppingCartItem *item = [[IPCShoppingCart sharedCart] itemAtIndex:i];
        [itemParams addObject:[item paramtersJSONForOrderRequest]];
    }
    return itemParams;
}

@end
