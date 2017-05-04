//
//  IPCCustomsizedGlassesCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/5/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedGlassesCell.h"

@implementation IPCCustomsizedGlassesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.productImageView setImageURL:[NSURL URLWithString:[_glasses imageWithType:IPCGlassesImageTypeThumb].imageURL]];
        [self.productNameLabel setText:_glasses.glassName];
        [self.productPriceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
    }
}

#pragma mark //Clicked Events
- (IBAction)addAction:(id)sender {
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.operationBottom.constant += 70;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)minusAction:(id)sender {
    
}

- (IBAction)plusAction:(id)sender {
    
}

- (IBAction)sureAction:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(confirmSelectGlass:)]) {
            [self.delegate confirmSelectGlass:self];
        }
    }
}

- (IBAction)cancelAction:(id)sender {
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.operationBottom.constant -= 70;
    } completion:^(BOOL finished) {
        
    }];
}

@end
