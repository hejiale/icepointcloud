//
//  IPCGetGlassesListResult.h
//  IcePointCloud
//
//  Created by mac on 8/2/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IPCGlasses.h"

@interface IPCGetGlassesListResult : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *> *glassesList;

- (instancetype)initWithResponseValue:(id)responseValue;

@end


