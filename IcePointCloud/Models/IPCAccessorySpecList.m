//
//  IPCAccessorySpecList.m
//  IcePointCloud
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCAccessorySpecList.h"

@implementation IPCAccessorySpecList

- (instancetype)initWithResponseObject:(id)responseObject
{
    self = [super init];
    if (self) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            id accessoryInfo = [responseObject allObjects][0];
            if ([accessoryInfo isKindOfClass:[NSArray class]]) {
                [accessoryInfo enumerateObjectsUsingBlock:^(id  _Nonnull batchNumDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([batchNumDic isKindOfClass:[NSDictionary class]]) {
                        IPCAccessoryBatchNum * batchNumMode = [[IPCAccessoryBatchNum alloc]init];
                        batchNumMode.batchNumber = batchNumDic[@"batchNumber"];
                        
                        if ([batchNumDic[@"approvalNumberDetails"] isKindOfClass:[NSArray class]]) {
                            [batchNumDic[@"approvalNumberDetails"] enumerateObjectsUsingBlock:^(id  _Nonnull kindNumDic, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([kindNumDic isKindOfClass:[NSDictionary class]]) {
                                    IPCAccessoryKindNum * kindNumMode = [[IPCAccessoryKindNum alloc]init];
                                    kindNumMode.kindNum = kindNumDic[@"approvalNumber"];
                                    
                                    if ([kindNumDic[@"expireDateDetails"] isKindOfClass:[NSArray class]]) {
                                        [kindNumDic[@"expireDateDetails"] enumerateObjectsUsingBlock:^(id  _Nonnull dateDic, NSUInteger idx, BOOL * _Nonnull stop) {
                                            if ([dateDic isKindOfClass:[NSDictionary class]]) {
                                                IPCAccessoryExpireDate * dateMode = [IPCAccessoryExpireDate mj_objectWithKeyValues:dateDic];
                                                [kindNumMode.expireDateArray addObject:dateMode];
                                            }
                                        }];
                                    }
                                    [batchNumMode.kindNumArray addObject:kindNumMode];
                                }
                            }];
                        }
                        [self.parameterList addObject:batchNumMode];
                    }
                }];
            }
        }
    }
    return self;
}



- (NSMutableArray<IPCAccessoryBatchNum *> *)parameterList{
    if (!_parameterList)
        _parameterList = [[NSMutableArray alloc]init];
    return _parameterList;
}

@end

@implementation IPCAccessoryBatchNum

- (NSMutableArray<IPCAccessoryKindNum *> *)kindNumArray{
    if (!_kindNumArray)
        _kindNumArray = [[NSMutableArray alloc]init];
    return _kindNumArray;
}

@end

@implementation IPCAccessoryKindNum

- (NSMutableArray<IPCAccessoryExpireDate *> *)expireDateArray{
    if (!_expireDateArray)
        _expireDateArray = [[NSMutableArray alloc]init];
    return _expireDateArray;
}

@end


@implementation IPCAccessoryExpireDate

@end
