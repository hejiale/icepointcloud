//
//  ProductInfoDetailTableViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCProductDetailTableViewCell.h"

@implementation IPCProductDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        IPCGlassesImage *gp = [_glasses imageWithType:IPCGlassesImageTypeThumb];
        if (gp){
            [self.productImageView setImageURL:gp.imageURL];
            
            if (gp.width > 0 && gp.height > 0) {
                __block CGFloat maxWidth = 512;
                __block CGFloat maxHeight = 270;
                
                __block CGFloat scale = maxWidth / gp.width;
                if (scale * gp.height > maxHeight)
                    scale = maxHeight / gp.height;
            }
        }
        self.productNameLabel.text = [NSString stringWithFormat:@"%@  ￥%.f", _glasses.glassName, _glasses.price];
    }
}

- (void)setCustomsizedProduct:(IPCCustomsizedProduct *)customsizedProduct{
    _customsizedProduct = customsizedProduct;
    
    if (_customsizedProduct) {
        self.productNameLabel.text = [NSString stringWithFormat:@"%@  ￥%.f", _customsizedProduct.name, _customsizedProduct.suggestPrice];
        [self.productImageView setImageURL:[NSURL URLWithString:_customsizedProduct.thumbnailURL]];
    }
}



@end
