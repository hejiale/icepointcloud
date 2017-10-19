//
//  IPCProductViewModel.m
//  IcePointCloud
//
//  Created by mac on 2016/11/15.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCProductViewMode.h"

@interface IPCProductViewMode()<IPCFilterGlassesViewDataSource,IPCFilterGlassesViewDelegate>

@end

@implementation IPCProductViewMode

- (instancetype)init{
    self = [super init];
    if (self) {
        self.searchWord =  @"";
        self.currentType =  IPCTopFIlterTypeFrames;
        self.filterValue    =  [[IPCFilterCategoryMode alloc]init];
    }
    return self;
}


- (NSMutableArray<IPCGlasses *> *)glassesList{
    if (!_glassesList)
        _glassesList = [[NSMutableArray alloc]init];
    return _glassesList;
}

- (NSMutableArray<IPCGlasses *> *)recommdGlassesList{
    if (!_recommdGlassesList) {
        _recommdGlassesList = [[NSMutableArray alloc]init];
    }
    return _recommdGlassesList;
}

- (void)resetData
{
    self.limit = 30;
    self.currentPage = 0;
    [self.glassesList removeAllObjects];
    self.glassesList = nil;
}


#pragma mark //Get Data
- (void)reloadGlassListDataWithComplete:(void(^)(NSError * error))complete
{
    self.completeBlock = complete;
    
    [self getGlassesListInfoWithPage:self.currentPage
                               Limit:self.limit
                           ClassType:[[IPCAppManager sharedManager] classType:self.currentType] ? : @""
                          SearchType:[self.filterValue getStoreFilterSource]
                          StartPrice:self.filterValue.currentStartPirce
                            EndPrice:self.filterValue.currentEndPrice
                            IsTrying:self.isTrying
                             StoreId:[IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @""];
}


- (void)filterGlassCategoryWithFilterSuccess:(void(^)(NSError * error))filterSuccess
{
    self.filterSuccessBlock = filterSuccess;
    
    [self getProductFilterDataSourceWithClassType:[[IPCAppManager sharedManager]classType:self.currentType] ? : @""
                                     FilterSource:[self.filterValue getStoreFilterSource]];
}

- (void)queryBatchDegree
{
    if (self.currentType  == IPCTopFilterTypeReadingGlass) {
        [self queryBatchDegree:@"READING_GLASSES_DEGREE" Complete:^(CGFloat start, CGFloat end, CGFloat step) {
            [[IPCBatchDegreeObject instance] batchReadingDegrees:start End:end Step:step];
        }];
    }else if (self.currentType == IPCTopFilterTypeContactLenses){
        [self queryBatchSphCyl:@"CONTACT_LENS_DEGREE" Complete:^(CGFloat startSph, CGFloat endSph, CGFloat stepSph, CGFloat startCyl, CGFloat endCyl, CGFloat stepCyl) {
            [[IPCBatchDegreeObject instance] batchContactlensWithStartSph:startSph EndSph:endSph StepSph:stepSph StartCyl:startCyl EndCyl:endCyl StepCyl:stepCyl];
        }];
    }else if (self.currentType == IPCTopFilterTypeLens){
        [self queryBatchSphCyl:@"LENS_DEGREE" Complete:^(CGFloat startSph, CGFloat endSph, CGFloat stepSph, CGFloat startCyl, CGFloat endCyl, CGFloat stepCyl) {
            [[IPCBatchDegreeObject instance] batchContactlensWithStartSph:startSph EndSph:endSph StepSph:stepSph StartCyl:startCyl EndCyl:endCyl StepCyl:stepCyl];
        }];
    }
}

#pragma mark //Request Data
- (void)getGlassesListInfoWithPage:(NSInteger)page
                             Limit:(NSInteger)limit
                         ClassType:(NSString *)classType
                        SearchType:(NSString *)searchType
                        StartPrice:(double)startPrice
                          EndPrice:(double)endPrice
                          IsTrying:(BOOL)isTrying
                           StoreId:(NSString *)storeId

{
    __weak typeof (self) weakSelf = self;
    [IPCGoodsRequestManager queryFilterGlassesListWithPage:page
                                                     Limit:limit
                                                SearchWord:self.searchWord
                                                 ClassType:classType
                                                SearchType:searchType
                                                StartPrice:startPrice
                                                  EndPrice:endPrice
                                                  IsTrying:isTrying
                                                   StoreId:storeId
                                              SuccessBlock:^(id responseValue){
                                                  __strong typeof (weakSelf) strongSelf = weakSelf;
                                                  [strongSelf parseNormalGlassesData:responseValue];
                                              } FailureBlock:^(NSError *error) {
                                                  __strong typeof (weakSelf) strongSelf = weakSelf;
                                                  strongSelf.status = IPCRefreshError;
                                                  if (strongSelf.completeBlock) {
                                                      strongSelf.completeBlock(error);
                                                  }
                                              }];
}


- (void)getProductFilterDataSourceWithClassType:(NSString *)classType FilterSource:(NSDictionary *)filterSource
{
    __weak typeof (self) weakSelf = self;
    [IPCGoodsRequestManager getAllCateTypeWithType:classType
                                         FilterKey:filterSource
                                      SuccessBlock:^(id responseValue){
                                          __strong typeof (weakSelf) strongSelf = weakSelf;
                                          strongSelf.filterDataSource = [[IPCFilterDataSourceResult alloc]init];
                                          [strongSelf.filterDataSource parseFilterData:responseValue IsTry:self.isTrying];
                                          if (strongSelf.filterView)
                                              [strongSelf.filterView reloadFilterView];
                                          
                                          if (strongSelf.filterSuccessBlock)
                                              strongSelf.filterSuccessBlock(nil);
                                      } FailureBlock:^(NSError *error) {
                                          __strong typeof (weakSelf) strongSelf = weakSelf;
                                          if (strongSelf.filterSuccessBlock)
                                              strongSelf.filterSuccessBlock(error);
                                      }];
}

- (void)queryBatchDegree:(NSString *)type Complete:(void(^)(CGFloat startDegree, CGFloat endDegree, CGFloat stepDegree))complete
{
    [IPCBatchRequestManager queryBatchLensConfig:type
                                    SuccessBlock:^(id responseValue)
     {
         if ([responseValue isKindOfClass:[NSArray class]]) {
             id values = responseValue[0][@"values"];
             
             if ([values isKindOfClass:[NSDictionary class]]) {
                 if (complete) {
                     complete([values[@"startSph"] floatValue],[values[@"endSph"] floatValue],[values[@"sphStep"] floatValue]);
                 }
             }
         }
     } FailureBlock:^(NSError *error) {
     }];
}

- (void)queryBatchSphCyl:(NSString *)type Complete:(void(^)(CGFloat startSph, CGFloat endSph, CGFloat stepSph,CGFloat startCyl, CGFloat endCyl, CGFloat stepCyl))complete
{
    [IPCBatchRequestManager queryBatchLensConfig:type
                                    SuccessBlock:^(id responseValue)
     {
         if ([responseValue isKindOfClass:[NSArray class]] && responseValue) {
             NSArray * result = responseValue;
             if (result.count) {
                 id values = result[0][@"values"];
                 
                 if ([values isKindOfClass:[NSDictionary class]]) {
                     if (complete) {
                         complete([values[@"startSph"] floatValue],[values[@"endSph"] floatValue],[values[@"sphStep"] floatValue],[values[@"startCyl"] floatValue],[values[@"endCyl"] floatValue],[values[@"cylStep"] floatValue]);
                     }
                 }
             }
         }
     } FailureBlock:^(NSError *error) {
     }];
}

- (void)queryRecommdGlasses:(IPCGlasses *)glass Complete:(void(^)())complete
{
    [self.recommdGlassesList removeAllObjects];
    
    [IPCGoodsRequestManager queryRecommdGlassesWithClassType:[glass glassType]
                                                       Style:glass.style
                                                SuccessBlock:^(id responseValue)
     {
         IPCProductList * result = [[IPCProductList alloc]initWithResponseValue:responseValue];
         [self.recommdGlassesList addObjectsFromArray:result.glassesList];
         if (complete) {
             complete();
         }
     } FailureBlock:^(NSError *error) {
         if (complete) {
             complete();
         }
     }];
}

#pragma mark //Parse Normal Glass Data
- (void)parseNormalGlassesData:(id)response
{
    IPCProductList * result = [[IPCProductList alloc]initWithResponseValue:response];
    
    if (result) {
        if (result.glassesList.count){
            [self.glassesList addObjectsFromArray:result.glassesList];
            
            if (self.glassesList.count < result.totalCount) {
                self.status = IPCFooterRefresh_HasMoreData;
            }else{
                self.status = IPCFooterRefresh_HasNoMoreData;
            }
            
            if (self.completeBlock) {
                self.completeBlock(nil);
            }
        }else{
            if ([self.glassesList count] > 0) {
                self.status = IPCFooterRefresh_HasNoMoreData;
                if (self.completeBlock) {
                    self.completeBlock(nil);
                }
            }
        }
    }
    
    if ([self.glassesList count] == 0) {
        self.status = IPCFooterRefresh_NoData;
        if (self.completeBlock)
            self.completeBlock(nil);
    }
}

#pragma mark //Load Filter Category View
- (void)showFilterCategory:(id)owner InView:(UIView *)backgroundView ReloadClose:(void(^)())reloadClose ReloadUnClose:(void(^)())reloadUnClose
{
    self.reloadFilterCloseBlock = reloadClose;
    self.reloadFilterUnCloseBlock = reloadUnClose;
    
    _filterView = [UIView jk_loadInstanceFromNibWithName:@"IPCFilterGlassesView" owner:owner];
    [_filterView setFrame:CGRectMake(-_filterView.jk_width, 0, _filterView.jk_width, backgroundView.jk_height)];
    [_filterView setDataSource:self];
    [_filterView setDelegate:self];
    [backgroundView addSubview:_filterView];
    [_filterView show];
    [_filterView reloadFilterView];
}


#pragma mark //FilterGlassesViewDataSource
- (IPCTopFilterType)filterType{
    return self.currentType;
}

- (IPCFilterDataSourceResult *)filterDataSourceResult{
    return self.filterDataSource;
}

- (NSDictionary *)filterKeySource{
    return [self.filterValue getStoreFilterSource];
}

- (NSString *)startPrice{
    return self.filterValue.currentStartPirce > 0? [[NSNumber numberWithDouble:self.filterValue.currentStartPirce] stringValue] : @"";
}

- (NSString *)endPrice{
    return self.filterValue.currentEndPrice > 0 ? [[NSNumber numberWithDouble:self.filterValue.currentEndPrice]stringValue] : @"";
}

#pragma mark //FilterGlassesViewDelegate
- (void)clearAllFilterDataSource{
    [self.filterValue clear];
    
    if (self.reloadFilterCloseBlock) {
        self.reloadFilterCloseBlock();
    }
}

- (void)filterGlassesWithClassType:(IPCTopFilterType)type{
    self.searchWord = @"";
    self.currentType = type;
    [self.filterValue clear];
    self.filterDataSource = [[IPCFilterDataSourceResult alloc] init];
    
    if (self.reloadFilterCloseBlock) {
        self.reloadFilterCloseBlock();
    }
}

- (void)filterGlassesWithFilterKey:(NSString *)key FilterName:(NSString *)filterName{
    [self.filterValue storeFilterSource:filterName Key:key];
    [self.filterView setCoverStatus:NO];
    
    if (self.reloadFilterUnCloseBlock) {
        self.reloadFilterUnCloseBlock();
    }
}

- (void)filterProductsPrice:(double)startPirce EndPrice:(double)endPrice{
    self.filterValue.currentStartPirce = startPirce;
    self.filterValue.currentEndPrice = endPrice;
    
    if (self.reloadFilterCloseBlock) {
        self.reloadFilterCloseBlock();
    }
}

- (void)deleteFilterSourceWithValue:(NSString *)value{
    [self.filterValue deleteFilterSource:value];
    [self.filterView setCoverStatus:NO];
    
    if (self.reloadFilterUnCloseBlock) {
        self.reloadFilterUnCloseBlock();
    }
}



@end
