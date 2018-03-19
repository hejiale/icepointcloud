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
    
    [self.leftContentView addRightLine];
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
            [self.productImageView setImageWithURL:[NSURL URLWithString:gp.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
        }

        [self.productNameLabel setSpaceWithText:_glasses.glassName LineSpace:5 WordSpace:0];
        
        CGFloat height = [self.productNameLabel.text jk_sizeWithFont:self.productNameLabel.font constrainedToWidth:self.productNameLabel.jk_width].height;
        self.nameHeightConstraint.constant = height+5;
        
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.suggestPrice]];
        
        __block CGFloat orignX = self.baseTitleLabel.jk_left;
        __block CGFloat orignY = self.baseTitleLabel.jk_bottom + 20 + height;
        __block CGFloat lblWidth = self.rightContentView.jk_width - orignX - 120;
        __block CGFloat totalHeight = 0;
        
        NSDictionary * fileds = [self.glasses displayFields];
        [fileds.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            UIView * specHostView = [[UIView alloc]initWithFrame:CGRectMake(orignX, idx *40 + orignY, self.rightContentView.jk_width-orignX, 40)];
            [specHostView setBackgroundColor:[UIColor clearColor]];
            [self.rightContentView addSubview:specHostView];
            
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
            titleLabel.text = [NSString stringWithFormat:@"%@", obj];
            [specHostView addSubview:titleLabel];
            
            UILabel * valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.jk_right + 20, 0, lblWidth, 30)];
            valueLabel.textAlignment = NSTextAlignmentLeft;
            valueLabel.textColor = [UIColor colorWithHexString:@"#8C8C8C"];
            valueLabel.backgroundColor = [UIColor clearColor];
            valueLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
            valueLabel.text = [NSString stringWithFormat:@"%@", fileds[obj]];
            [specHostView addSubview:valueLabel];
            
            totalHeight += 40;
        }];
        
        if (_glasses.isTryOn) {
            [self.tryButton setHidden:NO];
            self.tryTopConstant.constant += (totalHeight + 50);
        }else{
            self.tryTopConstant.constant += totalHeight;
        }
        
        if (self.glasses.detailLinkURl.length) {
            [self.showMoreButton setHidden:NO];
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
}



- (IBAction)tryGlassesAction:(id)sender {
}


- (IBAction)showMoreAction:(id)sender {
}

@end
