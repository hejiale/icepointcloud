//
//  IPCInsertCustomerViewModel.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCInsertCustomerViewModel.h"

@implementation IPCInsertCustomerViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化
        [[IPCInsertCustomer instance] resetData];
        [IPCInsertCustomer instance].isInsertStatus = YES;
        //Query Employee & MemberLevel & CustomerType
        [[IPCEmployeeeManager sharedManager] queryEmployee];
        [[IPCEmployeeeManager sharedManager] queryMemberLevel];
        [[IPCEmployeeeManager sharedManager] queryCustomerType];
    }
    return self;
}

- (void)saveNewCustomer:(void(^)(NSString *customerId))complete
{
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
    
    __block NSMutableArray * optometryList = [[NSMutableArray alloc]init];
    [[IPCInsertCustomer instance].optometryArray enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSMutableDictionary * optometryDic = [[NSMutableDictionary alloc]init];
        [optometryDic setDictionary:@{
                                      @"distanceRight": obj.distanceRight,
                                      @"distanceLeft":obj.distanceLeft,
                                      @"sphLeft": (obj.sphLeft ?  : @""),
                                      @"sphRight":(obj.sphRight ?  : @""),
                                      @"cylLeft": (obj.cylLeft ?  : @""),
                                      @"cylRight":(obj.cylRight ?  : @""),
                                      @"axisLeft":obj.axisLeft,
                                      @"axisRight":obj.axisRight,
                                      @"addLeft":obj.addLeft,
                                      @"addRight":obj.addRight,
                                      @"correctedVisionLeft":obj.correctedVisionLeft,
                                      @"correctedVisionRight":obj.correctedVisionRight}];
        if (obj.purpose.length) {
            [optometryDic setObject:obj.purpose forKey:@"purpose"];
        }
        if (obj.employeeName.length) {
            [optometryDic setObject:obj.employeeId forKey:@"employeeId"];
            [optometryDic setObject:obj.employeeName forKey:@"employeeName"];
        }
        [optometryList addObject:optometryDic];
    }];
    
    [IPCCustomerRequestManager saveCustomerInfoWithCustomName:[IPCInsertCustomer instance].customerName
                                                  CustomPhone:[IPCInsertCustomer instance].customerPhone
                                                       Gender:[IPCInsertCustomer instance].gender
                                                        Email:[IPCInsertCustomer instance].email
                                                     Birthday:[IPCInsertCustomer instance].birthday
                                                       Remark:[IPCInsertCustomer instance].remark
                                                OptometryList:optometryList
                                                  ContactName:[IPCInsertCustomer instance].contactorName
                                                ContactGender:[IPCInsertCustomer instance].contactorGenger
                                                 ContactPhone:[IPCInsertCustomer instance].contactorPhone
                                               ContactAddress:[IPCInsertCustomer instance].contactorAddress
                                                 EmployeeName:[IPCInsertCustomer instance].empName
                                                   EmployeeId:[IPCInsertCustomer instance].empNameId
                                                 CustomerType:[IPCInsertCustomer instance].customerType
                                               CustomerTypeId:[IPCInsertCustomer instance].customerTypeId
                                                   Occupation:[IPCInsertCustomer instance].job
                                                  MemberLevel:[IPCInsertCustomer instance].memberLevel
                                                MemberLevelId:[IPCInsertCustomer instance].memberLevelId
                                                    MemberNum:[IPCInsertCustomer instance].memberNum
                                                      PhotoId:[IPCInsertCustomer instance].photo_udid
                                                 IntroducerId:[IPCInsertCustomer instance].introducerId
                                            IntroducerInteger: [IPCInsertCustomer instance].introducerInteger
                                                 SuccessBlock:^(id responseValue)
     {
         [[IPCInsertCustomer instance] resetData];
         if (complete) {
             complete(responseValue);
         }
     } FailureBlock:^(NSError *error) {
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:@"保存客户信息失败!"];
         }
         
         if (complete) {
             complete(nil);
         }
     }];
}


- (void)judgeCustomerPhone:(NSString *)phone
{
    [IPCCustomerRequestManager judgePhoneIsExistWithPhone:phone
                                             SuccessBlock:^(id responseValue)
     {
         if ([responseValue boolValue]) {
             [IPCCommonUI showError:@"该手机号已注册过了"];
         }else{
             [IPCCommonUI hiden];
         }
     } FailureBlock:^(NSError *error) {
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:@"验证手机号失败!"];
         }
     }];
}


- (void)judgeCustomerName:(NSString *)name
{
    [IPCCustomerRequestManager judgeCustomerNameIsExistWithName:name
                                                   SuccessBlock:^(id responseValue)
     {
         if ([responseValue boolValue]) {
             [IPCCommonUI showError:@"该客户名已注册过了"];
         }else{
             [IPCCommonUI hiden];
         }
     } FailureBlock:^(NSError *error) {
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:@"验证客户名失败!"];
         }
     }];
}


@end
