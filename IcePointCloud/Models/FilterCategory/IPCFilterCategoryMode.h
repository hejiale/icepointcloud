//
//  FilterTypeMode.h
//  IcePointCloud
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCFilterCategoryMode : NSObject

@property (assign, nonatomic, readwrite) double  currentStartPirce;//The starting price
@property (assign, nonatomic, readwrite) double  currentEndPrice;//End of the price

- (NSDictionary *)getStoreFilterSource;
- (void)storeFilterSource:(NSString *)filterName Key:(NSString *)filterKey;
- (void)deleteFilterSource:(NSString *)filterName;
- (void)clear;

@end

