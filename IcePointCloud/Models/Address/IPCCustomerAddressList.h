//
//  CustomerAddressListObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomerAddressMode;
@interface IPCCustomerAddressList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomerAddressMode *> * list;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerAddressMode : NSObject

@property (nonatomic, copy, readwrite) NSString *  contactorName;
@property (nonatomic, copy, readwrite) NSString *  contactorPhone;
@property (nonatomic, copy, readwrite) NSString * addressID;
@property (nonatomic, copy, readwrite) NSString * gender;
@property (nonatomic, copy, readwrite) NSString * genderString;
@property (nonatomic, copy, readwrite) NSString * detailAddress;
@property (nonatomic, copy, readwrite) NSString *  contactorAddress;
@property (nonatomic, copy, readwrite) NSString *  contactorGender;

- (BOOL)isEmptyAddress;

@end
