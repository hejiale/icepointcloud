//
//  BatchParameterList.m
//  IcePointCloud
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCBatchParameterList.h"

@implementation IPCBatchParameterList

- (instancetype)initWithResponseObject:(id)responseObject{
    self = [super init];
    if (self) {
        [self.parameterList removeAllObjects];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BatchParameterObject * parameter = [BatchParameterObject mj_objectWithKeyValues:obj];
                if (parameter.bizStock > 0) {
                    [self.parameterList addObject:parameter];
                }
            }];
            
            [self.parameterList sortUsingComparator:^NSComparisonResult(BatchParameterObject *  _Nonnull obj1, BatchParameterObject *  _Nonnull obj2) {
                return [obj1.degree doubleValue] < [obj2.degree doubleValue];
            }];
        }
    }
    return self;
}

- (NSMutableArray<BatchParameterObject *> *)parameterList{
    if (!_parameterList) {
        _parameterList = [[NSMutableArray alloc]init];
    }
    return _parameterList;
}

@end

@implementation BatchParameterObject

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"batchID"    : @"id"};
}



@end
