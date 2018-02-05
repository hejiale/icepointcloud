//
//  IPCPayOrderViewNormalSellCellMode.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayOrderViewMode : NSObject

- (void)queryIntegralRule;

- (void)payOrderWithCurrentStatus:(NSString *)currentStatus EndStatus:(NSString *)endStatus Complete:(void(^)(NSError * error))complete;


@end

