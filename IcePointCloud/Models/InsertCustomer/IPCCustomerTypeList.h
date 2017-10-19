//
//  IPCCustomerTypeList.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomerType;
@interface IPCCustomerTypeList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomerType *> * list;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerType : NSObject

@property (nonatomic, copy, readonly) NSString * customerType;
@property (nonatomic, copy, readonly) NSString * customerTypeId;

@end
