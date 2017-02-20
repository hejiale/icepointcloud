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

@property (copy, nonatomic)   NSString  * batchID;
@property (copy, nonatomic)   NSString  * sph;
@property (copy, nonatomic)   NSString  * cyl;
@property (copy, nonatomic)   NSString  * degree;
@property (assign, nonatomic) NSInteger   bizStock;

@end
