//
//  CurrentCustomerOpometry.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCurrentCustomerOpometry.h"

@implementation IPCCurrentCustomerOpometry

+ (IPCCurrentCustomerOpometry *)sharedManager
{
    static dispatch_once_t token;
    static IPCCurrentCustomerOpometry *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}


//- (void)insertNewCustomer
//{
//    self.currentCustomer = [[IPCDetailCustomer alloc]init];
//    self.currentOpometry = [[IPCOptometryMode alloc]init];
//    self.currentAddress = [[IPCCustomerAddressMode alloc]init];
//    
//    self.currentCustomer.customerName = [IPCInsertCustomer instance].customerName;
//    self.currentCustomer.birthday = [IPCInsertCustomer instance].birthday;
//    self.currentCustomer.email = [IPCInsertCustomer instance].email;
//    self.currentCustomer.contactorGengerString = [IPCInsertCustomer instance].gender;
//    self.currentCustomer.customerPhone = [IPCInsertCustomer instance].customerPhone;
//    self.currentCustomer.customerType = [IPCInsertCustomer instance].customerType;
//    self.currentCustomer.customerTypeId = [IPCInsertCustomer instance].customerTypeId;
//    self.currentCustomer.memberId = [IPCInsertCustomer instance].memberNum;
//    self.currentCustomer.empName = [IPCInsertCustomer instance].empName;
//    self.currentCustomer.employeeId = [IPCInsertCustomer instance].empNameId;
//    self.currentCustomer.memberLevel = [IPCInsertCustomer instance].memberLevel;
//    self.currentCustomer.memberLevelId = [IPCInsertCustomer instance].memberLevelId;
//    self.currentCustomer.remark = [IPCInsertCustomer instance].remark;
//    self.currentCustomer.occupation = [IPCInsertCustomer instance].job;
//    self.currentCustomer.photoIdForPos = [IPCInsertCustomer instance].photo_udid;
//    self.currentCustomer.integral = 0;
//    
//    self.currentAddress.contactName = [IPCInsertCustomer instance].contactorName;
//    self.currentAddress.phone = [IPCInsertCustomer instance].contactorPhone;
//    self.currentAddress.gender = [IPCInsertCustomer instance].gender;
//    self.currentAddress.genderString = [IPCInsertCustomer instance].genderString;
//    self.currentAddress.detailAddress = [IPCInsertCustomer instance].contactorAddress;
//    
//    self.currentOpometry = [IPCInsertCustomer instance].optometryArray[0];
//}

- (void)clearData{
    [IPCCurrentCustomerOpometry sharedManager].currentAddress  = nil;
    [IPCCurrentCustomerOpometry sharedManager].currentCustomer = nil;
    [IPCCurrentCustomerOpometry sharedManager].currentOpometry = nil;
}

- (BOOL)isEmptyAddress{
    if (!self.currentAddress.contactName.length && !self.currentAddress.phone.length && !self.currentAddress.detailAddress.length)
        return YES;
    return NO;
}


- (BOOL)isEmptyOptometry{
    if (!self.currentOpometry.purpose.length && !self.currentOpometry.employeeName.length)
        return YES;
    return NO;
}



@end
