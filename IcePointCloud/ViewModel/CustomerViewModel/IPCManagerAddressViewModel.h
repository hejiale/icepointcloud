//
//  IPCManagerAddressViewModel.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCManagerAddressViewModel : NSObject

@property (nonatomic, copy) NSString * customerId;
@property (nonatomic, strong) NSMutableArray<IPCCustomerAddressMode *> * addressList;

- (void)queryCustomerAddressList:(void(^)())completeBlock;
- (void)setCurrentAddress:(NSString *)addressID Complete:(void(^)())completeBlock;

@end
