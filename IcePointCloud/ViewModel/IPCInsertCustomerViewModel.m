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
        [[IPCEmployeeeManager sharedManager] queryEmployee];
        [[IPCEmployeeeManager sharedManager] queryMemberLevel];
        [[IPCEmployeeeManager sharedManager] queryCustomerType];
        [[IPCInsertCustomer instance] resetData];
        [IPCInsertCustomer instance].isInsertStatus = YES;
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
         [IPCCommonUI hiden];
         [[IPCInsertCustomer instance] resetData];
         if (complete) {
             complete(responseValue);
         }
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:@"保存客户信息失败!"];
     }];
}


- (void)judgeCustomerPhone:(NSString *)phone :(void(^)())complete
{
    [IPCCustomerRequestManager judgePhoneIsExistWithPhone:phone
                                             SuccessBlock:^(id responseValue)
    {
        if (![responseValue boolValue]) {
            if (complete) {
                complete();
            }
        }else{
            [IPCCommonUI showError:@"该手机号已注册过了"];
        }
        
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:@"验证手机号失败!"];
    }];
}
@end
