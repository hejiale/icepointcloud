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
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID forKey:@"customerId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentAddress.addressID forKey:@"addressId"];
    }else{
        //新增用户信息
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerName forKey:@"customerName"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerPhone forKey:@"customerPhone"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.contactorGengerString forKey:@"genderString"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.email forKey:@"email"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.birthday forKey:@"birthday"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.remark forKey:@"remark"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.employeeId forKey:@"handlEmployeeId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerType forKey:@"customerType"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerTypeId forKey:@"customerTypeId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.memberLevelId forKey:@"memberLevel"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.memberLevel forKey:@"memberLevelId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.memberId forKey:@"memberId"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.occupation forKey:@"occupation"];
        //地址
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentAddress.contactName forKey:@"contactorName"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentAddress.genderString forKey:@"contactorGengerString"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentAddress.phone forKey:@"contactorPhone"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentAddress.detailAddress forKey:@"contactorAddress"];
        //验光单
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.sphLeft forKey:@"sphLeft"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.sphRight forKey:@"sphRight"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.cylLeft forKey:@"cylLeft"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.cylRight forKey:@"cylRight"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.axisLeft forKey:@"axisLeft"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.axisRight forKey:@"axisRight"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.addLeft forKey:@"addLeft"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.addRight forKey:@"addRight"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.distanceLeft forKey:@"distanceLeft"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.distanceRight forKey:@"distanceRight"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.correctedVisionLeft forKey:@"correctedVisionLeft"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.correctedVisionRight forKey:@"correctedVisionRight"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.purpose forKey:@"purpose"];
        [parameters setObject:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.employeeId forKey:@"employeeId"];
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
    
    for (int i = 0; i < [[IPCShoppingCart sharedCart] selectPayItemsCount]; i++) {
        IPCShoppingCartItem *item = [[IPCShoppingCart sharedCart] selectedPayItemAtIndex:i];
        [itemParams addObject:[item paramtersJSONForOrderRequest]];
    }
    return itemParams;
}

@end
