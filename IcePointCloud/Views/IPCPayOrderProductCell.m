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
        if (gi){
            [self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
        }
        self.glassesNameLbl.text = _cartItem.glasses.glassName;
        [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.f", _cartItem.unitPrice]];
    }
}

@end
