//
//  IPCCartItemViewCellMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCartItemViewCellMode.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCEditShoppingCartCell.h"

static NSString * const kNewShoppingCartItemName = @"ExpandableShoppingCartCellIdentifier";
static NSString * const kEditShoppingCartCellIdentifier = @"IPCEditShoppingCartCellIdentifier";

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [[IPCShoppingCart sharedCart] itemsCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath IsEditState:(BOOL)isEdit
{
    if (isEdit) {
        IPCEditShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kEditShoppingCartCellIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCEditShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
        if (cartItem) {
            [cell setCartItem:cartItem Reload:^{
                if ([self.delegate respondsToSelector:@selector(reloadShoppingCartUI)]) {
                    [self.delegate reloadShoppingCartUI];
                }
            }];
        }
        return cell;
    }else{
        IPCExpandShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kNewShoppingCartItemName];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCExpandShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
        
        if (cartItem){
            [cell setCartItem:cartItem Reload:^{
                if ([self.delegate respondsToSelector:@selector(reloadShoppingCartUI)]) {
                    [self.delegate reloadShoppingCartUI];
                }
            }];
        }
        return cell;
    }
}

@end
