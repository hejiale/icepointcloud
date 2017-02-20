//
//  CustomerAddressListObject.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerAddressList.h"

@implementation IPCCustomerAddressList

- (instancetype)initWithResponseValue:(id)responseValue{
    self = [super init];
    if (self) {
        if ([self.list count] > 0) {
            [self.list removeAllObjects];
        }
        
        if ([responseValue isKindOfClass:[NSArray class]]) {
            [responseValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCCustomerAddressMode * order = [IPCCustomerAddressMode mj_objectWithKeyValues:obj];
                [self.list addObject:order];
            }];
        }
    }
    return self;
}

- (NSMutableArray<IPCCustomerAddressMode *> *)list{
    if (!_list) {
        _list = [[NSMutableArray alloc]init];
    }
    return _list;
}

@end

@implementation IPCCustomerAddressMode

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"addressID"    :@"id",
             @"contactName"  :@"contactorName",
             @"phone"        :@"contactorPhone",
             @"gender"       :@"genderstring",
             @"detailAddress":@"detailAdress"};
}

@end
