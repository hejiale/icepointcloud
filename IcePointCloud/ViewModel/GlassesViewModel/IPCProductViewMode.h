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
//Normal Products And Recommend Products
@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *>   *glassesList;
@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *>   *recommdGlassesList;
//Filter Products View And Model
@property (nonatomic, strong, readwrite) IPCFilterGlassesView                    * filterView;
@property (nonatomic, strong, readwrite) IPCFilterDataSourceResult            *filterDataSource;
@property (nonatomic, strong, readwrite) IPCFilterCategoryMode                 *filterValue;
//Search Products Var
@property (nonatomic, copy)    NSString *  searchWord;
@property (nonatomic, assign) NSInteger   currentPage;
@property (nonatomic, assign) NSInteger   limit;
@property (nonatomic, assign) BOOL         isTrying;
//Current Glasses Type
@property (nonatomic, assign) IPCTopFilterType   currentType;
//Refresh Data Status
@property (nonatomic, assign) LSRefreshDataStatus status;


/**
 Load Product List Data
 */
- (void)reloadGlassListDataWithComplete:(void(^)(NSError * error))complete;

/**
 Load Glasses Filter Category Data
 */
- (void)filterGlassCategoryWithFilterSuccess:(void(^)(NSError * error))filterSuccess;

/**
 Show Glasses Filter View
 */
- (void)showFilterCategory:(id)owner
                    InView:(UIView *)coverView
               ReloadClose:(void(^)())reloadClose
             ReloadUnClose:(void(^)())reloadUnClose;

/**
 Get Glasses Batch Paremeter Data
 */
- (void)queryBatchDegree;

/**
 Get Try Recommd Glasses Data
 */
- (void)queryRecommdGlasses:(IPCGlasses *)glass Complete:(void(^)())complete;


/**
 Clear Data
 */
- (void)resetData;

@end
