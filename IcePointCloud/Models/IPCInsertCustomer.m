//
//  IPCInsertCustomer.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCInsertCustomer.h"

@implementation IPCInsertCustomer


- (instancetype)init{
    self = [super init];
    if (self) {
        self.customerName = @"";
        self.genderString = @"";
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
    }
    return self;
}

- (NSMutableArray<IPCOptometryMode *> *)optometryArray{
    if (!_optometryArray) {
        _optometryArray = [[NSMutableArray alloc]init];
    }
    return _optometryArray;
}

@end
