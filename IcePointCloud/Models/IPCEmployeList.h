//
//  IPCEmploye.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmploye.h"

@interface IPCEmployeList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCEmploye *> * employeArray;

- (instancetype)initWithResponseObject:(id)responseObject;

@end
