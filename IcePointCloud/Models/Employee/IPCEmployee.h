//
//  IPCEmployee.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCEmployee : NSObject

@property (nonatomic, copy, readwrite) NSString *  jobNumber;
@property (nonatomic, copy, readwrite) NSString *  name;
@property (nonatomic, assign,readwrite) double  discount;
@property (nonatomic, copy, readwrite) NSString * jobID;

@end
