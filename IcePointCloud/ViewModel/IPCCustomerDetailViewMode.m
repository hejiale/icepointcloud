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
        [[IPCEmployeeeManager sharedManager] queryEmployee];
        [[IPCEmployeeeManager sharedManager] queryMemberLevel];
    }
    return self;
}

#pragma mark //Init Array
- (NSMutableArray<IPCCustomerOrderMode *> *)orderList{
    if (!_orderList)
        _orderList = [[NSMutableArray alloc]init];
    return _orderList;
}

- (NSMutableArray<IPCOptometryMode *> *)optometryList{
    if (!_optometryList)
        _optometryList = [[NSMutableArray alloc]init];
    return _optometryList;
}

- (NSMutableArray<IPCCustomerAddressMode *> *)addressList{
    if (!_addressList)
        _addressList = [[NSMutableArray alloc]init];
    return _addressList;
}

#pragma mark //Reset Data
- (void)resetData{
    _optometryCurrentPage = 1;
    _orderCurrentPage         = 1;
    _isLoadMoreOrder          = NO;
    _isLoadMoreOptometry  = NO;
    [self.addressList removeAllObjects];
    [self.optometryList removeAllObjects];
    [self.orderList removeAllObjects];
}

#pragma mark //Requst Method
- (void)queryCustomerDetailInfo:(void(^)())completeBlock
{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:self.currentCustomer.customerID
                                                        SuccessBlock:^(id responseValue){
                                                            __strong typeof (weakSelf) strongSelf = weakSelf;
                                                            strongSelf.detailCustomer         = [IPCDetailCustomer mj_objectWithKeyValues:responseValue];
                                                            if (completeBlock)
                                                                completeBlock();
                                                        } FailureBlock:^(NSError *error) {
                                                            if (completeBlock)
                                                                completeBlock();
                                                            [IPCCustomUI showError:error.domain];
                                                        }];
}


- (void)queryHistoryOptometryList:(void(^)())completeBlock{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryUserOptometryListWithCustomID:self.currentCustomer.customerID
                                                             Page:_optometryCurrentPage
                                                     SuccessBlock:^(id responseValue){
                                                         __strong typeof (weakSelf) strongSelf = weakSelf;
                                                         IPCOptometryList * optometryObject = [[IPCOptometryList alloc]initWithResponseValue:responseValue];
                                                         [strongSelf.optometryList addObjectsFromArray:optometryObject.listArray];
                                                         
                                                         if ([optometryObject.listArray count] > 0 && strongSelf.optometryList.count < optometryObject.totalCount) {
                                                             _isLoadMoreOptometry = YES;
                                                         }else{
                                                             _isLoadMoreOptometry = NO;
                                                         }
                                                         if (completeBlock)
                                                             completeBlock();
                                                     } FailureBlock:^(NSError *error) {
                                                         if (completeBlock)
                                                             completeBlock();
                                                         [IPCCustomUI showError:error.domain];
                                                     }];
}

- (void)queryHistotyOrderList:(void(^)())completeBlock{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryHistorySellInfoWithPhone:self.currentCustomer.customerID
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
                                                    [IPCCustomUI showError:error.domain];
                                                }];
}

- (void)queryCustomerAddressList:(void(^)())completeBlock{
    __weak typeof (self) weakSelf = self;
    [self.addressList removeAllObjects];
    [IPCCustomerRequestManager queryCustomerAddressListWithCustomID:self.currentCustomer.customerID
                                                       SuccessBlock:^(id responseValue){
                                                           __strong typeof (weakSelf) strongSelf = weakSelf;
                                                           IPCCustomerAddressList * addressObject = [[IPCCustomerAddressList alloc]initWithResponseValue:responseValue];
                                                           [strongSelf.addressList addObjectsFromArray:addressObject.list];
                                                           if (completeBlock)
                                                               completeBlock();
                                                       } FailureBlock:^(NSError *error) {
                                                           if (completeBlock)
                                                               completeBlock();
                                                           [IPCCustomUI showError:error.domain];
                                                       }];
}

@end
