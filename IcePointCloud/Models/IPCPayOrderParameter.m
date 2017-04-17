//
//  IPCPayOrderParameter.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderParameter.h"

@implementation IPCPayOrderParameter


- (NSDictionary *)offOrderParameterWithPayStatus:(BOOL)payStatus//(payStatus判断新建订单时是新增的用户还是选取的用户)
{
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
        NSMutableDictionary * otherResultDic = [[NSMutableDictionary alloc]init];
        [otherResultDic setObject:@(obj.otherPayAmount) forKey:@"price"];
        [otherResultDic setObject:obj.otherPayTypeName forKey:@"payTypeInfo"];
        [otherTypeList addObject:otherResultDic];
    }];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    if (payStatus) {
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID forKey:@"customerId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentAddress.addressID forKey:@"addressId"];
    }else{
        //新增用户信息  验光单  地址
        
    }
    
    [parameters setObject:@"FOR_SALES" forKey:@"orderType"];
    [parameters setObject:[self productListParamter] forKey:@"detailList"];
    [parameters setObject:employeeList forKey:@"employeeAchievements"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].realTotalPrice) forKey:@"orderFinalPrice"];
    [parameters setObject:([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount ? @"false" : @"true") forKey:@"isAdvancePayment"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].presellAmount) forKey:@"payAmount"];
    [parameters setObject:[IPCPayOrderMode sharedManager].payStyleName forKey:@"payType"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].usedPoint) forKey:@"integral"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].givingAmount) forKey:@"donationAmount"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].usedBalanceAmount) forKey:@"usebalanceAmount"];
    [parameters setObject:@([IPCPayOrderMode sharedManager].payTypeAmount) forKey:@"payTypeAmount"];
    [parameters setObject:otherTypeList forKey:@"payTypeDetails"];

    return parameters;
}



- (NSArray *)productListParamter
{
    __block NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    
    IPCShoppingCart *cart = [IPCShoppingCart sharedCart];
    
    for (int i = 0; i < cart.itemsCount; i++) {
        IPCShoppingCartItem *item = [cart itemAtIndex:i];
        if (item.selected){
            [itemParams addObject:[item paramtersJSONForOrderRequest]];
        }
    }
    return itemParams;
}

@end
