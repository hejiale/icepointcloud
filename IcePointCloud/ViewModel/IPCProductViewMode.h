//
//  IPCProductViewModel.h
//  IcePointCloud
//
//  Created by mac on 2016/11/15.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCProductList.h"
#import "IPCFilterDataSourceResult.h"
#import "IPCFilterTypeMode.h"
#import "IPCFilterGlassesView.h"


typedef enum : NSUInteger {
    /**
     *  More Data
     */
    IPCFooterRefresh_HasMoreData,
    /**
     *  No More Data
     */
    IPCFooterRefresh_HasNoMoreData,
    /**
     *  None Data
     */
    IPCFooterRefresh_NoData,
    /**
     *  Error
     */
    IPCRefreshError
    
} LSRefreshDataStatus;

typedef void(^CompleteBlock)(LSRefreshDataStatus status, NSError * error);
typedef void(^FilterSucceedBlock)(NSError * error);
typedef void(^ReloadFilterCloseBlock)();
typedef void(^ReloadFilterUnCloseBlock)();

@interface IPCProductViewMode : NSObject

@property (nonatomic, copy) CompleteBlock              completeBlock;
@property (nonatomic, copy) FilterSucceedBlock         filterSuccessBlock;
@property (nonatomic, copy) ReloadFilterCloseBlock    reloadFilterCloseBlock;
@property (nonatomic, copy) ReloadFilterUnCloseBlock    reloadFilterUnCloseBlock;

@property (strong, nonatomic, readwrite) IPCFilterGlassesView   * filterView;

@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *>   *glassesList;
@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomsizedProduct *>   * customsizedList;
@property (nonatomic, strong, readwrite) IPCFilterDataSourceResult   * filterDataSource;
@property (strong, nonatomic, readwrite) IPCFilterTypeMode               *filterValue;

@property (nonatomic, copy, readwrite) NSString *  searchWord;
@property (nonatomic, assign, readwrite) NSInteger   currentPage;
@property (nonatomic) IPCTopFilterType   currentType;
@property (nonatomic, assign, readwrite) BOOL  isTrying;
@property (nonatomic, assign, readwrite) BOOL  isCustomsized;
@property (nonatomic, assign, readwrite) BOOL  isBeginLoad;

- (void)reloadGlassListDataWithIsTry:(BOOL)isTry
                               IsHot:(BOOL)isHot
                            Complete:(void(^)(LSRefreshDataStatus status, NSError * error))complete;
- (void)filterGlassCategoryWithFilterSuccess:(void(^)(NSError * error))filterSuccess;
- (void)getCustomsizedLensWithComplete:(void(^)(LSRefreshDataStatus status, NSError * error))complete;
- (void)getCustomsizedContactLensWithComplete:(void(^)(LSRefreshDataStatus status, NSError * error))complete;
- (void)loadFilterCategory:(id)owner InView:(UIView *)backgroundView ReloadClose:(void(^)())reloadClose ReloadUnClose:(void(^)())reloadUnClose;

@end
