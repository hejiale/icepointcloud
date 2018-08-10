//
//  IPCPayOrderParameter.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderParameter.h"

@implementation IPCPayOrderParameter


- (NSDictionary *)orderParameterWithCurrentStatus:(NSString *)currentStatus EndStatus:(NSString *)endStatus
{
    __block NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    ///员工份额
    NSMutableArray * employeeList = [[NSMutableArray alloc]init];
    
    NSMutableDictionary * employeeResultDic = [[NSMutableDictionary alloc]init];
    [employeeResultDic setObject:@(100) forKey:@"achievement"];
    [employeeResultDic setObject:[IPCPayOrderManager sharedManager].employee.jobID ? : @"" forKey:@"employeeId"];
    [employeeResultDic setObject:[IPCPayOrderManager sharedManager].employee.name ? : @"" forKey:@"name"];
    [employeeResultDic setObject:[IPCPayOrderManager sharedManager].employee.jobNumber ? : @"" forKey:@"jobNumber"];
    [employeeList addObject:employeeResultDic];
    
    ///表单数据
    NSMutableDictionary * formDic = [[NSMutableDictionary alloc]init];
    [formDic setObject:@"FOR_SALES" forKey:@"orderType"];
    
    //选择客户
    if ([[IPCPayOrderManager sharedManager] currentCustomer].customerID) {
        [formDic setObject:[[IPCPayOrderManager sharedManager] currentCustomer].customerID forKey:@"customerId"];
    }
    
    //转介绍人
    if ([IPCPayOrderManager sharedManager].introducer) {
        [formDic setObject:[IPCPayOrderManager sharedManager].introducer.customerID forKey:@"introducerId"];
    }
    //会员卡id
    if ([[IPCPayOrderManager sharedManager] currentMemberCard].memberCustomerId) {
        [formDic setObject:[[IPCPayOrderManager sharedManager] currentMemberCard].memberCustomerId forKey:@"memberCutomerId"];
    }
    
    if ([[IPCPayOrderManager sharedManager] currentMemberCard].memberPhone) {
        [formDic setObject:[[IPCPayOrderManager sharedManager] currentMemberCard].memberPhone forKey:@"memberPhone"];
    }
    
    [formDic setObject:[IPCAppManager sharedManager].currentWareHouse.wareHouseId forKey:@"repository"];
    [formDic setObject:employeeList forKey:@"employeeAchievements"];
    
    //验光单
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry) {
        [formDic setObject:[IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
    }
    
    //验证方式
    if ([IPCPayOrderManager sharedManager].isValiateMember) {
        [formDic setObject:[IPCPayOrderManager sharedManager].memberCheckType forKey:@"memberCheckType"];
    }else{
        [formDic setObject:@"NULL" forKey:@"memberCheckType;"];
    }
    
    [formDic setObject:[IPCPayOrderManager sharedManager].remark ? : @"" forKey:@"orderRemark"];
    [formDic setObject:[NSString stringWithFormat:@"%f",[[IPCShoppingCart sharedCart] allGlassesTotalPrePrice]] forKey:@"suggestPriceTotal"];
    [formDic setObject:[NSString stringWithFormat:@"%f",[IPCPayOrderManager sharedManager].payAmount] forKey:@"orderFinalPrice"];
    [formDic setObject:[NSString stringWithFormat:@"%f",[IPCPayOrderManager sharedManager].discountAmount] forKey:@"donationAmount"];
    [formDic setObject:[IPCPayOrderManager sharedManager].isValiateMember ? @"true" : @"false" forKey:@"isCheckMember"];
    [formDic setObject:[[IPCPayOrderManager sharedManager] extraDiscount] ? @"true" : @"false" forKey:@"isExcessDiscount"];
    [formDic setObject:[self productListParamter] forKey:@"detailList"];
    //定制 参数
    [formDic setObject:@"false" forKey:@"isCustomized"];
    [formDic setObject:@{@"id": @"",
                         @"sphRight": @"",
                         @"cylRight": @"",
                         @"sphLeft": @"",
                         @"cylLeft": @"",
                         @"lensColor": @"",
                         @"lensDiameter": @"",
                         @"lensThickness": @"",
                         @"film": @"",
                         @"adds": @"",
                         @"passageway": @"",
                         @"glassPrism": @"",
                         @"linearEccentricity": @"",
                         @"baseBending": @"",
                         @"remark": @""} forKey:@"customizedParames"];
    [formDic setObject:@"FOR_SALES" forKey:@"type"];
    [formDic setObject:@"SALES" forKey:@"salesType"];
    
    [parameters setObject:formDic forKey:@"form"];
    [parameters setObject:[IPCPayOrderManager sharedManager].isValiateMember ? @"true" : @"false" forKey:@"isCheckMember"];
    [parameters setObject:currentStatus forKey:@"currentlyStatus"];
    [parameters setObject:endStatus forKey:@"toStatus"];
    if ([IPCPayOrderManager sharedManager].isPayCash) {
        [parameters setObject:[self payTypeInfos] forKey:@"orderPayInfos"];
    }
    [parameters setObject:@"FOR_SALES" forKey:@"type"];
    [parameters setObject:@"SALES" forKey:@"salesType"];
    
    return parameters;
}

- (NSArray *)payTypeInfos
{
    __block NSMutableArray * array = [[NSMutableArray alloc]init];
    [[IPCPayOrderManager sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(obj.payPrice) forKey:@"payAmount"];
        [dic setObject:obj.payOrderType.payType forKey:@"payType"];
        [dic setObject:obj.payOrderType.payTypeId forKey:@"payTypeConfigId"];

        [array addObject:dic];
    }];
//    if ([IPCPayOrderManager sharedManager].coupon) {
//        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//         [dic setObject:[IPCPayOrderManager sharedManager].couponPayType.payType forKey:@"payType"];
//         [dic setObject:[IPCPayOrderManager sharedManager].couponPayType.payTypeId forKey:@"payTypeConfigId"];
//        [dic setObject:@([IPCPayOrderManager sharedManager].couponAmount) forKey:@"payAmount"];
//        [dic setObject:[IPCPayOrderManager sharedManager].coupon.couponId forKey:@"cashCouponId"];
//        [array addObject:dic];
//    }
    if ([IPCPayOrderManager sharedManager].pointRecord) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[IPCPayOrderManager sharedManager].pointPayType.payType forKey:@"payType"];
        [dic setObject:[IPCPayOrderManager sharedManager].pointPayType.payTypeId forKey:@"payTypeConfigId"];
        [dic setObject:@([IPCPayOrderManager sharedManager].pointRecord.pointPrice) forKey:@"payAmount"];
        [dic setObject:@([IPCPayOrderManager sharedManager].pointRecord.integral) forKey:@"integral"];
        [array addObject:dic];
    }
    return array;
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
