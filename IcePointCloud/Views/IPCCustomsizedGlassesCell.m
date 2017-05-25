//
//  IPCCustomsizedGlassesCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/5/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedGlassesCell.h"

@implementation IPCCustomsizedGlassesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.productImageView setImageURL:[NSURL URLWithString:[_glasses imageWithType:IPCGlassesImageTypeThumb].imageURL]];
        [self.productNameLabel setText:_glasses.glassName];
        [self.productPriceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
    }
}

#pragma mark //Clicked Events
- (IBAction)addGlassesAction:(id)sender {
    [self addGlasses];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(confirmSelectGlass:)]) {
            [self.delegate confirmSelectGlass:self];
        }
    }
}

- (void)addGlasses
{
    IPCShoppingCartItem * cartItem = [self cartItem];
    if (cartItem) {
        cartItem.glassCount++;
    }else{
        IPCShoppingCartItem * addCartItem = [[IPCShoppingCartItem alloc]init];
        addCartItem.glassCount = 1;
        addCartItem.glasses = self.glasses;
        [[IPCCustomsizedItem sharedItem].normalProducts addObject:addCartItem];
    }
}


- (IPCShoppingCartItem *)cartItem
{
    __block IPCShoppingCartItem * cartItem = nil;
    [[IPCCustomsizedItem sharedItem].normalProducts enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.glasses.glassesID isEqualToString:self.glasses.glassesID]) {
            cartItem = obj;
        }
    }];
    return cartItem;
}


@end
