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

@property (nonatomic, copy, readwrite) NSString * companyName;//公司名
@property (nonatomic, copy, readwrite) NSString *phone;//公司电话
@property (nonatomic, copy, readwrite) NSString *employeeId;//经办人id
@property (nonatomic, copy, readwrite) NSString *storeName;//所属店铺名
@property (nonatomic, copy, readwrite) NSString *storeId;//所属店铺名
@property (nonatomic, copy, readwrite) NSString *contacterPhone;//经办人电话
@property (nonatomic, copy, readwrite) NSString *storePhone;//店铺电话
@property (nonatomic, copy, readwrite) NSString *wareHouseId;//仓库id
@property (nonatomic, copy, readonly) NSString *wareHouseName;//仓库名
@property (nonatomic, copy, readwrite) NSString *companyId;//公司id
@property (nonatomic, copy, readwrite) NSString *employeeName;//经办联系人
@property (nonatomic, copy, readwrite) NSString *sex;//经办人性别
@property (nonatomic, strong, readwrite) IPCEmployee * employee;

@end
