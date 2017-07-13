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
        }
        self.productNameLabel.text = [NSString stringWithFormat:@"%@", _glasses.glassName];
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
    }
}

@end
