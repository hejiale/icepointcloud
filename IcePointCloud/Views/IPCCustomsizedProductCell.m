//
//  IPCCustomsizedProductCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedProductCell.h"

@implementation IPCCustomsizedProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomsizedProduct:(IPCCustomsizedProduct *)customsizedProduct{
    _customsizedProduct = customsizedProduct;
    
    if (_customsizedProduct) {
        [self.productImageView setImageURL:[NSURL URLWithString:_customsizedProduct.thumbnailURL]];
        
        CGFloat width = self.productContentView.jk_width/9;
        
        for (NSInteger i = 0 ; i < [self titlesArray].count; i++) {
            UIView * valueView = [[UIView alloc]initWithFrame:CGRectMake(width*i, 5, width, 40)];
            [self.productContentView addSubview:valueView];
            
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, valueView.jk_width, valueView.jk_height)];
            [titleLabel setTextColor:[UIColor darkGrayColor]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setText:[self titlesArray][i]];
            [titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
            [valueView addSubview:titleLabel];
            
            UILabel * valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,titleLabel.jk_bottom + 5 , valueView.jk_width-10, valueView.jk_height)];
            [valueLabel setTextColor:[UIColor darkGrayColor]];
            [valueLabel setTextAlignment:NSTextAlignmentCenter];
            [valueLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
            [valueLabel setText:[self valueArray][i]];
            [valueView addSubview:valueLabel];
        }
    }
}

- (NSArray *)titlesArray{
    return @[@"品牌",
             @"商品名",
             @"球镜范围",
             @"柱镜范围",
             @"折射率",
             @"膜层",
             @"材质",
             @"功能",
             @"零售价(￥)"];
}

- (NSArray *)valueArray{
    return @[self.customsizedProduct.brand,
             self.customsizedProduct.name,
             [NSString stringWithFormat:@"%@~%@",self.customsizedProduct.sphStart,self.customsizedProduct.sphEnd],
             [NSString stringWithFormat:@"%@~%@",self.customsizedProduct.cylStart,self.customsizedProduct.cylEnd],
             self.customsizedProduct.refraction,
             self.customsizedProduct.layer,
             self.customsizedProduct.material ? : @"",
             self.customsizedProduct.lensFunction ? : @"",
             [NSString stringWithFormat:@"%.f",self.customsizedProduct.suggestPrice]];
    
}

@end
