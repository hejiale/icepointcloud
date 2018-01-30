//
//  IPCEmployeeeManager.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCCustomerTypeList.h"
#import "IPCMemberLevelList.h"
#import "IPCEmployeeList.h"
#import "IPCStoreList.h"

@interface IPCCustomerManager : NSObject

@property (nonatomic, strong) IPCEmployeeList          * employeList;
@property (nonatomic, strong) IPCCustomerTypeList  * customerTypeList;
@property (nonatomic, strong) IPCMemberLevelList    * memberLevelList;
@property (nonatomic, strong) IPCStoreList                * storeList;


+ (IPCCustomerManager *)sharedManager;

///查询员工
- (void)queryEmployee;
///根据关键词查询员工
- (void)queryEmploye:(NSString *)keyWord;
///查询会员等级
- (void)queryMemberLevel;
///查询客户类型
- (void)queryCustomerType;
///查询门店
- (void)queryStore;
///所有员工名字
- (NSArray *)employeeNameArray;
///所有客户类型名称
- (NSArray *)customerTypeNameArray;
///所有会员等级名称
- (NSArray *)memberLevelNameArray;
///所有门店名称
- (NSArray *)storeNameArray;
///查询相应会员等级Id
- (NSString *)memberLevelId:(NSString *)memberLevel;
///查询客户类型Id
- (NSString *)customerTypeId:(NSString *)customerType;
///查询员工Id
- (NSString *)employeeId:(NSString *)employee;
///查询店铺id
- (NSString *)storeId:(NSString *)storeName;



@end
