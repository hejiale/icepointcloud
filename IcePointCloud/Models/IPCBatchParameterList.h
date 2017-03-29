//
//  BatchParameterList.h
//  IcePointCloud
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BatchParameterObject;

@interface IPCBatchParameterList : NSObject

@property (nonatomic, strong) NSMutableArray<BatchParameterObject *> * parameterList;

- (instancetype)initWithResponseObject:(id)responseObject;

@end

@interface BatchParameterObject : NSObject

@property (copy, nonatomic, readonly)   NSString  * batchID;
@property (copy, nonatomic, readonly)   NSString  * sph;
@property (copy, nonatomic, readonly)   NSString  * cyl;
@property (copy, nonatomic, readonly)   NSString  * degree;
@property (assign, nonatomic, readonly) NSInteger   bizStock;

@end
