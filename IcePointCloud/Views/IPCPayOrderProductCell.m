//
//  IPCPayOrderProductCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/22.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderProductCell.h"

@interface IPCPayOrderProductCell()

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIImageView *preSellImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *glassNameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelWidthConstraint;

@end

@implementation IPCPayOrderProductCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.glassesImgView addBorder:3 Width:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem
{
    _cartItem = cartItem;
    
    if (_cartItem) {
        IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
        if (gi)[self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
        
        self.glassesNameLbl.text = _cartItem.glasses.glassName;
        self.countLbl.text      = [NSString stringWithFormat:@"x%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
        [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.f", _cartItem.unitPrice]];
        
        CGFloat priceWidth = [self.unitPriceLabel.text jk_sizeWithFont:self.unitPriceLabel.font constrainedToHeight:self.unitPriceLabel.jk_height].width;
        self.priceLabelWidthConstraint.constant = priceWidth + 5;
        
        if (self.cartItem.isPreSell) {
            [self.preSellImageView setHidden:NO];
        }else{
            [self.preSellImageView setHidden:YES];
        }
        
        CGFloat nameHeight = [self.glassesNameLbl.text jk_sizeWithFont:self.glassesNameLbl.font constrainedToWidth:self.glassesNameLbl.jk_width].height;
        
        if ((([self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [self.cartItem.glasses filterType] == IPCTopFilterTypeAccessory) && self.cartItem.glasses.isBatch) && !self.cartItem.isPreSell)
        {
            nameHeight = 20;
        }else{
            if (nameHeight <= 20) {
                nameHeight = 20;
            }else{
                nameHeight = 35;
            }
        }
        self.glassNameHeight.constant = nameHeight;
    }
}

@end
