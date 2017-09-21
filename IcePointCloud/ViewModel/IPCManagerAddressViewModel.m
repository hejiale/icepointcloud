//
//  IPCManagerAddressViewModel.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerAddressViewModel.h"

@implementation IPCManagerAddressViewModel

- (NSMutableArray<IPCCustomerAddressMode *> *)addressList{
    if (!_addressList) {
        _addressList = [[NSMutableArray alloc]init];
    }
    return _addressList;
}

- (void)queryCustomerAddressList:(void(^)())completeBlock
{
    __weak typeof (self) weakSelf = self;
    [self.addressList removeAllObjects];
    
    [IPCCustomerRequestManager queryCustomerAddressListWithCustomID:self.customerId
                                                       SuccessBlock:^(id responseValue){
                                                           __strong typeof (weakSelf) strongSelf = weakSelf;
                                                           IPCCustomerAddressList * addressObject = [[IPCCustomerAddressList alloc]initWithResponseValue:responseValue];
                                                           [strongSelf.addressList addObjectsFromArray:addressObject.list];
                                                           if (completeBlock)
                                                               completeBlock();
                                                       } FailureBlock:^(NSError *error) {
                                                           if (completeBlock)
                                                               completeBlock();
                                                           if ([error code] != NSURLErrorCancelled) {
                                                               [IPCCommonUI showError:@"查询客户地址信息失败!"];
                                                           }
                                                           
                                                       }];
}

- (void)setCurrentAddress:(NSString *)addressID Complete:(void (^)())completeBlock
{
    [IPCCustomerRequestManager setDefaultAddressWithCustomID:self.customerId
                                            DefaultAddressID:addressID
                                                SuccessBlock:^(id responseValue) {
                                                    if (completeBlock) {
                                                        completeBlock();
                                                    }
                                                } FailureBlock:^(NSError *error) {
                                                    if ([error code] != NSURLErrorCancelled) {
                                                        [IPCCommonUI showError:@"设置默认地址失败!"];
                                                    }
                                                }];
}

@end
