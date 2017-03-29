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

@property (nonatomic, copy, readonly) NSString * addressID;
@property (nonatomic, copy, readonly) NSString * contactName;
@property (nonatomic, copy, readonly) NSString * phone;
@property (nonatomic, copy, readonly) NSString * gender;
@property (nonatomic, copy, readonly) NSString * detailAddress;

@end
