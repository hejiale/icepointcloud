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
    
    [self.priceLabel setTextColor:COLOR_RGB_RED];
    
    __weak typeof (self) weakSelf = self;
    [self.imageScrollView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.glasses)
            if ([strongSelf.delegate respondsToSelector:@selector(showProductDetail:)])
                [strongSelf.delegate showProductDetail:strongSelf];
    }];
    
    [self addSubview:self.imagePageControl];
    [self bringSubviewToFront:self.imagePageControl];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __block NSMutableArray<IPCGlassesImage *> * images = [[NSMutableArray alloc]init];
        
        if (self.glasses.isTryOn && self.isTrying) {
            if ([self.glasses imageWithType:IPCGlassesImageTypeFrontialNormal])
                [images addObject:[self.glasses imageWithType:IPCGlassesImageTypeFrontialNormal]];
            
            if ([self.glasses imageWithType:IPCGlassesImageTypeProfileNormal])
                [images addObject:[self.glasses imageWithType:IPCGlassesImageTypeProfileNormal]];
        }else{
            if ([self.glasses imageWithType:IPCGlassesImageTypeThumb]) {
                [images addObject:[self.glasses imageWithType:IPCGlassesImageTypeThumb]];
            }
        }
        
        [images enumerateObjectsUsingBlock:^(IPCGlassesImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
            UIImageView * glassImageView = [[UIImageView alloc]initWithFrame:CGRectMake(idx*self.jk_width+20, 0, self.jk_width-40, self.imageScrollView.jk_height)];
            glassImageView.contentMode = UIViewContentModeScaleAspectFit;
            [glassImageView setImageWithURL:[NSURL URLWithString:obj.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
            [self.imageScrollView addSubview:glassImageView];
        }];
        
        [self.imageScrollView setContentSize:CGSizeMake(images.count * self.jk_width, 0)];
        [self.imageScrollView setContentOffset:CGPointZero];
        self.imagePageControl.numberOfPages = images.count;
        
        [self.priceLabel setAttributedText:[IPCUIKit subStringWithText:[NSString stringWithFormat:@"￥%.f",glasses.price] BeginRang:0 Rang:1 Font:[UIFont systemFontOfSize:13 weight:UIFontWeightThin] Color:COLOR_RGB_RED]];
        
        [self.productNameLabel setText:_glasses.glassName];
        CGFloat labelHeight = [self.productNameLabel.text jk_heightWithFont:self.productNameLabel.font constrainedToWidth:self.productNameLabel.jk_width];
        self.labelHeightConstraint.constant = labelHeight;
        
        //Shopping cart whether to join the product
        __block NSInteger glassCount = [[IPCShoppingCart sharedCart]singleGlassesCount:self.glasses];
        
        if (glassCount > 0) {
            [self.reduceButton setHidden:NO];
            [self.cartNumLabel setHidden:NO];
            self.reduceButtonLeading.constant = -46;
            [self.cartNumLabel setText:[[NSNumber numberWithInteger:glassCount]stringValue]];
        } else {
            [self.reduceButton setHidden:YES];
            [self.cartNumLabel setHidden:YES];
        }
        
        //Judge stock
        if (_glasses.stock > 0) {
            NSInteger cartCount = [[IPCShoppingCart sharedCart] singleGlassesCount:_glasses];
            if (cartCount >= _glasses.stock) {
                [self.addCartButton setImage:[UIImage imageNamed:@"icon_add_disable"] forState:UIControlStateNormal];
            }else{
                [self.addCartButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
            }
            if ((([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch) || ([self.glasses filterType] == IPCTopFilterTypeAccessory && self.glasses.solutionType))
            {
                if (cartCount >= _glasses.stock) {
                    [self.reduceButton setImage:[UIImage imageNamed:@"icon_cart_unedit"] forState:UIControlStateNormal];
                }else{
                    [self.reduceButton setImage:[UIImage imageNamed:@"icon_cart_edit"] forState:UIControlStateNormal];
                }
            }else{
                [self.reduceButton setImage:[UIImage imageNamed:@"icon_subtract"] forState:UIControlStateNormal];
            }
        }else{
            [self.addCartButton setImage:[UIImage imageNamed:@"icon_add_disable"] forState:UIControlStateNormal];
            if ((([self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch) || ([self.glasses filterType] == IPCTopFilterTypeAccessory && self.glasses.solutionType) || [self.glasses filterType] == IPCTopFilterTypeContactLenses)
            {
                [self.reduceButton setImage:[UIImage imageNamed:@"icon_cart_unedit"] forState:UIControlStateNormal];
            }else{
                [self.reduceButton setImage:[UIImage imageNamed:@"icon_subtract_disable"] forState:UIControlStateNormal];
            }
        }
    }
}


#pragma mark //Set UI
- (UIPageControl *)imagePageControl{
    if (!_imagePageControl) {
        _imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.imageScrollView.jk_bottom - 25, self.jk_width, 20)];
        _imagePageControl.hidesForSinglePage = YES;
        _imagePageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _imagePageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    }
    return _imagePageControl;
}


#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
    //---------------******预售添加参数*******----------------//
//    __weak typeof (self) weakSelf = self;
//    if ((([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch) || ([self.glasses filterType] == IPCTopFilterTypeAccessory && self.glasses.solutionType) || ([self.glasses filterType] == IPCTopFilterTypeContactLenses && self.glasses.stock == 0))
//    {
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        if ([strongSelf.delegate respondsToSelector:@selector(chooseParameter:)]) {
//            [strongSelf.delegate chooseParameter:strongSelf];
//        }
//    }else{
//        [self addCartAnimation];
//    }
    __weak typeof (self) weakSelf = self;
    if ((([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch) || ([self.glasses filterType] == IPCTopFilterTypeAccessory && self.glasses.solutionType))
    {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (([strongSelf.glasses filterType] == IPCTopFilterTypeContactLenses && strongSelf.glasses.stock == 0) || ([strongSelf.glasses filterType] == IPCTopFilterTypeAccessory && strongSelf.glasses.stock == 0)) {
            [IPCUIKit showError:@"暂无库存，请重新选择!"];
        }else{
            if ([strongSelf.delegate respondsToSelector:@selector(chooseParameter:)]) {
                [strongSelf.delegate chooseParameter:strongSelf];
            }
        }
    }else{
        [self addCartAnimation];
    }
}

- (IBAction)reduceCartAction:(id)sender {
    if ((([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch) || ([self.glasses filterType] == IPCTopFilterTypeAccessory && self.glasses.solutionType) || ([self.glasses filterType] == IPCTopFilterTypeContactLenses && self.glasses.stock == 0))
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
        
        __block NSInteger glassCount = [[IPCShoppingCart sharedCart]singleGlassesCount:self.glasses];
    
        if (glassCount > 0) {
            if (glassCount == 1) {
                [UIView animateWithDuration:2.f delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [self.reduceButton setHidden:NO];
                    [self.cartNumLabel setHidden:NO];
                    self.reduceButtonLeading.constant = -46;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.cartNumLabel setText:[[NSNumber numberWithInteger:glassCount]stringValue]];
                    }
                }];
            }else{
                [self.cartNumLabel setText:[[NSNumber numberWithInteger:glassCount]stringValue]];
            }
        }
        
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


#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / self.jk_width;
    [self.imagePageControl setCurrentPage:currentPage];
}

@end
