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

@property (nonatomic, strong) NSMutableArray<IPCCustomerAddressMode *> * list;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerAddressMode : NSObject

@property (nonatomic, copy) NSString * addressID;
@property (nonatomic, copy) NSString * contactName;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * detailAddress;

@end