//
//  FilterDataSourceResult.m
//  IcePointCloud
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCFilterDataSourceResult.h"

@interface IPCFilterDataSourceResult()

@property (nonatomic, strong) NSMutableDictionary * filterSource;//All filter data collection

@property (nonatomic, copy) NSArray * filterKeysList;//Collection filter type name

@property (nonatomic, assign) BOOL  isTryOn;

@end

@implementation IPCFilterDataSourceResult


- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}


- (NSMutableDictionary *)filterSource{
    if (!_filterSource)
        _filterSource = [[NSMutableDictionary alloc]init];
    return _filterSource;
}


- (void)parseFilterData:(id)responseObject IsTry:(BOOL)isTry
{
    self.isTryOn = isTry;
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        for (NSString * key in [responseObject allKeys]) {
            NSArray * array = responseObject[key];
            if ([array count] > 0 && key &&key.length)
                [self.filterSource setObject:array forKey:key];
        }
        
        self.filterKeysList = self.filterSource.allKeys;
    }
}


- (NSArray *)allCategoryName{
    if (self.isTryOn)
        return @[@"镜架",@"太阳眼镜",@"定制类眼镜",@"老花眼镜"];
    return @[@"镜架",@"太阳眼镜",@"定制类眼镜",@"老花眼镜",@"镜片",@"隐形眼镜",@"配件",@"储值卡",@"其它",@"定制隐形眼镜",@"定制镜片"];
}

- (NSArray *)allFilterKeys{
    return self.filterKeysList;
}

- (NSDictionary *)allFilterValues{
    return self.filterSource;
}





@end
