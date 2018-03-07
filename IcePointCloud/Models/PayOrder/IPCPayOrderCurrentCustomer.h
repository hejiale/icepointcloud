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

@property (nonatomic, strong, readwrite) IPCCustomerMode      * currentCustomer;//选中客户信息
@property (nonatomic, strong, readwrite) IPCOptometryMode     * currentOpometry;
@property (nonatomic, strong, readwrite) IPCCustomerMode      *  currentMember;//选中的会员卡
@property (nonatomic, strong, readwrite) IPCCustomerMode      *  currentMemberCustomer;//选中的会员卡所选择的客户

- (void)clearData;

@end
