//
//  CurrentCustomerOpometry.h
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayOrderCurrentCustomer : NSObject

+ (IPCPayOrderCurrentCustomer *)sharedManager;

@property (nonatomic, strong, readwrite) IPCDetailCustomer              * currentCustomer;
@property (nonatomic, strong, readwrite) IPCOptometryMode             * currentOpometry;
@property (nonatomic, strong, readwrite) IPCCustomerMode              *  currentMember;

- (void)loadCurrentCustomer:(IPCDetailCustomer *)detailCustomer;

- (void)clearData;

@end
