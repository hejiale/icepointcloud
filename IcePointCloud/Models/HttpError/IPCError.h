//
//  IPCError.h
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCError : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, copy)   NSString *trace;
@property (nonatomic, strong)   id   data;

@end
