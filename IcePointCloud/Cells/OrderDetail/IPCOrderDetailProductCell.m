//
//  OrderProductTableViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderDetailProductCell.h"

@implementation IPCOrderDetailProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.productContentView addSubview:self.productPriceLabel];
    [self.productContentView addSubview:self.suggestPriceLabel];
    [self.productContentView addSubview:self.productNameLabel];
    [self.productImageView addBorder:3 Width:0.5 Color:nil];
    
    [self.productPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView.mas_top).with.offset(0);
        make.right.equalTo(self.productContentView.mas_right).with.offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).with.offset(10);
        make.top.equalTo(self.productImageView.mas_top).with.offset(0);
        make.right.equalTo(self.productPriceLabel.mas_left).with.offset(0);
    }];
    
    [self.suggestPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.productImageView.mas_bottom).with.offset(0);
        make.right.equalTo(self.countLabel.mas_left).with.offset(0);
        make.height.mas_equalTo(20);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark //Set UI
- (UILabel *)productNameLabel{
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_productNameLabel setBackgroundColor:[UIColor clearColor]];
        [_productNameLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        [_productNameLabel setTextColor:[UIColor darkGrayColor]];
        _productNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _productNameLabel.numberOfLines = 2;
    }
    return _productNameLabel;
}


- (UILabel *)suggestPriceLabel{
    if (!_suggestPriceLabel) {
        _suggestPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_suggestPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_suggestPriceLabel setTextColor:COLOR_RGB_RED];
        [_suggestPriceLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _suggestPriceLabel;
}

- (UILabel *)productPriceLabel{
    if (!_productPriceLabel) {
        _productPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_productPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_productPriceLabel setFont:[UIFont systemFontOfSize:13]];
        [_productPriceLabel setTextColor:[UIColor lightGrayColor]];
        [_productPriceLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _productPriceLabel;
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.productImageView setImageWithURL:[NSURL URLWithString:_glasses.thumbnailURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
        [self.productNameLabel setText:_glasses.glassName];
        [self.countLabel setText:[NSString stringWithFormat:@"x %ld",(long)_glasses.productCount]];
        [self.productPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",glasses.suggestPrice]];
        [self.suggestPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",glasses.afterDiscountPrice]];
    
        if (([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses) && _glasses.isBatch) {
            if (_glasses.sph.length && _glasses.cyl.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@  柱镜/CYL: %@",_glasses.sph,_glasses.cyl]];
        }else if ([_glasses filterType] == IPCTopFilterTypeReadingGlass && _glasses.isBatch){
            if (_glasses.batchDegree.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",_glasses.batchDegree]];
        }
    }
}


@end
