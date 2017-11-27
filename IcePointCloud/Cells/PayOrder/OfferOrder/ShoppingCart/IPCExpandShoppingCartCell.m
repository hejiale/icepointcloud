//
//  ExpandableShoppingCartCell.m
//  IcePointCloud
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCExpandShoppingCartCell.h"
#import "IPCCustomTextField.h"

@interface IPCExpandShoppingCartCell()<IPCCustomTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;


@end

@implementation IPCExpandShoppingCartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.mainContentView addSubview:self.inputPriceTextField];
  
    [[IPCTextFiledControl instance] addTextField:self.inputPriceTextField];
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem
{
    _cartItem = cartItem;
    
    if (_cartItem) {
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

- (IPCCustomTextField *)inputPriceTextField
{
    if (!_inputPriceTextField) {
        _inputPriceTextField = [[IPCCustomTextField alloc]initWithFrame:CGRectMake(self.glassesImgView.jk_right+10, self.glassesImgView.jk_bottom-30, 150, 30)];
        _inputPriceTextField.clearOnEditing = YES;
        [_inputPriceTextField setDelegate:self];
    }
    return _inputPriceTextField;
}

#pragma mark //UITextField Delegate
- (void)textFieldPreEditing:(IPCCustomTextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(preEditing:)]) {
        [self.delegate preEditing:self];
    }
}

- (void)textFieldNextEditing:(IPCCustomTextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(nextEditing:)]) {
        [self.delegate nextEditing:self];
    }
}

- (void)textFieldEndEditing:(IPCCustomTextField *)textField
{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([str doubleValue] >= self.cartItem.glasses.price) {
            self.cartItem.unitPrice = self.cartItem.glasses.price;
        }else{
            self.cartItem.unitPrice = [str doubleValue];
        }
        self.cartItem.unitDiscount = 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(endEditing:)]) {
        [self.delegate endEditing:self];
    }
}

@end
