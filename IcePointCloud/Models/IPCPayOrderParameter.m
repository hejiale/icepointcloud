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
    
    if (isChooseCustomer) {
        if ([IPCCurrentCustomer sharedManager].currentCustomer.customerID) {
            [parameters setObject:[IPCCurrentCustomer sharedManager].currentCustomer.customerID forKey:@"customerId"];
        }
        if ([IPCCurrentCustomer sharedManager].currentOpometry.optometryID) {
            [parameters setObject:[IPCCurrentCustomer sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
        }
        if ([IPCCurrentCustomer sharedManager].currentAddress.addressID) {
            [parameters setObject:[IPCCurrentCustomer sharedManager].currentAddress.addressID forKey:@"addressId"];
        }
    }else{
        //新增用户信息
        IPCDetailCustomer * customer = [IPCCurrentCustomer sharedManager].currentCustomer;
        if (customer) {
            [parameters setObject:customer.customerName ? : @"" forKey:@"customerName"];
            [parameters setObject:customer.customerPhone ? : @"" forKey:@"customerPhone"];
            [parameters setObject:customer.contactorGengerString ? : @"" forKey:@"genderString"];
            [parameters setObject:customer.email ? : @"" forKey:@"email"];
            [parameters setObject:customer.birthday ? : @"" forKey:@"birthday"];
            [parameters setObject:customer.remark ? : @"" forKey:@"remark"];
            [parameters setObject:customer.employeeId ? : @"" forKey:@"handlEmployeeId"];
            [parameters setObject:customer.customerType ? : @"" forKey:@"customerType"];
            [parameters setObject:customer.customerTypeId ? : @"" forKey:@"customerTypeId"];
            [parameters setObject:customer.memberLevelId ? : @"" forKey:@"memberLevel"];
            [parameters setObject:customer.memberLevel ? : @"" forKey:@"memberLevelId"];
            [parameters setObject:customer.memberId ? : @"" forKey:@"memberId"];
            [parameters setObject:customer.occupation ? : @"" forKey:@"occupation"];
        }
        //地址
        IPCCustomerAddressMode * address = [IPCCurrentCustomer sharedManager].currentAddress;
        if (address) {
            [parameters setObject:address.contactorName ? : @"" forKey:@"contactorName"];
            [parameters setObject:address.genderString ? : @"" forKey:@"contactorGengerString"];
            [parameters setObject:address.contactorPhone ? : @"" forKey:@"contactorPhone"];
            [parameters setObject:address.detailAddress ? : @"" forKey:@"contactorAddress"];
        }
        //验光单
        IPCOptometryMode * optometry = [IPCCurrentCustomer sharedManager].currentOpometry;
        if (optometry) {
            [parameters setObject:optometry.sphLeft ? : @"" forKey:@"sphLeft"];
            [parameters setObject:optometry.sphRight ? : @"" forKey:@"sphRight"];
            [parameters setObject:optometry.cylLeft ? : @"" forKey:@"cylLeft"];
            [parameters setObject:optometry.cylRight ? : @"" forKey:@"cylRight"];
            [parameters setObject:optometry.axisLeft ? : @"" forKey:@"axisLeft"];
            [parameters setObject:optometry.axisRight ? : @"" forKey:@"axisRight"];
            [parameters setObject:optometry.addLeft ? : @"" forKey:@"addLeft"];
            [parameters setObject:optometry.addRight ? : @"" forKey:@"addRight"];
            [parameters setObject:optometry.distanceLeft ? : @"" forKey:@"distanceLeft"];
            [parameters setObject:optometry.distanceRight ? : @"" forKey:@"distanceRight"];
            [parameters setObject:optometry.correctedVisionLeft ? : @"" forKey:@"correctedVisionLeft"];
            [parameters setObject:optometry.correctedVisionRight ? : @"" forKey:@"correctedVisionRight"];
            [parameters setObject:optometry.purpose ? : @"" forKey:@"purpose"];
            [parameters setObject:optometry.employeeId ? : @"" forKey:@"employeeId"];
        }
    }
    [parameters setObject:@"FOR_SALES" forKey:@"orderType"];
    [parameters setObject:[self productListParamter] forKey:@"detailList"];
    
    if (employeeList.count) {
        [parameters setObject:employeeList forKey:@"employeeAchievements"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].realTotalPrice] forKey:@"orderFinalPrice"];
    
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
    
    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens)
    {
        [parameters setObject:@"true" forKey:@"isCustomizedLens"];
    }
    [parameters setObject:[IPCPayOrderManager sharedManager].remark ? : @"" forKey:@"orderRemark"];
    
    return parameters;
}



- (NSArray *)productListParamter
{
    __block NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    
    //***********区分定制商品与普通商品**************//
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
