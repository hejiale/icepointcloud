//
//  IPCPayOrderProductCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/22.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderProductCell.h"

@interface IPCPayOrderProductCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *inputPirceView;
@property (weak, nonatomic) IBOutlet UITextField *inputPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *inputCountLabel;


@property (weak, nonatomic) IBOutlet UIView *countNumView;



@end

@implementation IPCPayOrderProductCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];

    [self.inputPriceTextField addBorder:3 Width:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem
{
    _cartItem = cartItem;
    
    if (_cartItem) {
        if ([_cartItem.glasses filterType] != IPCTopFilterTypeCard) {
            [self.glassesImgView addBorder:3 Width:0.5];
        }
        if ([_cartItem.glasses filterType] == IPCTopFilterTypeCard) {
            [self.countNumView setHidden:NO];
        }else{
            [self.inputPirceView setHidden:NO];
        }
        
        IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
        if (gi){
            [self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
        }
        self.glassesNameLbl.text = _cartItem.glasses.glassName;
        [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", _cartItem.glasses.price]];
        [self.countLabel setText:[NSString stringWithFormat:@"X%d",_cartItem.count]];
        [self.inputCountLabel setText:[NSString stringWithFormat:@"%d",_cartItem.count]];
        [self.inputPriceTextField setText:[NSString stringWithFormat:@"%.2f", _cartItem.unitPrice]];
    }
}

#pragma mark //Clicked Events
- (IBAction)reduceCartNumAction:(id)sender {
    self.cartItem.count--;
    if (self.cartItem.count <= 1) {
        self.cartItem.count = 1;
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IBAction)plusCartNumAction:(id)sender {
    self.cartItem.count++;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}


#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([[IPCPayOrderMode sharedManager] minimumEmployeeDiscountPrice:self.cartItem.glasses.price] > [str doubleValue]) {
            [IPCCustomUI showError:@"该商品售价超出折扣范围！"];
        }
        self.cartItem.unitPrice = [str doubleValue];
        
        [IPCPayOrderMode sharedManager].realTotalPrice = 0;
        [IPCPayOrderMode sharedManager].givingAmount = 0;
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

@end
