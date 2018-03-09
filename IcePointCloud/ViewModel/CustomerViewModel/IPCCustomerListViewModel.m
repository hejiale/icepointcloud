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
- (void)queryCustomerListWithIsChooseStatus:(BOOL)isChooseStatus Complete:(void(^)(NSError *error))complete
{
    self.completeBlock = complete;
    
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryCustomerListWithKeyword:self.searchWord ? : @""
                                                       Page:self.currentPage
                                               SuccessBlock:^(id responseValue)
     {
         [weakSelf parseCustomerListData:responseValue IsChoose:isChooseStatus];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:error.domain];
         
         __strong typeof(weakSelf) strongSelf = weakSelf;
         strongSelf.status = IPCRefreshError;
         
         if (self.completeBlock) {
             self.completeBlock(error);
         }
     }];
}

- (void)validationMemberRequest:(NSString *)code Complete:(void(^)(IPCCustomerMode * customer))complete
{
    [IPCCustomerRequestManager validateCustomerWithCode:code
                                           SuccessBlock:^(id responseValue)
     {
         [IPCPayOrderManager sharedManager].isValiateMember = YES;
         [IPCPayOrderManager sharedManager].memberCheckType = @"CODE";
         
         if ([responseValue isKindOfClass:[NSArray class]]) {
             id responseData = responseValue[0];
             IPCCustomerMode * customer = [IPCCustomerMode mj_objectWithKeyValues:responseData];
             if (complete) {
                 complete(customer);
             }
         }
         [IPCCommonUI showSuccess:@"验证会员成功!"];
     } FailureBlock:^(NSError *error) {
         if ([IPCAppManager sharedManager].companyCofig.isCheckMember) {
             [IPCCommonUI showError:@"会员码失效!"];
         }else{
             [IPCCommonUI showError:@"验证会员失败!"];
         }
     }];
}

- (void)queryMemberList:(void(^)(NSError *error))complete
{
    self.completeBlock = complete;
    
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryMemberListWithKeyword:self.searchWord ? :@""
                                                     Page:self.currentPage
                                             SuccessBlock:^(id responseValue)
     {
         [weakSelf parseCustomerListData:responseValue IsChoose:NO];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:error.domain];
         
         __strong typeof(weakSelf) strongSelf = weakSelf;
         strongSelf.status = IPCRefreshError;
         
         if (self.completeBlock) {
             self.completeBlock(error);
         }
     }];
}

- (void)queryBindMemberCustomer:(void(^)(NSArray * customerList, NSError *error))complete
{
    [IPCCustomerRequestManager queryBindMemberCustomerWithMemberCustomerId:[IPCPayOrderManager sharedManager].currentMemberCustomerId
                                                                SuccessBlock:^(id responseValue)
     {
         NSMutableArray * array = [[NSMutableArray alloc]init];
         
         if ([responseValue isKindOfClass:[NSArray class]]) {
             [responseValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 IPCCustomerMode * customer = [IPCCustomerMode mj_objectWithKeyValues:obj];
                 [array addObject:customer];
             }];
             if (complete) {
                 complete(array, nil);
             }
         }
     } FailureBlock:^(NSError *error) {
         if (complete) {
             complete(nil, error);
         }
     }];
}

- (void)queryVisitorCustomer:(void(^)())complete
{
    [IPCCustomerRequestManager getVisitorCustomerWithSuccessBlock:^(id responseValue)
    {
        IPCCustomerMode * customer = [IPCCustomerMode mj_objectWithKeyValues:responseValue];
        [IPCPayOrderCurrentCustomer sharedManager].currentMemberCustomer = customer;
        
        if (complete) {
            complete();
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)queryCustomerOptometry
{
    if ([[IPCPayOrderManager sharedManager] customerId])
    {
        [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:[[IPCPayOrderManager sharedManager] customerId]
                                                            SuccessBlock:^(id responseValue)
         {
             IPCDetailCustomer * detailCustomer = [IPCDetailCustomer mj_objectWithKeyValues:responseValue];
             [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = [IPCOptometryMode mj_objectWithKeyValues:detailCustomer.optometrys[0]];
         } FailureBlock:nil];
    }
}

#pragma mark //Parse Normal Glass Data
- (void)parseCustomerListData:(id)response IsChoose:(BOOL)isChoose
{
    IPCCustomerList * result = [[IPCCustomerList alloc]initWithResponseValue:response];
    
    if (result) {
        if (result.list.count){
            if (isChoose) {
                [result.list enumerateObjectsUsingBlock:^(IPCCustomerMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (!obj.memberLevel) {
                        [self.customerArray addObject:obj];
                    }
                }];
            }else{
                [self.customerArray addObjectsFromArray:result.list];
            }
            
            
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
