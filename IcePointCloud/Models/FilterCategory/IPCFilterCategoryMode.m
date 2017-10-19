//
//  FilterTypeMode.m
//  IcePointCloud
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCFilterCategoryMode.h"

@interface IPCFilterCategoryMode()

@property (nonatomic, strong) NSMutableDictionary * filterSourceDic;//Save the filter data dynamic binding

@end

@implementation IPCFilterCategoryMode

- (instancetype)init{
    self = [super init];
    if (self) {
        self.currentStartPirce = 0;
        self.currentEndPrice  = 0;
    }
    return self;
}

- (NSMutableDictionary *)filterSourceDic{
    if (!_filterSourceDic)
        _filterSourceDic = [[NSMutableDictionary alloc]init];
    return _filterSourceDic;
}


- (NSDictionary *)getStoreFilterSource{
    return self.filterSourceDic;
}


- (void)storeFilterSource:(NSString *)filterName Key:(NSString *)filterKey
{
    if (filterKey.length && filterName.length) {
        if ([self.filterSourceDic.allKeys containsObject:filterKey]) {
            NSMutableArray * array = self.filterSourceDic[filterKey];
            
            if (![array containsObject:filterName])
                [array addObject:filterName];
        }else{
            NSMutableArray * array = [[NSMutableArray alloc]init];
            [array addObject:filterName];
            [self.filterSourceDic setObject:array forKey:filterKey];
        }
    }
}

- (void)deleteFilterSource:(NSString *)filterName
{
    if (filterName.length) {
        for (NSString * key in self.filterSourceDic.allKeys) {
            NSMutableArray * array = self.filterSourceDic[key];
            if ([array containsObject:filterName])
                [array removeObject:filterName];
            
            if ([array count] == 0)
                [self.filterSourceDic removeObjectForKey:key];
        }
    }
}


- (void)clear{
    [self.filterSourceDic removeAllObjects];self.filterSourceDic = nil;
    self.currentEndPrice = 0;self.currentStartPirce = 0;
}


@end


