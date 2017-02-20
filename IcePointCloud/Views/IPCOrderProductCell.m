//
//  OrderProductTableViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderProductCell.h"

@implementation IPCOrderProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.productImageView.layer.cornerRadius = 5;
    self.productImageView.layer.borderColor = [UIColor jk_colorWithHexString:@"#cccccc"].CGColor;
    self.productImageView.layer.borderWidth = 0.5;
    [self.contentView addSubview:self.suggestPriceLabel];
    [self.contentView addSubview:self.productNameLabel];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).with.offset(19);
        make.top.equalTo(self.productImageView.mas_top).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(19);
    }];
    
    [self.suggestPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).with.offset(19);
        make.bottom.equalTo(self.productImageView.mas_bottom).with.offset(0);
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
        [_suggestPriceLabel setTextColor:[UIColor darkGrayColor]];
        [_suggestPriceLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
    }
    return _suggestPriceLabel;
}

- (UILabel *)productPriceLabel{
    if (!_productPriceLabel) {
        _productPriceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_productPriceLabel setBackgroundColor:[UIColor clearColor]];
        [_productPriceLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        [_productPriceLabel setTextColor:[UIColor lightGrayColor]];
    }
    return _productPriceLabel;
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.productImageView setImageWithURL:[NSURL URLWithString:_glasses.thumbnailURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
        [self.productNameLabel setText:_glasses.glassName];
        [self.countLabel setText:[NSString stringWithFormat:@"x %ld",(long)_glasses.productCount]];
        
        CGFloat  titleHeight = [self.productNameLabel.text boundingRectWithSize:CGSizeMake(self.productNameLabel.jk_width, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.productNameLabel.font} context:nil].size.height;
        self.productNameLabel.jk_height = titleHeight;
        
        [self.suggestPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.prodPrice]];
        
        CGFloat width = [self.suggestPriceLabel.text jk_widthWithFont:self.suggestPriceLabel.font constrainedToHeight:self.suggestPriceLabel.jk_height];
        self.suggestPriceLabel.jk_width = width + 5;
        
        if (glasses.prodPrice < glasses.price) {
            [self.contentView addSubview:self.productPriceLabel];
            
            NSString * priceText = [NSString stringWithFormat:@"%.f",glasses.price];
            NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:priceText];
            [aAttributedString addAttribute:NSStrikethroughStyleAttributeName
                                      value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)
                                      range:NSMakeRange(0, priceText.length)];
            [self.productPriceLabel setAttributedText:aAttributedString];
            
            width = [priceText jk_widthWithFont:self.productPriceLabel.font constrainedToHeight:20];
            [self.productPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.suggestPriceLabel.mas_right).with.offset(5);
                make.bottom.equalTo(self.productImageView.mas_bottom).with.offset(0);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(20);
            }];
        }
        
        if ([_glasses filterType] == IPCTopFilterTypeLens && _glasses.isBatch) {
            if (_glasses.sph.length && _glasses.cyl.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@  柱镜/CYL: %@",_glasses.sph,_glasses.cyl]];
        }else if ([_glasses filterType] == IPCTopFilterTypeReadingGlass && _glasses.isBatch){
            if (_glasses.batchDegree.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",_glasses.batchDegree]];
        }else if (([_glasses filterType] == IPCTopFilterTypeContactLenses && _glasses.isBatch) || [_glasses filterType] ==IPCTopFilterTypeAccessory && _glasses.solutionType)
        {
            if ([_glasses filterType] ==IPCTopFilterTypeAccessory)
                self.degreeWidthConstraint.constant = 0;
            
            if (_glasses.batchDegree.length)
                [self.contactDegreeLabel setText:[NSString stringWithFormat:@"度数: %@",_glasses.batchDegree]];
            if (_glasses.batchNumber.length)
                [self.batchNumLabel setText:[NSString stringWithFormat:@"批次号：%@",_glasses.batchNumber]];
            if (_glasses.approvalNumber.length && _glasses.expireDate.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"准字号：%@  有效期：%@",_glasses.approvalNumber,_glasses.expireDate]];

        }
    }
}

@end
