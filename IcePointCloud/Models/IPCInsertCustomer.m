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
        [mgr resetData];
    });
    return mgr;
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

#pragma mark //判断输入完整的地址或验光单数据
- (BOOL)isFullAddress{
    if (self.contactorName.length && self.contactorPhone.length && self.contactorAddress.length) {
        return YES;
    }
    if (!self.contactorName.length && !self.contactorPhone.length && !self.contactorAddress.length) {
        return YES;
    }
    return NO;
}


- (BOOL)isFullOptometry{
    __block BOOL isFull = NO;
   [self.optometryArray enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (obj.purpose.length  && obj.employeeName.length && obj.sphLeft.length && obj.sphRight.length && obj.cylLeft.length && obj.cylRight.length) {
           isFull = YES;
       }
   }];
    [self.optometryArray enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.purpose.length  && !obj.employeeName.length && !obj.sphLeft.length && !obj.sphRight.length && !obj.cylLeft.length && !obj.cylRight.length) {
            isFull = YES;
        }
    }];
    return isFull;
}


@end
