//
//  CurrentCustomerOpometry.h
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCurrentCustomerOpometry : NSObject

+ (IPCCurrentCustomerOpometry *)sharedManager;

@property (nonatomic, strong) IPCDetailCustomer * currentCustomer;
@property (nonatomic, strong) IPCCustomerAddressMode  * currentAddress;
@property (nonatomic, strong) IPCOptometryMode     * currentOpometry;

- (void)clearData;

@end
