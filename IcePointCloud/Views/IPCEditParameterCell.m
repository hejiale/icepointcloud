//
//  EditParameterCell.m
//  IcePointCloud
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditParameterCell.h"

@interface IPCEditParameterCell()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *degreeWidthConstraint;

@property (copy, nonatomic) IPCShoppingCartItem * cartItem;
@property (copy, nonatomic) void(^ReloadBlcok)();

@end

@implementation IPCEditParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void (^)())reload
{
    _cartItem = cartItem;
    self.ReloadBlcok = reload;
    
    if (_cartItem) {        
        if ([_cartItem.glasses filterType] == IPCTopFilterTypeLens || [_cartItem.glasses filterType] == IPCTopFilterTypeContactLenses) {
            if (_cartItem.batchSph.length && _cartItem.bacthCyl.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH:  %@   柱镜/CYL:  %@",_cartItem.batchSph,_cartItem.bacthCyl]];
        }else if ([_cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass){
            if (_cartItem.batchReadingDegree.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",_cartItem.batchReadingDegree]];
        }
      
        [self.cartNumLabel setText:[[NSNumber numberWithInteger:_cartItem.glassCount]stringValue]];
    }
}


#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
    [[IPCShoppingCart sharedCart] plusItem:self.cartItem];
    if (self.ReloadBlcok)
        self.ReloadBlcok();
}


- (IBAction)reduceCartAction:(id)sender {
    NSInteger cartNum = [self.cartNumLabel.text integerValue];
    cartNum--;
    
    if (cartNum <= 0) {
        [[IPCShoppingCart sharedCart] removeItem:self.cartItem];
    }else{
        [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
    }
    if (self.ReloadBlcok)
        self.ReloadBlcok();
}


@end
