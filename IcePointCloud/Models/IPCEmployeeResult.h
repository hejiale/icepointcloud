//
//  IPCEmployeeeResult.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmployeeList.h"

@interface IPCEmployeeResult : NSObject

@property (nonatomic, strong, readwrite) IPCEmployee * employee;
@property (nonatomic, assign, readwrite) double      achievement;//员工份额
@property (nonatomic, assign, readwrite) BOOL     isUpdateStatus;//判断是新建订单还是修改订单

@end
