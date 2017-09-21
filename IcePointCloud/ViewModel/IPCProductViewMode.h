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
#import "IPCFilterCategoryMode.h"
#import "IPCFilterGlassesView.h"


typedef void(^CompleteBlock)(NSError * error);
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
@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *>   *recommdGlassesList;
@property (nonatomic, strong, readwrite) IPCFilterDataSourceResult   * filterDataSource;
@property (strong, nonatomic, readwrite) IPCFilterCategoryMode               *filterValue;

@property (nonatomic, copy, readwrite) NSString *  searchWord;
@property (nonatomic, assign, readwrite) NSInteger   currentPage;
@property (nonatomic) IPCTopFilterType   currentType;
@property (nonatomic, assign, readwrite) BOOL  isTrying;
@property (nonatomic, assign) LSRefreshDataStatus status;
@property (nonatomic, copy) NSString * currentStoreId;

- (void)reloadGlassListDataWithIsTry:(BOOL)isTry
                            Complete:(void(^)(NSError * error))complete;
- (void)filterGlassCategoryWithFilterSuccess:(void(^)(NSError * error))filterSuccess;
- (void)loadFilterCategory:(id)owner InView:(UIView *)coverView  ReloadClose:(void(^)())reloadClose ReloadUnClose:(void(^)())reloadUnClose;
- (void)queryBatchDegree;
- (void)queryRecommdGlasses:(IPCGlasses *)glass Complete:(void(^)())complete;
- (void)queryRepository;

@end
