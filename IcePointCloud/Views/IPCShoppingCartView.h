//
//  ShoppingCartView.h
//  IcePointCloud
//
//  Created by mac on 2017/2/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCShoppingCartView : UIView

- (void)showWithPay:(void(^)())pay;
- (void)dismiss:(void(^)())complete;

@end
