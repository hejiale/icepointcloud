//
//  IPCProductViewModel.m
//  IcePointCloud
//
//  Created by mac on 2016/11/15.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGlassListViewMode.h"

@interface IPCGlassListViewMode()<IPCFilterGlassesViewDataSource,IPCFilterGlassesViewDelegate>

@end

@implementation IPCGlassListViewMode

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

- (void)reloadGlassListDataWithComplete:(void(^)(LSRefreshDataStatus status, NSError * error))complete
{
    if (self.currentPage == 0)[self.glassesList removeAllObjects];
    self.completeBlock = complete;
    
    [self getGlassesListInfoWithPage:self.currentPage
                           ClassType:[[IPCAppManager sharedManager]classType:self.currentType]
                          SearchType:[self.filterValue getStoreFilterSource]
                          StartPrice:self.filterValue.currentStartPirce
                            EndPrice:self.filterValue.currentEndPrice];
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
{
    __weak typeof (self) weakSelf = self;
    [IPCGoodsRequestManager queryFilterGlassesListWithPage:page
                                                SearchWord:self.searchWord
                                                 ClassType:classType
                                                SearchType:searchType
                                                StartPrice:startPrice
                                                  EndPrice:endPrice
                                                     IsHot:self.isTrying
                                              SuccessBlock:^(id responseValue)
     {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         [strongSelf parseGlassesData:responseValue];
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
                                      SuccessBlock:^(id responseValue)
     {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         strongSelf.filterDataSource = [[IPCFilterDataSourceResult alloc]init];
         [strongSelf.filterDataSource parseFilterData:responseValue IsTry:strongSelf.isTrying];
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


//Parse Data
- (void)parseGlassesData:(id)response
{
    IPCGetGlassesListResult * result = [[IPCGetGlassesListResult alloc]initWithResponseValue:response];
    
    if (result) {
        if (result.glassesList.count){
            if (self.isTrying) {
                [result.glassesList enumerateObjectsUsingBlock:^(IPCGlasses * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.isTryOn) {
                        [self.glassesList addObject:obj];
                    }
                }];
            }else{
                [self.glassesList addObjectsFromArray:result.glassesList];
            }
            
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
    [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPClearSearchwordNotification object:nil];
    
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
