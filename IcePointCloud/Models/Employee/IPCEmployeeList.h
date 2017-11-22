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

@property (nonatomic, copy, readwrite) NSString *  jobNumber;
@property (nonatomic, copy, readwrite) NSString *  name;
@property (nonatomic, assign,readwrite) double  discount;
@property (nonatomic, copy, readwrite) NSString * jobID;

@end
