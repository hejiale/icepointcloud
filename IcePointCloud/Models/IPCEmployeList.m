//
//  IPCEmploye.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEmployeList.h"

@implementation IPCEmployeList

- (instancetype)initWithResponseObject:(id)responseObject{
    self = [super init];
    if (self) {
        [self.employeArray removeAllObjects];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"resultList"] isKindOfClass:[NSArray class]]) {
                [responseObject[@"resultList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IPCEmploye * employe = [IPCEmploye mj_objectWithKeyValues:obj];
                    [self.employeArray addObject:employe];
                }];
            }
        }
    }
    return self;
}

- (NSMutableArray<IPCEmploye *> *)employeArray{
    if (!_employeArray)
        _employeArray = [[NSMutableArray alloc]init];
    return _employeArray;
}


@end
