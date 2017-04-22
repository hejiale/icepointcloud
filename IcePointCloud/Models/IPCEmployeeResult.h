//
//  IPCEmployeeResult.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCEmployeeResult : NSObject

@property (nonatomic, strong, readwrite) IPCEmploye * employe;
@property (nonatomic, assign, readwrite) double      employeeResult;//员工份额


@end
