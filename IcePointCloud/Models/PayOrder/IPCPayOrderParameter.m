//
//  IPCPayOrderParameter.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderParameter.h"

@implementation IPCPayOrderParameter


- (NSDictionary *)prototyOrderParameter
{
    //员工份额
    __block NSMutableArray * employeeList = [[NSMutableArray alloc]init];
    NSMutableDictionary * employeeResultDic = [[NSMutableDictionary alloc]init];
    [employeeResultDic setObject:@(100) forKey:@"achievement"];
    [employeeResultDic setObject:[IPCPayOrderManager sharedManager].employee.jobID forKey:@"employeeId"];
    [employeeResultDic setObject:[IPCPayOrderManager sharedManager].employee.name forKey:@"name"];
    [employeeResultDic setObject:[IPCPayOrderManager sharedManager].employee.jobNumber ? : @"" forKey:@"jobNumber"];
    [employeeList addObject:employeeResultDic];
    
    __block NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    if ([IPCCurrentCustomer sharedManager].currentCustomer) {
        [parameters setObject:[IPCCurrentCustomer sharedManager].currentCustomer.customerID forKey:@"customerId"];
    }
    if ([IPCCurrentCustomer sharedManager].currentOpometry) {
        [parameters setObject:[IPCCurrentCustomer sharedManager].currentOpometry.optometryID forKey:@"optometryId"];
    }

    [parameters setObject:@"FOR_SALES" forKey:@"orderType"];
    [parameters setObject:[self productListParamter] forKey:@"detailList"];

    if (employeeList.count) {
        [parameters setObject:employeeList forKey:@"employeeAchievements"];
    }
    
    [parameters setObject:[NSString stringWithFormat:@"%f",[[IPCShoppingCart sharedCart] allGlassesTotalPrePrice]] forKey:@"suggestPriceTotal"];
    [parameters setObject:[NSString stringWithFormat:@"%f",[IPCPayOrderManager sharedManager].payAmount] forKey:@"orderFinalPrice"];
    [parameters setObject:[NSString stringWithFormat:@"%f",[IPCPayOrderManager sharedManager].discountAmount] forKey:@"donationAmount"];
    
    [parameters setObject:[IPCPayOrderManager sharedManager].remark ? : @"" forKey:@"orderRemark"];
    [parameters setObject:[IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @"" forKey:@"repository"];
    
    return parameters;
}

- (NSArray *)payTypeInfos
{
    __block NSMutableArray * array = [[NSMutableArray alloc]init];
    [[IPCPayOrderManager sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        if ([obj.payTypeInfo isEqualToString:@"积分"]) {
            [dic setObject:@(obj.pointPrice) forKey:@"payAmount"];
        }else{
            [dic setObject:@(obj.payPrice) forKey:@"payAmount"];
        }
        [dic setObject:obj.payTypeInfo forKey:@"payType"];
        [array addObject:dic];
    }];
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
