//
//  IPCRequest.h
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCRequestParameter : NSObject

/**
 *  REQUEST METHODS
 */
@property (copy, nonatomic,) NSString * requestMethod;
/**
 *  REQUEST PARAMETERS
 */
@property (copy, nonatomic)  NSString * parameters;
/**
 *  REQUEST ADD PARAMETERS
 */
@property (nonatomic, strong) NSDictionary * requestParameter;

/**
 *
 *  @param requestMethod
 *  @param parameter
 *
 *  @return 
 */
- (instancetype)initWithRequestMethod:(NSString *)requestMethod Parameter:(id)parameter;

@end
