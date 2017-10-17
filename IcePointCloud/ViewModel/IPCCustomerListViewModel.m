//
//  IPCCustomerListViewModel.m
//  IcePointCloud
//
//  Created by gerry on 2017/9/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomerListViewModel.h"

@implementation IPCCustomerListViewModel


- (NSMutableArray<IPCCustomerMode *> *)customerArray{
    if (!_customerArray) {
        _customerArray = [[NSMutableArray alloc]init];
    }
    return _customerArray;
}

#pragma mark //Request Data
- (void)queryCustomerList:(void(^)(NSError *error))complete
{
    self.completeBlock = complete;
    
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryCustomerListWithKeyword:self.searchWord ? : @""
                                                       Page:self.currentPage
                                               SuccessBlock:^(id responseValue)
     {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         [strongSelf parseCustomerListData:responseValue];
     } FailureBlock:^(NSError *error) {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         strongSelf.status = IPCRefreshError;
         if (strongSelf.completeBlock) {
             strongSelf.completeBlock(error);
         }
     }];
}

#pragma mark //Parse Normal Glass Data
- (void)parseCustomerListData:(id)response
{
    IPCCustomerList * result = [[IPCCustomerList alloc]initWithResponseValue:response];
    
    if (result) {
        if (result.list.count){
            [self.customerArray addObjectsFromArray:result.list];
            
            if (self.customerArray.count < result.totalCount) {
                self.status = IPCFooterRefresh_HasMoreData;
            }else{
                self.status = IPCFooterRefresh_HasNoMoreData;
            }
            
            if (self.completeBlock) {
                self.completeBlock(nil);
            }
        }else{
            if ([self.customerArray count] > 0) {
                self.status = IPCFooterRefresh_HasNoMoreData;
                if (self.completeBlock) {
                    self.completeBlock(nil);
                }
            }
        }
    }
    
    if ([self.customerArray count] == 0) {
        self.status = IPCFooterRefresh_NoData;
        if (self.completeBlock)
            self.completeBlock(nil);
    }
}

#pragma mark //Clear All Data
- (void)resetData
{
    [self.customerArray removeAllObjects];
    self.customerArray = nil;
    self.currentPage = 1;
}

@end
