//
//  FilterGlassesView.h
//  IcePointCloud
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCFilterDataSourceResult.h"

@protocol IPCFilterGlassesViewDelegate;
@protocol IPCFilterGlassesViewDataSource;

@interface IPCFilterGlassesView : UIView

@property (nonatomic, weak) id<IPCFilterGlassesViewDataSource>dataSource;
@property (nonatomic, weak) id<IPCFilterGlassesViewDelegate>delegate;

- (void)show;
- (void)reloadFilterView;

@end

@protocol IPCFilterGlassesViewDataSource <NSObject>

- (IPCTopFilterType)filterType;
- (NSString *)startPrice;
- (NSString *)endPrice;
- (NSDictionary *)filterKeySource;
- (IPCFilterDataSourceResult *)filterDataSourceResult;

@end

@protocol IPCFilterGlassesViewDelegate <NSObject>

- (void)clearAllFilterDataSource;//Remove all screening items
- (void)filterGlassesWithClassType:(IPCTopFilterType)type;//Filter types
- (void)filterGlassesWithFilterKey:(NSString *)key FilterName:(NSString *)filterName;//Screening of the classification
- (void)filterProductsPrice:(double)startPirce EndPrice:(double)endPrice;//Screening of price range
- (void)deleteFilterSourceWithValue:(NSString *)value;

@end
