//
//  IPCCartViewMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCartViewMode.h"


@implementation IPCCartViewMode


/**
 *  Judgment of the currently selected shopping
 *
 *  @return
 */
- (BOOL)shoppingCartIsEmpty
{
    return [[IPCShoppingCart sharedCart] selectItemsCount] == 0;
}


- (BOOL)judgeCartItemSelectState
{
    __block NSInteger selectCount = 0;
    
    [[[IPCShoppingCart sharedCart] itemList] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            selectCount++;
        }
    }];
    
    if (selectCount > 0) {
        if (selectCount == [[IPCShoppingCart sharedCart] itemsCount]) {
            return YES;
        }
    }
    return NO;
}


- (void)changeAllCartItemSelected:(BOOL)isSelected{
    for (int i = 0; i < [[IPCShoppingCart sharedCart] itemsCount]; i++) {
        IPCShoppingCartItem *ci = [[IPCShoppingCart sharedCart] itemAtIndex:i];
        ci.selected = isSelected;
    }
}


@end
