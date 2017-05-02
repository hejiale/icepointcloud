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
    
    [self.contentView addSubview:self.pointImageView];
    [self.contentView addSubview:self.suggestPriceLabel];
    [self.contentView addSubview:self.productNameLabel];
    
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).with.offset(19);
        make.top.equalTo(self.productImageView.mas_top).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(19);
    }];
    
    [self.pointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).with.offset(19);
        make.bottom.equalTo(self.productImageView.mas_bottom).with.offset(0);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.suggestPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).with.offset(32);
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
        [_suggestPriceLabel setTextColor:COLOR_RGB_RED];
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

- (UIImageView *)pointImageView{
    if (!_pointImageView) {
        _pointImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_pointImageView setImage:[UIImage imageNamed:@"icon_red_point"]];
        [_pointImageView setBackgroundColor:[UIColor clearColor]];
        _pointImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_pointImageView setHidden:YES];
    }
    return _pointImageView;
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        if ([_glasses filterType] != IPCTopFilterTypeCard) {
            [self.productImageView addBorder:3 Width:0.5];
        }
        [self.productImageView setImageWithURL:[NSURL URLWithString:_glasses.thumbnailURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
        [self.productNameLabel setText:_glasses.glassName];
        [self.countLabel setText:[NSString stringWithFormat:@"x %ld",(long)_glasses.productCount]];
        
        CGFloat  titleHeight = [self.productNameLabel.text boundingRectWithSize:CGSizeMake(self.productNameLabel.jk_width, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.productNameLabel.font} context:nil].size.height;
        self.productNameLabel.jk_height = titleHeight;
        
        if (glasses.integralExchange) {
            [self.pointImageView setHidden:NO];
            [self.suggestPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.productImageView.mas_right).with.offset(32);
            }];
            [self.suggestPriceLabel setText:[NSString stringWithFormat:@"%.f",glasses.exchangeIntegral]];
        }else{
            [self.pointImageView setHidden:YES];
            [self.suggestPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.productImageView.mas_right).with.offset(19);
            }];
            [self.suggestPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",glasses.afterDiscountPrice]];
        }
        
        CGFloat width = [self.suggestPriceLabel.text jk_widthWithFont:self.suggestPriceLabel.font constrainedToHeight:self.suggestPriceLabel.jk_height];
        self.suggestPriceLabel.jk_width = width + 5;
        
        if ((_glasses.afterDiscountPrice < glasses.price && !_glasses.integralExchange) || _glasses.integralExchange)
        {
            [self.contentView addSubview:self.productPriceLabel];
            
            NSString * priceText = [NSString stringWithFormat:@"￥%.2f",glasses.price];
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
