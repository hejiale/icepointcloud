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
        _isCanEdit = NO;
        _optometryCurrentPage = 1;
        _orderCurrentPage         = 1;
        _isLoadMoreOrder          = NO;
        _isLoadMoreOptometry  = NO;
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


- (void)isCanChoose:(void(^)(BOOL isCan))isCan
{
    [[[RACSignal combineLatest:@[RACObserve(self, self.currentOptometryID),RACObserve(self, self.currentAddressID)] reduce:^id(NSString *currentOptometryID,NSString *currentAddressID)
       {
           return @([currentOptometryID integerValue] > 0 && [currentAddressID integerValue] > 0);
       }] distinctUntilChanged] subscribeNext:^(NSNumber *valid) {
           if (isCan) {
               isCan(valid.boolValue);
           }
       }];
}

#pragma mark //Requst Method
- (void)queryCustomerDetailInfo:(void(^)())completeBlock
{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:self.customerID
                                                        SuccessBlock:^(id responseValue)
     {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         strongSelf.detailCustomer         = [IPCDetailCustomer mj_objectWithKeyValues:responseValue];
         strongSelf.currentAddressID      = strongSelf.detailCustomer.currentAddressId;
         strongSelf.currentOptometryID  = strongSelf.detailCustomer.currentOptometryId;
         if (completeBlock)completeBlock();
     } FailureBlock:^(NSError *error) {
         if (completeBlock)completeBlock();
         [IPCCustomUI showError:error.domain];
     }];
}


- (void)queryHistoryOptometryList:(void(^)())completeBlock{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryUserOptometryListWithCustomID:self.customerID
                                                             Page:_optometryCurrentPage
                                                     SuccessBlock:^(id responseValue)
     {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         IPCOptometryList * optometryObject = [[IPCOptometryList alloc]initWithResponseValue:responseValue];
         [strongSelf.optometryList addObjectsFromArray:optometryObject.listArray];
         
         if ([optometryObject.listArray count] > 0 && strongSelf.optometryList.count < optometryObject.totalCount) {
             _isLoadMoreOptometry = YES;
         }else{
             _isLoadMoreOptometry = NO;
         }
         if (completeBlock)completeBlock();
     } FailureBlock:^(NSError *error) {
         if (completeBlock)completeBlock();
         [IPCCustomUI showError:error.domain];
     }];
}

- (void)queryHistotyOrderList:(void(^)())completeBlock{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryHistorySellInfoWithPhone:self.customerPhone
                                                        Page:_orderCurrentPage
                                                SuccessBlock:^(id responseValue)
     {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         IPCCustomerOrderList * orderObject = [[IPCCustomerOrderList alloc]initWithResponseValue:responseValue];
         [strongSelf.orderList addObjectsFromArray:orderObject.list];
         
         if ([orderObject.list count] > 0 && [strongSelf.orderList count] < orderObject.totalCount) {
             _isLoadMoreOrder = YES;
         }else{
             _isLoadMoreOrder = NO;
         }
         if (completeBlock)completeBlock();
     } FailureBlock:^(NSError *error) {
         if (completeBlock)completeBlock();
         [IPCCustomUI showError:error.domain];
     }];
}

- (void)queryCustomerAddressList:(void(^)())completeBlock{
    __weak typeof (self) weakSelf = self;
    [self.addressList removeAllObjects];
    [IPCCustomerRequestManager queryCustomerAddressListWithCustomID:self.customerID
                                                       SuccessBlock:^(id responseValue)
     {
         __strong typeof (weakSelf) strongSelf = weakSelf;
         IPCCustomerAddressList * addressObject = [[IPCCustomerAddressList alloc]initWithResponseValue:responseValue];
         [strongSelf.addressList addObjectsFromArray:addressObject.list];
         if (completeBlock)completeBlock();
     } FailureBlock:^(NSError *error) {
         if (completeBlock)completeBlock();
         [IPCCustomUI showError:error.domain];
     }];
}

- (void)updateUserInfo:(void(^)())completeBlock Failure:(void(^)())failure
{
    [IPCCustomUI show];
    [IPCCustomerRequestManager updateCustomerInfoWithCustomID:self.customerID
                                                 CustomerName:self.detailCustomer.customerName
                                                  CustomPhone:self.detailCustomer.customerPhone
                                                       Gender:self.detailCustomer.contactorGengerString
                                                          Age:self.detailCustomer.age
                                                        Email:self.detailCustomer.email
                                                     Birthday:self.detailCustomer.birthday
                                                       Remark:self.detailCustomer.remark
                                                    PhotoUUID:@""
                                             DefaultAddressID:self.currentAddressID
                                           DefaultOptometryID:self.currentOptometryID
                                                 SuccessBlock:^(id responseValue)
     {
         [IPCCurrentCustomerOpometry sharedManager].currentCustomer = self.detailCustomer;
         
         [self.addressList enumerateObjectsUsingBlock:^(IPCCustomerAddressMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj.addressID isEqualToString:self.currentAddressID]) {
                 [IPCCurrentCustomerOpometry sharedManager].currentAddress = obj;
                 *stop = YES;
             }
         }];
         
         [self.optometryList enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj.optometryID isEqualToString:self.currentOptometryID]) {
                 [IPCCurrentCustomerOpometry sharedManager].currentOpometry = obj;
                 *stop = YES;
             }
         }];
         [IPCCustomUI hiden];
         if (completeBlock)completeBlock();
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
         if (failure)failure();
     }];
}

@end
