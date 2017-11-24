//
//  IPCPayOrderViewNormalSellCellMode.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IPCPayOrderError)
{
    IPCPayOrderErrorSavePrototy = 0,
    IPCPayOrderErrorOfferOrder,
    IPCPayOrderErrorAuthOrder,
    IPCPayOrderErrorPayCashOrder
};

@interface IPCPayOrderViewMode : NSObject

- (void)queryIntegralRule;

- (void)saveProtyOrder:(BOOL)isProty
               Prototy:(void(^)())prototy
               PayCash:(void(^)())payCash
                 Error:(void(^)(IPCPayOrderError errorType))error;


@end

