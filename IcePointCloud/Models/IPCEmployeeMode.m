//
//  IPCEmployeeMode.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCEmployeeMode.h"

@implementation IPCEmployeeMode


+ (IPCEmployeeMode *)sharedManager
{
    static IPCEmployeeMode *mgr = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        mgr = [[IPCEmployeeMode alloc] init];
    });
    return mgr;
}


- (NSArray *)employeeNameArray
{
    NSMutableArray * employeeNameArray = [[NSMutableArray alloc]init];
    
    [self.employeList.employeArray enumerateObjectsUsingBlock:^(IPCEmploye * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [employeeNameArray addObject:obj.name];
    }];
    return employeeNameArray;
}

- (NSArray *)customerTypeNameArray{
    NSMutableArray * customerTypeNameArray = [[NSMutableArray alloc]init];
    
    [self.customerTypeList.list enumerateObjectsUsingBlock:^(IPCCustomerType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [customerTypeNameArray addObject:obj.customerType];
    }];
    return customerTypeNameArray;
}

- (NSArray *)memberLevelNameArray{
    NSMutableArray * memberLevelNameArray = [[NSMutableArray alloc]init];
    
    [self.memberLevelList.list enumerateObjectsUsingBlock:^(IPCMemberLevel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [memberLevelNameArray addObject:obj.memberLevel];
    }];
    return memberLevelNameArray;
}

- (NSString *)employeeId:(NSString *)employee{
    __block NSString * employeeId = nil;
    [[IPCEmployeeMode sharedManager].employeList.employeArray enumerateObjectsUsingBlock:^(IPCEmploye * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:employee]) {
            employeeId = obj.jobID;
        }
    }];
    return employeeId;
}

- (NSString *)customerTypeId:(NSString *)customerType{
    __block NSString * customerTypeId = nil;
    [[IPCEmployeeMode sharedManager].customerTypeList.list enumerateObjectsUsingBlock:^(IPCCustomerType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.customerType isEqualToString:customerType]) {
            customerTypeId = obj.customerTypeId;
        }
    }];
    return customerTypeId;
}

- (NSString *)memberLevelId:(NSString *)memberLevel{
    __block NSString * memberLevelId = nil;
    [[IPCEmployeeMode sharedManager].memberLevelList.list enumerateObjectsUsingBlock:^(IPCMemberLevel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.memberLevel isEqualToString:memberLevel]) {
            memberLevelId = obj.memberLevelId;
        }
    }];
    return memberLevelId;
}


#pragma mark //Request Data
- (void)queryEmploye:(NSString *)keyWord
{
    [IPCPayOrderRequestManager queryEmployeWithKeyword:keyWord SuccessBlock:^(id responseValue){
         self.employeList = [[IPCEmployeList alloc] initWithResponseObject:responseValue];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

- (void)queryMemberLevel
{
    [IPCCustomerRequestManager getMemberLevelWithSuccessBlock:^(id responseValue) {
        self.memberLevelList = [[IPCMemberLevelList alloc]initWithResponseValue:responseValue];
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
    }];
}

- (void)queryCustomerType
{
    [IPCCustomerRequestManager getCustomerTypeSuccessBlock:^(id responseValue) {
        self.customerTypeList = [[IPCCustomerTypeList alloc]initWithResponseValue:responseValue];
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
    }];
}

@end
