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
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;

@property (weak, nonatomic) IBOutlet UIView *batchNumView;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindNumLabel;



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
        
        if ([_cartItem.glasses filterType] == IPCTopFilterTypeLens && _cartItem.glasses.isBatch) {
            [self.parameterLabel setHidden:NO];
            if (_cartItem.batchSph.length && _cartItem.bacthCyl.length){
                [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@  柱镜/CYL: %@",_cartItem.batchSph,_cartItem.bacthCyl]];
            }
        }else if ([_cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass && _cartItem.glasses.isBatch){
            [self.parameterLabel setHidden:NO];
            if (_cartItem.batchReadingDegree.length){
                [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",_cartItem.batchReadingDegree]];
            }
        }else if (([_cartItem.glasses filterType] == IPCTopFilterTypeContactLenses && _cartItem.glasses.isBatch) || [_cartItem.glasses filterType] ==IPCTopFilterTypeAccessory && _cartItem.glasses.solutionType)
        {
            [self.batchNumView setHidden:NO];
            if (_cartItem.contactDegree.length && _cartItem.batchNum.length)
                [self.degreeLabel setText:[NSString stringWithFormat:@"度数: %@   批次号：%@",_cartItem.contactDegree,_cartItem.batchNum]];
            if (_cartItem.kindNum.length && _cartItem.validityDate.length){
                [self.kindNumLabel setText:[NSString stringWithFormat:@"准字号：%@  有效期：%@",_cartItem.kindNum,_cartItem.validityDate]];
            }
        }
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
        if ([IPCPayOrderMode sharedManager].employeeResultArray.count == 0) {
            [IPCCustomUI showError:@"请先选择员工"];
        }else{
            if ([[IPCPayOrderMode sharedManager] minimumEmployeeDiscountPrice:self.cartItem.glasses.price] > [str doubleValue]) {
                [IPCCustomUI showError:@"该商品售价超出折扣范围！"];
            }
            self.cartItem.unitPrice = [str doubleValue];
            
            [IPCPayOrderMode sharedManager].realTotalPrice = 0;
            [IPCPayOrderMode sharedManager].givingAmount = 0;
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

@end
