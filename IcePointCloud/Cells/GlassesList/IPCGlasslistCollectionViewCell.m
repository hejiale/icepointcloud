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
    
    [self.productImageView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        [self showDetailAction];
    }];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses)
    {
        //Reset Buy Icon Show Status
        [self resetBuyStatus];
        //Reload Product Image And Auto Fit
        IPCGlassesImage * glassImage = [self.glasses imageWithType:IPCGlassesImageTypeThumb];
        
        __block CGFloat scale = 0;
        if (glassImage.width > glassImage.height) {
            scale = glassImage.width/glassImage.height;
        }else{
            scale = glassImage.height/glassImage.width;
        }
        __block CGFloat width = 280;
        __block CGFloat height = width/scale;
        self.imageHeight.constant = MIN(height, 120);
        
        [self.productImageView setImageWithURL:[NSURL URLWithString:glassImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];

        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
        [self.productNameLabel setSpaceWithText:_glasses.glassName LineSpace:10 WordSpace:0];
        //Get Name Text Height And Auto Fit
       CGFloat labelHeight = [self.productNameLabel.text jk_heightWithFont:self.productNameLabel.font constrainedToWidth:self.productNameLabel.jk_width];
        self.labelHeightConstraint.constant = labelHeight + 10;
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
        //Glasses Try Icon And Stock Icon
        if (_glasses.isTryOn) {
            [self.defaultImageView setHidden:NO];
            self.tryWidth.constant = 39;
        }else{
            [self.defaultImageView setHidden:YES];
            self.tryWidth.constant = 0;
        }
        
        if (_glasses.stock > 0) {
            [self.noStockImageView setHidden:YES];
            self.noStockWidth.constant = 0;
        }else{
            [self.noStockImageView setHidden:NO];
            self.noStockWidth.constant = 39;
        }
        
        if (_glasses.isTryOn && _glasses.stock > 0) {
            self.tryLeft.constant = 0;
        }else{
            self.tryLeft.constant = 5;
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
    if (([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch)
    {
        if ([self.delegate respondsToSelector:@selector(chooseParameter:)]) {
            [self.delegate chooseParameter:self];
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
        
        if ([self.delegate respondsToSelector:@selector(reloadProductList:)]) {
            [self.delegate reloadProductList:self];
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
