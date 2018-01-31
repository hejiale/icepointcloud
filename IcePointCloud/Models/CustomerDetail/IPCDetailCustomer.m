//
//  DetailCustomerObject.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCDetailCustomer.h"

@implementation IPCDetailCustomer

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"customerID": @"id",
             @"customerType":@"customerType.customerType"
             };
}

- (double)useDiscount
{
    if (self.mainMemberLevel) {
        if (self.mainMemberLevel.discount > 0) {
            return self.mainMemberLevel.discount*10;
        }else{
            return 100;
        }
    }
    if (self.memberLevel) {
        if (self.memberLevel.discount > 0) {
            return self.memberLevel.discount*10;
        }else{
            return 100;
        }
    }
    return 100;
}


- (double)useBalance
{
    if (self.mainMemberLevel) {
        return self.mainMemberLevel.balance;
    }
    if (self.balance) {
        return self.balance;
    }
    return 0;
}

- (double)userIntegral
{
    if (self.mainMemberLevel) {
        return self.mainMemberLevel.customerIntegral;
    }
    if (self.memberLevel) {
        return self.integral;
    }
    return 0;
}

- (NSString *)useMemberLevel
{
    if (self.mainMemberLevel) {
        return self.mainMemberLevel.memberLevel;
    }
    if (self.memberLevel) {
        return self.memberLevel.memberLevel;
    }
    return @"";
}

- (NSString *)useMemberPhone
{
    if (self.mainMemberLevel) {
        return self.mainMemberLevel.memberPhone;
    }
    return self.memberPhone;
}

- (NSString *)useMemberGrowth
{
    if (self.mainMemberLevel) {
        return self.mainMemberLevel.membergrowth;
    }
    return self.membergrowth;
}



@end
