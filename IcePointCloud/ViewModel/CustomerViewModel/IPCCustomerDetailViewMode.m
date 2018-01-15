//
//  IPCCustomerViewMode.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerDetailViewMode.h"

@implementation IPCCustomerDetailViewMode

- (instancetype)init{
    self = [super init];
    if (self) {
        [[IPCCustomerManager sharedManager] queryEmployee];
        [[IPCCustomerManager sharedManager] queryMemberLevel];
    }
    return self;
}

#pragma mark //Init Array
- (NSMutableArray<IPCCustomerOrderMode *> *)orderList{
    if (!_orderList)
        _orderList = [[NSMutableArray alloc]init];
    return _orderList;
}


#pragma mark //Reset Data
- (void)resetData{
    _orderCurrentPage         = 1;
    _isLoadMoreOrder          = NO;
    self.detailCustomer        = nil;
    self.customerOpometry  = nil;
    self.isLoadMoreOrder     = NO;
    self.customerId              = nil;
    [self.orderList removeAllObjects];
}

#pragma mark //Requst Method
- (void)queryCustomerDetailInfo:(void(^)())completeBlock
{
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:self.customerId
                                                        SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         strongSelf.detailCustomer       = [IPCDetailCustomer mj_objectWithKeyValues:responseValue];
         strongSelf.customerOpometry = [IPCOptometryMode mj_objectWithKeyValues:self.detailCustomer.optometrys[0]];
         
         if (completeBlock)
             completeBlock();
     } FailureBlock:^(NSError *error) {
         if (completeBlock)
             completeBlock();
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:@"查询客户信息失败!"];
         }
     }];
}


- (void)queryHistotyOrderList:(void(^)())completeBlock{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryHistorySellInfoWithPhone:self.customerId
                                                        Page:_orderCurrentPage
                                                SuccessBlock:^(id responseValue){
                                                    __strong typeof (weakSelf) strongSelf = weakSelf;
                                                    IPCCustomerOrderList * orderObject = [[IPCCustomerOrderList alloc]initWithResponseValue:responseValue];
                                                    [strongSelf.orderList addObjectsFromArray:orderObject.list];
                                                    
                                                    if ([orderObject.list count] > 0 && [strongSelf.orderList count] < orderObject.totalCount) {
                                                        _isLoadMoreOrder = YES;
                                                    }else{
                                                        _isLoadMoreOrder = NO;
                                                    }
                                                    if (completeBlock)
                                                        completeBlock();
                                                } FailureBlock:^(NSError *error) {
                                                    if (completeBlock)
                                                        completeBlock();
                                                    if ([error code] != NSURLErrorCancelled) {
                                                        [IPCCommonUI showError:@"查询客户历史订单信息失败!"];
                                                    }
                                                }];
}

@end
