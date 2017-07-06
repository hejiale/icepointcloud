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
    [IPCCustomUI show];
    __weak typeof (self) weakSelf = self;
    [self.addressList removeAllObjects];
    
    [IPCCustomerRequestManager queryCustomerAddressListWithCustomID:self.customerId
                                                       SuccessBlock:^(id responseValue){
                                                           __strong typeof (weakSelf) strongSelf = weakSelf;
                                                           IPCCustomerAddressList * addressObject = [[IPCCustomerAddressList alloc]initWithResponseValue:responseValue];
                                                           [strongSelf.addressList addObjectsFromArray:addressObject.list];
                                                           if (completeBlock)
                                                               completeBlock();
                                                           [IPCCustomUI hiden];
                                                       } FailureBlock:^(NSError *error) {
                                                           if (completeBlock)
                                                               completeBlock();
                                                           [IPCCustomUI showError:error.domain];
                                                       }];
}

- (void)setCurrentAddress:(NSString *)addressID Complete:(void (^)())completeBlock
{
    [IPCCustomerRequestManager setDefaultAddressWithCustomID:self.customerId
                                            DefaultAddressID:addressID
                                                SuccessBlock:^(id responseValue) {
                                                    [IPCCustomUI showSuccess:@"设置默认收货地址成功!"];
                                                    if (completeBlock) {
                                                        completeBlock();
                                                    }
                                                } FailureBlock:^(NSError *error) {
                                                    [IPCCustomUI showError:error.domain];
                                                }];
}

@end
