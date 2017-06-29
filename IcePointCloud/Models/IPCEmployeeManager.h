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

@interface IPCEmployeeeManager : NSObject

@property (nonatomic, strong) IPCEmployeeList * employeList;
@property (nonatomic, strong) IPCCustomerTypeList * customerTypeList;
@property (nonatomic, strong) IPCMemberLevelList * memberLevelList;


+ (IPCEmployeeeManager *)sharedManager;

- (void)queryEmploye:(NSString *)keyWord;
- (void)queryMemberLevel;
- (void)queryCustomerType;

- (NSArray *)employeeNameArray;
- (NSArray *)customerTypeNameArray;
- (NSArray *)memberLevelNameArray;

- (NSString *)memberLevelId:(NSString *)memberLevel;
- (NSString *)customerTypeId:(NSString *)customerType;
- (NSString *)employeeId:(NSString *)employee;



@end
