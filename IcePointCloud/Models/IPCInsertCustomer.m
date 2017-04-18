//
//  IPCInsertCustomer.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCInsertCustomer.h"

@implementation IPCInsertCustomer

+ (IPCInsertCustomer *)instance
{
    static IPCInsertCustomer *mgr = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        mgr = [[self alloc] init];
    });
    return mgr;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        [self resetData];
    }
    return self;
}

- (void)resetData
{
    self.customerName = @"";
    self.genderString = @"";
    self.gender = @"MALE";
    self.contactorGenger = @"MALE";
    self.customerPhone = @"";
    self.empName= @"";
    self.empNameId = @"";
    self.memberNum= @"";
    self.memberLevel= @"";
    self.memberLevelId = @"";
    self.customerType= @"";
    self.customerTypeId = @"";
    self.job= @"";
    self.birthday= @"";
    self.email= @"";
    self.remark= @"";
    self.contactorName= @"";
    self.contactorAddress= @"";
    self.contactorPhone= @"";
    self.contactorGenger = @"MALE";
    self.contactorGengerString= @"";
    self.photo_udid = @"1";
    
    [self.optometryArray removeAllObjects];
    IPCOptometryMode * optometry = [[IPCOptometryMode alloc]init];
    [self.optometryArray addObject:optometry];
}

- (NSMutableArray<IPCOptometryMode *> *)optometryArray{
    if (!_optometryArray) {
        _optometryArray = [[NSMutableArray alloc]init];
    }
    return _optometryArray;
}

- (BOOL)isCustomerInfoEmpty{
    if (!self.customerName.length || !self.genderString.length || !self.customerPhone.length || !self.empName.length || !self.memberLevel.length || !self.memberNum.length) {
        [IPCCustomUI showError:@"客户信息必填项请填写完整!"];
        return YES;
    }
    if (!self.contactorName.length || !self.contactorGenger.length || !self.contactorPhone.length || !self.contactorAddress.length) {
        [IPCCustomUI showError:@"收货地址信息必填项请填写完整!"];
        return YES;
    }
    return NO;
}


- (BOOL)isEmptyOptometry{
    __block BOOL isEmptyOptometry = NO;
    [self.optometryArray enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.purpose.length || !obj.employeeName.length) {
            isEmptyOptometry = YES;
            [IPCCustomUI showError:@"请填写完整验光单信息!"];
        }
    }];
    return isEmptyOptometry;
}

@end
