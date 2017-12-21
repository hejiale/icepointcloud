//
//  IPCCompanyConfig.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCompanyConfig : NSObject

@property (nonatomic, assign, readonly) BOOL  autoAuditedSalesOrder;
@property (nonatomic, assign, readonly) BOOL  autoDeployForWorkSheet;
@property (nonatomic, assign, readonly) BOOL  autoInvOutAfterAudited;//自动出库判断
@property (nonatomic, assign, readonly) BOOL  autoRemoveInventoryOut;
@property (nonatomic, assign, readonly) BOOL  isCheckInventory;
@property (nonatomic, assign, readonly) BOOL  isCheckMember;
@property (nonatomic, assign, readonly) BOOL  machiningConfiguration;
@property (nonatomic, assign, readonly) BOOL  memberCodeKeyboard;
@property (nonatomic, copy, readonly) NSString *  defaultPayTypeConfigId;//默认收款方式
@property (nonatomic, copy, readonly) NSString *  takingMirrorTimeConfig;

@end
