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
        [self reloadParameterLabelStatus];
        
        if ([_cartItem.glasses filterType] == IPCTopFilterTypeLens) {
            if (_cartItem.batchSph.length && _cartItem.bacthCyl.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH:  %@   柱镜/CYL:  %@",_cartItem.batchSph,_cartItem.bacthCyl]];
        }else if ([_cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass){
            if (_cartItem.batchReadingDegree.length)
                [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",_cartItem.batchReadingDegree]];
        }
        else if([_cartItem.glasses filterType] == IPCTopFilterTypeContactLenses){
            if (_cartItem.contactDegree.length){
                [self.degreeLabel setText:[NSString stringWithFormat:@"度数: %@",_cartItem.contactDegree]];
            }
        }
        [self.cartNumLabel setText:[[NSNumber numberWithInteger:_cartItem.glassCount]stringValue]];
    }
}


- (void)reloadAddButtonStatus:(BOOL)hasStock{
    [self.addButton setUserInteractionEnabled:YES];
    
    if (hasStock) {
        [self.addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    }else{
        [self.addButton setImage:[UIImage imageNamed:@"icon_add_disable"] forState:UIControlStateNormal];
        if ([_cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [_cartItem.glasses filterType] == IPCTopFilterTypeAccessory)
            [self.addButton setUserInteractionEnabled:hasStock];
    }
}

- (void)reloadParameterLabelStatus{
    if ([_cartItem.glasses filterType] == IPCTopFilterTypeLens || [_cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [self.parameterLabel setHidden:NO];
        //        self.batchHeight.constant = 0;
        self.degreeHeight.constant = 0;
    }
    //    else{
    //        [self.degreeLabel setHidden:NO];
    //        [self.batchNumLabel setHidden:NO];
    //        [self.kindNumLabel setHidden:NO];
    //        self.batchHeight.constant = 20;
    //        self.degreeHeight.constant = 20;
    //
    //        if ([_cartItem.glasses filterType] == IPCTopFilterTypeAccessory) {
    //            self.degreeWidthConstraint.constant = 0;
    //        }
    //    }
}

#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
    [[IPCShoppingCart sharedCart] plusItem:self.cartItem];
    if (self.ReloadBlcok)self.ReloadBlcok();
}


- (IBAction)reduceCartAction:(id)sender {
    NSInteger cartNum = [self.cartNumLabel.text integerValue];
    cartNum--;
    
    if (cartNum == 0) {
        [[IPCShoppingCart sharedCart] removeItem:self.cartItem];
    }else{
        [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
    }
    if (self.ReloadBlcok)self.ReloadBlcok();
}


@end
