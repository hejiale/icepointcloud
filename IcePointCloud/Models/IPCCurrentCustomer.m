//
//  CurrentCustomerOpometry.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCurrentCustomer.h"

@implementation IPCCurrentCustomer

+ (IPCCurrentCustomer *)sharedManager
{
    static dispatch_once_t token;
    static IPCCurrentCustomer *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}


/**
 下单时 新建用户
 */
- (void)insertNewCustomer
{
    [[IPCCurrentCustomer sharedManager] clearData];
    
    self.currentCustomer = [[IPCDetailCustomer alloc]init];

    self.currentCustomer.customerName = [IPCInsertCustomer instance].customerName;
    self.currentCustomer.birthday = [IPCInsertCustomer instance].birthday;
    self.currentCustomer.email = [IPCInsertCustomer instance].email;
    self.currentCustomer.contactorGengerString = [IPCInsertCustomer instance].gender;
    self.currentCustomer.customerPhone = [IPCInsertCustomer instance].customerPhone;
    self.currentCustomer.memberId = [IPCInsertCustomer instance].memberNum;
    self.currentCustomer.empName = [IPCInsertCustomer instance].empName;
    self.currentCustomer.employeeId = [IPCInsertCustomer instance].empNameId;
    self.currentCustomer.remark = [IPCInsertCustomer instance].remark;
    self.currentCustomer.occupation = [IPCInsertCustomer instance].job;
    self.currentCustomer.integral = 0;
    self.currentCustomer.introducerName = [IPCInsertCustomer instance].introducerName;
    
    if (![IPCInsertCustomer instance].memberLevel.length) {
        IPCMemberLevel * memberLevelMode = [IPCEmployeeeManager sharedManager].memberLevelList.list[0];
        [IPCInsertCustomer instance].memberLevel = memberLevelMode.memberLevel;
        [IPCInsertCustomer instance].memberLevelId = memberLevelMode.memberLevelId;
    }
    if (![IPCInsertCustomer instance].customerType.length) {
        __block IPCCustomerType * customerType = [IPCEmployeeeManager sharedManager].customerTypeList.list[0];
        [IPCInsertCustomer instance].customerType = @"自然进店";
        [[IPCEmployeeeManager sharedManager].customerTypeList.list enumerateObjectsUsingBlock:^(IPCCustomerType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.customerType isEqualToString:@"自然进店"]) {
                [IPCInsertCustomer instance].customerTypeId = obj.customerTypeId;
            }
        }];
    }
    
    self.currentCustomer.memberLevel = [IPCInsertCustomer instance].memberLevel;
    self.currentCustomer.memberLevelId = [IPCInsertCustomer instance].memberLevelId;
    self.currentCustomer.customerType = [IPCInsertCustomer instance].customerType;
    self.currentCustomer.customerTypeId = [IPCInsertCustomer instance].customerTypeId;
    
    if ([IPCInsertCustomer instance].contactorAddress.length) {
        self.currentAddress = [[IPCCustomerAddressMode alloc]init];
        self.currentAddress.contactorName = [IPCInsertCustomer instance].contactorName;
        self.currentAddress.contactorPhone = [IPCInsertCustomer instance].contactorPhone;
        self.currentAddress.gender = [IPCInsertCustomer instance].gender;
        self.currentAddress.genderString = [IPCInsertCustomer instance].genderString;
        self.currentAddress.detailAddress = [IPCInsertCustomer instance].contactorAddress;
    }
    
   IPCOptometryMode * optometry = [IPCInsertCustomer instance].optometryArray[0];
    if (optometry.purpose.length && optometry.employeeName.length) {
        self.currentOpometry = [[IPCOptometryMode alloc]init];
        self.currentOpometry = optometry;
    }
}

- (void)clearData{
    [IPCCurrentCustomer sharedManager].currentAddress  = nil;
    [IPCCurrentCustomer sharedManager].currentCustomer = nil;
    [IPCCurrentCustomer sharedManager].currentOpometry = nil;
}


@end
