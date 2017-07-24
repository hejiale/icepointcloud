//
//  IPCCartViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCartViewMode : NSObject

- (BOOL)shoppingCartIsEmpty;

- (BOOL)judgeCartItemSelectState;

- (void)changeAllCartItemSelected:(BOOL)isSelected;

@end
