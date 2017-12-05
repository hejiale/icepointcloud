//
//  IPCEmployee.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmployee.h"

@interface IPCEmployeeList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCEmployee *> * employeArray;

- (instancetype)initWithResponseObject:(id)responseObject;

@end

