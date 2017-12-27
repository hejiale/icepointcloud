//
//  IPCStoreResult.h
//  IcePointCloud
//
//  Created by gerry on 2017/10/25.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmployee.h"

@interface IPCStoreResult : NSObject

@property (nonatomic, copy, readwrite) NSString *phone;
@property (nonatomic, copy, readwrite) NSString *storeId;
@property (nonatomic, copy, readwrite) NSString *storeName;
@property (nonatomic, copy, readwrite) NSString *contactName;
@property (nonatomic, copy, readwrite) NSString *contacterPhone;
@property (nonatomic, copy, readwrite) NSString *storePhone;
@property (nonatomic, copy, readwrite) NSString *wareHouseId;
@property (nonatomic, copy, readonly) NSString *wareHouseName;
@property (nonatomic, copy, readwrite) NSString *companyId;
@property (nonatomic, copy, readwrite) NSString *companyName;
@property (nonatomic, copy, readwrite) NSString *sex;
@property (nonatomic, strong, readwrite) IPCEmployee * employee;

@end
