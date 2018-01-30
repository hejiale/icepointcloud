//
//  IPCStoreList.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/30.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCStoreList.h"

@implementation IPCStoreList

- (instancetype)initWithResponseObject:(id)responseObject{
    self = [super init];
    if (self) {
        [self.storeArray removeAllObjects];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCStore * employe = [IPCStore mj_objectWithKeyValues:obj];
                [self.storeArray addObject:employe];
            }];
        }
    }
    return self;
}

- (NSMutableArray<IPCStore *> *)storeArray{
    if (!_storeArray)
        _storeArray = [[NSMutableArray alloc]init];
    return _storeArray;
}

@end
