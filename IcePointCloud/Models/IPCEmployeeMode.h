//
//  IPCEmployeeMode.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCCustomerTypeList.h"
#import "IPCMemberLevelList.h"

@interface IPCEmployeeMode : NSObject

@property (nonatomic, strong) IPCEmployeList * employeList;
@property (nonatomic, strong) IPCCustomerTypeList * customerTypeList;
@property (nonatomic, strong) IPCMemberLevelList * memberLevelList;


+ (IPCEmployeeMode *)sharedManager;

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
