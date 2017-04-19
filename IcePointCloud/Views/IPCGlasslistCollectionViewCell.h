//
//  GlasslistCollectionViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GlasslistCollectionViewCellDelegate;

@interface IPCGlasslistCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *cartNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reduceButtonLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property (strong, nonatomic) UIPageControl * imagePageControl;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIImageView *customsizedImageView;


@property (nonatomic, weak) IPCGlasses *glasses;
@property (nonatomic, weak) IPCCustomsizedProduct *customsizedProduct;

@property (nonatomic) BOOL  isTrying;//Whether to try the page
@property (weak, nonatomic) id<GlasslistCollectionViewCellDelegate>delegate;

@end

@protocol GlasslistCollectionViewCellDelegate <NSObject>

@optional
- (void)chooseParameter:(IPCGlasslistCollectionViewCell *)cell;
- (void)editBatchParameter:(IPCGlasslistCollectionViewCell *)cell;
- (void)addShoppingCartAnimation:(IPCGlasslistCollectionViewCell *)cell;
- (void)showProductDetail:(IPCGlasslistCollectionViewCell *)cell;
- (void)reloadProductList;
- (void)buyValueCard:(IPCGlasslistCollectionViewCell *)cell;

@end
