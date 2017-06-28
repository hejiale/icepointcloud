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
        self.currentPage =  0;
        self.currentType =  IPCTopFIlterTypeFrames;
        self.filterValue    =  [[IPCFilterTypeMode alloc]init];
    }
    return self;
}


- (NSMutableArray<IPCGlasses *> *)glassesList{
    if (!_glassesList)
        _glassesList = [[NSMutableArray alloc]init];
    return _glassesList;
}

- (NSMutableArray<IPCCustomsizedProduct *> *)customsizedList{
    if (!_customsizedList) {
        _customsizedList = [[NSMutableArray alloc]init];
    }
    return _customsizedList;
}

#pragma mark //Get Data
- (void)reloadGlassListDataWithIsTry:(BOOL)isTry
                               IsHot:(BOOL)isHot
                            Complete:(void(^)(LSRefreshDataStatus status, NSError * error))complete
{
    if (self.isBeginLoad){
        [self.glassesList removeAllObjects];
        [self.customsizedList removeAllObjects];
    }
    self.completeBlock = complete;
    
    [self getGlassesListInfoWithPage:self.currentPage
                           ClassType:[[IPCAppManager sharedManager]classType:self.currentType]
                          SearchType:[self.filterValue getStoreFilterSource]
                          StartPrice:self.filterValue.currentStartPirce
                            EndPrice:self.filterValue.currentEndPrice
                            IsTrying:isTry
                               IsHot:isHot];
}

- (void)getCustomsizedContactLensWithComplete:(void(^)(LSRefreshDataStatus status, NSError * error))complete
{
    if (self.isBeginLoad){
        [self.glassesList removeAllObjects];
        [self.customsizedList removeAllObjects];
    }
    self.completeBlock = complete;
    [self getCustomsizedContactLens];
}

- (void)getCustomsizedLensWithComplete:(void(^)(LSRefreshDataStatus status, NSError * error))complete
{
    if (self.isBeginLoad){
        [self.glassesList removeAllObjects];
        [self.customsizedList removeAllObjects];
    }
    self.completeBlock = complete;
    [self getCustomsizedLens];
}

- (void)filterGlassCategoryWithFilterSuccess:(void(^)(NSError * error))filterSuccess
{
    self.filterSuccessBlock = filterSuccess;
    [self getProductFilterDataSourceWithClassType:[[IPCAppManager sharedManager]classType:self.currentType]
                                     FilterSource:[self.filterValue getStoreFilterSource]];
}

#pragma mark //Request Data
- (void)getGlassesListInfoWithPage:(NSInteger)page
                         ClassType:(NSString *)classType
                        SearchType:(NSString *)searchType
                        StartPrice:(double)startPrice
                          EndPrice:(double)endPrice
                          IsTrying:(BOOL)isTrying
                             IsHot:(BOOL)isHot

{
    __weak typeof (self) weakSelf = self;
    [IPCGoodsRequestManager queryFilterGlassesListWithPage:page
                                                SearchWord:self.searchWord
                                                 ClassType:classType
                                                SearchType:searchType
                                                StartPrice:startPrice
                                                  EndPrice:endPrice
                                                     IsHot:isHot
                                                  IsTrying:isTrying
                                              SuccessBlock:^(id responseValue){
                                                  __strong typeof (weakSelf) strongSelf = weakSelf;
                                                  [strongSelf parseNormalGlassesData:responseValue];
                                              } FailureBlock:^(NSError *error) {
                                                  __strong typeof (weakSelf) strongSelf = weakSelf;
                                                  if (strongSelf.completeBlock) {
                                                      strongSelf.completeBlock(IPCRefreshError,error);
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
                                          [strongSelf.filterDataSource parseFilterData:responseValue IsTry:self.isTrying IsCustomsized:self.isCustomsized];
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


- (void)getCustomsizedContactLens
{
    __weak typeof (self) weakSelf = self;
    [IPCGoodsRequestManager searchCustomsizedContactLensWithPage:self.currentPage
                                                    SuccessBlock:^(id responseValue) {
                                                        __strong typeof (weakSelf) strongSelf = weakSelf;
                                                        [strongSelf parseCustomsizedGlassesData:responseValue];
                                                    } FailureBlock:^(NSError *error) {
                                                        __strong typeof (weakSelf) strongSelf = weakSelf;
                                                        if (strongSelf.completeBlock)
                                                            strongSelf.completeBlock(IPCRefreshError,error);
                                                    }];
}

- (void)getCustomsizedLens{
    __weak typeof (self) weakSelf = self;
    [IPCGoodsRequestManager searchCustomsizedLensWithPage:self.currentPage
                                             SuccessBlock:^(id responseValue) {
                                                 __strong typeof (weakSelf) strongSelf = weakSelf;
                                                 [strongSelf parseCustomsizedGlassesData:responseValue];
                                             } FailureBlock:^(NSError *error) {
                                                 __strong typeof (weakSelf) strongSelf = weakSelf;
                                                 if (strongSelf.completeBlock)
                                                     strongSelf.completeBlock(IPCRefreshError,error);
                                             }];
}


//Parse Normal Glass Data
- (void)parseNormalGlassesData:(id)response
{
    IPCProductList * result = [[IPCProductList alloc]initWithResponseValue:response];
    
    if (result) {
        if (result.glassesList.count){
            [self.glassesList addObjectsFromArray:result.glassesList];
            
            if (self.completeBlock) {
                self.completeBlock(IPCFooterRefresh_HasMoreData,nil);
            }
        }else{
            if ([self.glassesList count] > 0) {
                if (self.completeBlock) {
                    self.completeBlock(IPCFooterRefresh_HasNoMoreData,nil);
                }
            }
        }
    }
    
    if ([self.glassesList count] == 0) {
        if (self.completeBlock)
            self.completeBlock(IPCFooterRefresh_NoData,nil);
    }
}

- (void)parseCustomsizedGlassesData:(id)response
{
    IPCCustomsizedProductList * result = [[IPCCustomsizedProductList alloc]initWithResponseObject:response];
    
    if (result) {
        if (result.productsList.count){
            [self.customsizedList addObjectsFromArray:result.productsList];
            
            if (self.completeBlock) {
                self.completeBlock(IPCFooterRefresh_HasMoreData,nil);
            }
        }else{
            if ([self.glassesList count] > 0) {
                if (self.completeBlock) {
                    self.completeBlock(IPCFooterRefresh_HasNoMoreData,nil);
                }
            }
        }
    }
    
    if ([self.glassesList count] == 0) {
        if (self.completeBlock)
            self.completeBlock(IPCFooterRefresh_NoData,nil);
    }
}


- (void)loadFilterCategory:(id)owner InView:(UIView *)backgroundView ReloadClose:(void(^)())reloadClose ReloadUnClose:(void(^)())reloadUnClose
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
    
    [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCClearSearchwordNotification object:nil];
    
    if (self.reloadFilterCloseBlock) {
        self.reloadFilterCloseBlock();
    }
}

- (void)filterGlassesWithFilterKey:(NSString *)key FilterName:(NSString *)filterName{
    [self.filterValue storeFilterSource:filterName Key:key];
    
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
    
    if (self.reloadFilterUnCloseBlock) {
        self.reloadFilterUnCloseBlock();
    }
}



@end
