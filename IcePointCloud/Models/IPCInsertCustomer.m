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
    self.memberNum= @"";
    self.memberLevel= @"";
    self.customerType= @"";
    self.job= @"";
    self.birthday= @"";
    self.email= @"";
    self.remark= @"";
    self.contactorName= @"";
    self.contactorAddress= @"";
    self.contactorPhone= @"";
    self.contactorGengerString= @"";
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

@end
