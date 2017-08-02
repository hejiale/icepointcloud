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
    
    __weak typeof (self) weakSelf = self;
    [self.imageScrollView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf showDetailAction];
    }];
    [self addSubview:self.imagePageControl];
    [self bringSubviewToFront:self.imagePageControl];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self resetBuyStatus];
        
        __block NSMutableArray<IPCGlassesImage *> * images = [[NSMutableArray alloc]init];
        
        if (_glasses.isTryOn && self.isTrying) {
            if ([_glasses imageWithType:IPCGlassesImageTypeFrontialNormal])
                [images addObject:[self.glasses imageWithType:IPCGlassesImageTypeFrontialNormal]];
            
            if ([_glasses imageWithType:IPCGlassesImageTypeProfileNormal])
                [images addObject:[self.glasses imageWithType:IPCGlassesImageTypeProfileNormal]];
        }else{
            if ([_glasses imageWithType:IPCGlassesImageTypeThumb]) {
                [images addObject:[self.glasses imageWithType:IPCGlassesImageTypeThumb]];
            }
        }
        
        __block CGFloat originX = (self.jk_width - 183)/2;
        
        [images enumerateObjectsUsingBlock:^(IPCGlassesImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             UIImageView * glassImageView = [[UIImageView alloc]initWithFrame:CGRectMake(idx*self.jk_width + originX, 20, 183, 112)];
             glassImageView.contentMode = UIViewContentModeScaleAspectFit;
             [glassImageView setImageWithURL:[NSURL URLWithString:obj.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
             [self.imageScrollView addSubview:glassImageView];
         }];
        
        [self.imageScrollView setContentSize:CGSizeMake(images.count * self.jk_width, 0)];
        [self.imageScrollView setContentOffset:CGPointZero];
        self.imagePageControl.numberOfPages = images.count;
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


- (void)showDetailAction{
    if ([self.delegate respondsToSelector:@selector(showProductDetail:)]) {
        [self.delegate showProductDetail:self];
    }
}


- (void)resetBuyStatus{
    [self.reduceButton setHidden:YES];
    [self.cartNumLabel setHidden:YES];
    [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / self.jk_width;
    [self.imagePageControl setCurrentPage:currentPage];
}

@end
