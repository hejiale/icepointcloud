//
//  ExpandableShoppingCartCell.m
//  IcePointCloud
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCExpandShoppingCartCell.h"

@interface IPCExpandShoppingCartCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UITextField *inputPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;

@property (copy, nonatomic) void(^ReloadBlock)();


@end

@implementation IPCExpandShoppingCartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.inputPriceTextField addBottomLine];
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload
{
    _cartItem = cartItem;
    
    if (_cartItem) {
        self.ReloadBlock = reload;
        
        IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
        if (gi)[self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
        
        self.glassesNameLbl.text = _cartItem.glasses.glassName;
        self.countLbl.text      = [NSString stringWithFormat:@"x%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
        [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", _cartItem.glasses.price]];
        
        if ([self.cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass && self.cartItem.glasses.isBatch){
            [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",self.cartItem.batchReadingDegree]];
        }else if (([self.cartItem.glasses filterType] == IPCTopFilterTypeLens || [self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses) && self.cartItem.glasses.isBatch){
            [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@  柱镜/CYL: %@",self.cartItem.batchSph,self.cartItem.bacthCyl]];
        }
        
        [self.inputPriceTextField setText:[NSString stringWithFormat:@"￥%.2f", _cartItem.unitPrice]];
    }
}

#pragma mark //UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsFloatNumber:string]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([str doubleValue] >= self.cartItem.glasses.price) {
            self.cartItem.unitPrice = self.cartItem.glasses.price;
        }else{
            self.cartItem.unitPrice = [str doubleValue];
        }
        self.cartItem.unitDiscount = 1;
    }
    
    if (self.ReloadBlock) {
        self.ReloadBlock();
    }
}

@end
