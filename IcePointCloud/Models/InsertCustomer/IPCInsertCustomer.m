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

- (void)resetData
{
    self.customerName = @"";
    self.genderString = @"";
    self.gender = @"MALE";
    self.contactorGenger = @"MALE";
    self.customerPhone = @"";
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
    self.contactorGengerString= @"";
    self.photo_udid = @"1";
    self.introducerId = @"";
    self.introducerName = @"";
    self.introducerInteger = @"";
    self.isInsertStatus = NO;
    self.isPackUp = NO;
    [self.optometryArray removeAllObjects];
    self.optometryArray = nil;
}

- (NSMutableArray<IPCOptometryMode *> *)optometryArray{
    if (!_optometryArray) {
        _optometryArray = [[NSMutableArray alloc]init];
    }
    return _optometryArray;
}


@end
