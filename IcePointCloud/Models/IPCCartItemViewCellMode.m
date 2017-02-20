//
//  IPCCartItemViewCellMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCartItemViewCellMode.h"
#import "IPCExpandShoppingCartCell.h"

static NSString * const kNewShoppingCartItemName = @"ExpandableShoppingCartCellIdentifier";

@implementation IPCCartItemViewCellMode

- (CGFloat)cartItemProductCellHeight:(IPCShoppingCartItem *)item
{
    if (item.expanded) {
        switch ([item.glasses filterType]) {
            case IPCTopFilterTypeCustomized:
                return 410;
            case IPCTopFilterTypeLens:
                return 305;
            default:
                break;
        }
    }else{
        if ([item.glasses filterType] == IPCTopFilterTypeCustomized || [item.glasses filterType] == IPCTopFilterTypeLens)
            return 155;
    }
    return 128;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  IsPay:(BOOL)isPay{
    return isPay ? [[IPCShoppingCart sharedCart] selectedItemsCount] : [[IPCShoppingCart sharedCart] itemsCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath IsPay:(BOOL)isPay
{
    IPCExpandShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kNewShoppingCartItemName];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCExpandShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCShoppingCartItem * cartItem = isPay ? [[IPCShoppingCart sharedCart] selectedItemAtIndex:indexPath.row] : [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row];
    
    if (cartItem){
        [cell setIsInOrder:isPay];
        [cell setCartItem:cartItem
                    Count:^{
                        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:@"IPCCartUnitCountChange" object:nil];
                    } Expand:^{
                        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:@"IPCCartExpandStateChange" object:nil userInfo:@{@"row":@(indexPath.row)}];
                    } Cart:^{
                        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:@"IPCCartAddContactLensChange" object:nil userInfo:@{@"row":@(indexPath.row)}];
                    }];
    }
    return cell;
}

@end
