//
//  GlasslistCollectionViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGlasslistCollectionViewCell.h"

@implementation IPCGlasslistCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.productNameLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    
    [self.productImageView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        [self showDetailAction];
    }];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self resetBuyStatus];
        
        IPCGlassesImage * glassImage = [self.glasses imageWithType:IPCGlassesImageTypeThumb];
        [self.productImageView setImageURL:[NSURL URLWithString:glassImage.imageURL]];
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
        
        [self.productNameLabel setText:_glasses.glassName];
        CGFloat labelHeight = [self.productNameLabel.text jk_heightWithFont:self.productNameLabel.font constrainedToWidth:self.productNameLabel.jk_width];
        self.labelHeightConstraint.constant = labelHeight;
        
        //Shopping cart whether to join the product
        __block NSInteger glassCount = [[IPCShoppingCart sharedCart]singleGlassesCount:_glasses];
        
        if (glassCount > 0) {
            [self.reduceButton setHidden:NO];
            [self.cartNumLabel setHidden:NO];
            self.reduceButtonLeading.constant = -70;
            [self.cartNumLabel setText:[[NSNumber numberWithInteger:glassCount]stringValue]];
            
            //Judge Cart Count
            __block NSInteger cartCount = [[IPCShoppingCart sharedCart] singleGlassesCount:_glasses];
            
            if (([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens) && _glasses.isBatch)
            {
                [self.reduceButton setImage:[UIImage imageNamed:@"icon_cart_edit"] forState:UIControlStateNormal];
            }else{
                [self.reduceButton setImage:[UIImage imageNamed:@"icon_subtract"] forState:UIControlStateNormal];
            }
        }
        
        if (_glasses.isTryOn) {
            [self.defaultImageView setHidden:NO];
        }else{
            [self.defaultImageView setHidden:YES];
        }
        
        if (_glasses.stock > 0) {
            [self.noStockImageView setHidden:YES];
            self.nameLeft.constant = - 39;
        }else{
            [self.noStockImageView setHidden:NO];
            self.nameLeft.constant = 5;
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
    __weak typeof (self) weakSelf = self;
    if (([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch)
    {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(chooseParameter:)]) {
            [strongSelf.delegate chooseParameter:strongSelf];
        }
    }else{
        [self addCartAnimation];
    }
}

- (IBAction)reduceCartAction:(id)sender {
    if (([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch)
    {
        if ([self.delegate respondsToSelector:@selector(editBatchParameter:)]) {
            [self.delegate editBatchParameter:self];
        }
    }else{
        [self reduceCartAnimation];
    }
}


- (void)addCartAnimation{
    if (self.glasses) {
        [[IPCShoppingCart sharedCart] plusGlass:self.glasses];
        
        if ([self.delegate respondsToSelector:@selector(addShoppingCartAnimation:)])
            [self.delegate addShoppingCartAnimation:self];
    }
}


- (void)reduceCartAnimation{
    if (self.glasses) {
        [[IPCShoppingCart sharedCart] removeGlasses:self.glasses];
        if ([self.delegate respondsToSelector:@selector(reloadProductList)]) {
            [self.delegate reloadProductList];
        }
    }
}


- (void)showDetailAction
{
    if ([self.delegate respondsToSelector:@selector(showProductDetail:)]) {
        [self.delegate showProductDetail:self];
    }
}


- (void)resetBuyStatus{
    [self.reduceButton setHidden:YES];
    [self.cartNumLabel setHidden:YES];
}


@end
