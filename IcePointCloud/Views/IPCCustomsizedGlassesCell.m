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
- (IBAction)minusAction:(id)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count--;
    if (count <= 0)count = 0;
    [self.countLabel setText:[NSString stringWithFormat:@"%d",count]];
}

- (IBAction)plusAction:(id)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count++;
    [self.countLabel setText:[NSString stringWithFormat:@"%d",count]];
}

//- (IBAction)sureAction:(id)sender {
//    NSInteger count = [self.countLabel.text integerValue];
//    
//    if (!self.hasChooseImageView.hidden) {
//        [[IPCCustomsizedItem sharedItem].normalProducts enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([self.glasses.glassesID isEqualToString:obj.glasses.glassesID]) {
//                obj.count += count;
//            }
//        }];
//    }else{
//        IPCShoppingCartItem * cartItem = [[IPCShoppingCartItem alloc]init];
//        cartItem.count    = count;
//        cartItem.glasses = self.glasses;
//        [[IPCCustomsizedItem sharedItem].normalProducts addObject:cartItem];
//    }
//
//    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(confirmSelectGlass:)]) {
//            [self.delegate confirmSelectGlass:self];
//        }
//    }
//}


@end
