//
//  IPCEmployee.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCEmployee;
@interface IPCEmployeeList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCEmployee *> * employeArray;

- (instancetype)initWithResponseObject:(id)responseObject;

@end

@interface IPCEmployee : NSObject

@property (nonatomic, copy, readonly) NSString *  jobNumber;
@property (nonatomic, copy, readonly) NSString *  name;
@property (nonatomic, assign,readonly) double  discount;
@property (nonatomic, copy, readonly) NSString * jobID;

@end
