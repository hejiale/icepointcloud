//
//  ShoppingCartView.h
//  IcePointCloud
//
//  Created by mac on 2017/2/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomKeyboard.h"

@interface IPCPayOrderShoppingCartView : UIView

@property (nonatomic, strong) IPCCustomKeyboard * keyboard;

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)())complete;

- (void)reload;

@end
