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

- (void)queryCustomerDetail:(void(^)())complete
{
    [IPCCommonUI show];
    
    [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:[IPCPayOrderManager sharedManager].currentCustomerId
                                                        SuccessBlock:^(id responseValue)
     {
         [[IPCPayOrderCurrentCustomer sharedManager] loadCurrentCustomer:responseValue];
         [IPCPayOrderManager sharedManager].currentOptometryId = [IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID;
         
         [[IPCPayOrderManager sharedManager] clearPayRecord];
         
         if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.discount) {
             [IPCPayOrderManager sharedManager].customDiscount = [IPCPayOrderCurrentCustomer sharedManager].currentCustomer.discount * 10;
         }else{
             [IPCPayOrderManager sharedManager].customDiscount = 100;
         }
         [[IPCPayOrderManager sharedManager] calculatePayAmount];
         
         if (complete) {
             complete();
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:IPCChooseCustomerNotification object:nil];
         [IPCCommonUI hiden];
     } FailureBlock:^(NSError *error) {
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:@"查询客户信息失败!"];
         }
     }];
}

- (void)validationMemberRequest:(NSString *)code Complete:(void(^)())complete
{
    [IPCCustomerRequestManager validateCustomerWithCode:code
                                           SuccessBlock:^(id responseValue)
     {
         [IPCPayOrderManager sharedManager].isValiateMember = YES;
         
         NSString * customerId = [NSString stringWithFormat:@"%d", [responseValue[@"id"] integerValue]];
         if (![[IPCPayOrderManager sharedManager].currentCustomerId isEqualToString:customerId]) {
             [IPCPayOrderManager sharedManager].currentCustomerId = customerId;
         }else{
             if (complete) {
                 complete();
             }
             [IPCCommonUI showSuccess:@"验证会员成功!"];
         }
     } FailureBlock:^(NSError *error) {
         if ([IPCAppManager sharedManager].companyCofig.isCheckMember) {
             [IPCCommonUI showError:@"会员码失效!"];
         }else{
             [IPCCommonUI showError:@"验证会员失败!"];
         }
         if (complete) {
             complete();
         }
         [IPCPayOrderManager sharedManager].isValiateMember = NO;
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
