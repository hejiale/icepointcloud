//
//  IPCEmployeeeManager.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomerManager.h"

@implementation IPCCustomerManager


+ (IPCCustomerManager *)sharedManager
{
    static IPCCustomerManager *mgr = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        mgr = [[IPCCustomerManager alloc] init];
    });
    return mgr;
}

- (NSArray *)employeeNameArray
{
    NSMutableArray * employeeNameArray = [[NSMutableArray alloc]init];
    
    [self.employeList.employeArray enumerateObjectsUsingBlock:^(IPCEmployee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (NSArray *)storeNameArray{
    NSMutableArray * storeNameArray = [[NSMutableArray alloc]init];
    
    [self.storeList.storeArray enumerateObjectsUsingBlock:^(IPCStore * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [storeNameArray addObject:obj.storeName];
    }];
    [storeNameArray insertObject:@"无门店" atIndex:0];
    return storeNameArray;
}

- (NSArray *)memberLevelNameArray{
    NSMutableArray * memberLevelNameArray = [[NSMutableArray alloc]init];
    
    [self.memberLevelList.list enumerateObjectsUsingBlock:^(IPCMemberLevel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [memberLevelNameArray addObject:obj.memberLevel];
    }];
    return memberLevelNameArray;
}

- (NSString *)employeeId:(NSString *)employee{
    __block NSString * employeeId = @"";
    [[IPCCustomerManager sharedManager].employeList.employeArray enumerateObjectsUsingBlock:^(IPCEmployee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:employee]) {
            employeeId = obj.jobID;
        }
    }];
    return employeeId;
}

- (NSString *)customerTypeId:(NSString *)customerType{
    __block NSString * customerTypeId = @"";
    [[IPCCustomerManager sharedManager].customerTypeList.list enumerateObjectsUsingBlock:^(IPCCustomerType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.customerType isEqualToString:customerType]) {
            customerTypeId = obj.customerTypeId;
        }
    }];
    return customerTypeId;
}

- (NSString *)memberLevelId:(NSString *)memberLevel{
    __block NSString * memberLevelId = @"";
    [[IPCCustomerManager sharedManager].memberLevelList.list enumerateObjectsUsingBlock:^(IPCMemberLevel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.memberLevel isEqualToString:memberLevel]) {
            memberLevelId = obj.memberLevelId;
        }
    }];
    return memberLevelId;
}

- (NSString *)storeId:(NSString *)storeName{
    __block NSString * storeId = @"";
    [[IPCCustomerManager sharedManager].storeList.storeArray enumerateObjectsUsingBlock:^(IPCStore * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.storeName isEqualToString:storeName]) {
            storeId = obj.storeId;
        }
    }];
    return storeId;
}

#pragma mark //Request Data
- (void)queryEmployee
{
    [self queryEmploye:@""];
}

- (void)queryEmploye:(NSString *)keyWord
{
    [IPCPayOrderRequestManager queryEmployeWithKeyword:keyWord SuccessBlock:^(id responseValue){
        self.employeList = [[IPCEmployeeList alloc] initWithResponseObject:responseValue];
    } FailureBlock:^(NSError *error) {
        if ([error code] != NSURLErrorCancelled) {
            [IPCCommonUI showError:error.domain];
        }
    }];
}

- (void)queryMemberLevel
{
    [IPCCustomerRequestManager getMemberLevelWithSuccessBlock:^(id responseValue) {
        self.memberLevelList = [[IPCMemberLevelList alloc]initWithResponseValue:responseValue];
    } FailureBlock:^(NSError *error) {
        if ([error code] != NSURLErrorCancelled) {
            [IPCCommonUI showError:error.domain];
        }
    }];
}

- (void)queryCustomerType
{
    [IPCCustomerRequestManager getCustomerTypeSuccessBlock:^(id responseValue) {
        self.customerTypeList = [[IPCCustomerTypeList alloc]initWithResponseValue:responseValue];
    } FailureBlock:^(NSError *error) {
        if ([error code] != NSURLErrorCancelled) {
            [IPCCommonUI showError:error.domain];
        }
    }];
}

- (void)queryStore
{
    [IPCUserRequestManager queryAllStoreWithSuccessBlock:^(id responseValue)
     {
         self.storeList = [[IPCStoreList alloc]initWithResponseObject:responseValue];
     } FailureBlock:^(NSError *error) {
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:error.domain];
         }
     }];
}

@end
