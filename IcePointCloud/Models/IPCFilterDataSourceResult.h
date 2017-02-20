//
//  FilterDataSourceResult.h
//  IcePointCloud
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

@interface IPCFilterDataSourceResult : NSObject

- (void)parseFilterData:(id)responseObject
                  IsTry:(BOOL)isTry;

- (NSArray *)allCategoryName;

- (NSArray *)allFilterKeys;

- (NSDictionary *)allFilterValues;


@end
