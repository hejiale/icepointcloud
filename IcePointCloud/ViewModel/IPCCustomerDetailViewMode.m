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

#pragma mark //Select Customer
- (void)getChooseCustomer{
    //初始化数据
    [IPCCurrentCustomer sharedManager].currentOpometry = nil;
    [IPCCurrentCustomer sharedManager].currentAddress = nil;
    [IPCCurrentCustomer sharedManager].currentCustomer = nil;
    [IPCPayOrderManager sharedManager].customerDiscount = 1;
    
    [self.optometryList enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.optometryID isEqualToString:self.detailCustomer.currentOptometryId]) {
            [IPCCurrentCustomer sharedManager].currentOpometry = obj;
        }
    }];
    
    [self.addressList enumerateObjectsUsingBlock:^(IPCCustomerAddressMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.addressID isEqualToString:self.detailCustomer.currentAddressId]) {
            [IPCCurrentCustomer sharedManager].currentAddress = obj;
        }
    }];
    
    if (self.detailCustomer) {
        [IPCCurrentCustomer sharedManager].currentCustomer = self.detailCustomer;
        [IPCPayOrderManager sharedManager].customerDiscount = self.detailCustomer.discount/10;
        [IPCPayOrderManager sharedManager].isChooseCustomer = YES;
    }
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
    [IPCCustomerRequestManager queryHistorySellInfoWithPhone:self.currentCustomer.customerPhone
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


- (void)setCurrentAddress:(NSString *)addressID Complete:(void (^)())completeBlock{
    [IPCCustomerRequestManager setDefaultAddressWithCustomID:self.currentCustomer.customerID
                                            DefaultAddressID:addressID
                                                SuccessBlock:^(id responseValue) {
                                                    if (completeBlock) {
                                                        completeBlock();
                                                    }
                                                } FailureBlock:^(NSError *error) {
                                                    if (completeBlock) {
                                                        completeBlock();
                                                    }
                                                    [IPCCustomUI showError:error.domain];
                                                }];
}


- (void)setCurrentOptometry:(NSString *)optometryID Complete:(void (^)())completeBlock{
    [IPCCustomerRequestManager setDefaultOptometryWithCustomID:self.currentCustomer.customerID
                                            DefaultOptometryID:optometryID
                                                  SuccessBlock:^(id responseValue) {
                                                      if (completeBlock) {
                                                          completeBlock();
                                                      }
                                                  } FailureBlock:^(NSError *error) {
                                                      if (completeBlock) {
                                                          completeBlock();
                                                      }
                                                      [IPCCustomUI showError:error.domain];
                                                  }];
}

@end
