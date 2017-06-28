//
//  IPCEmployee.h
//  IcePointCloud
//
//  Created by mac on 2016/12/1.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCEmployee : NSObject

@property (nonatomic, copy, readonly) NSString *  jobNumber;
@property (nonatomic, copy, readonly) NSString *  name;
@property (nonatomic, assign,readonly) double  discount;
@property (nonatomic, copy, readonly) NSString * jobID;

@end
