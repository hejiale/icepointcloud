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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countNumHeight;
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;
@property (weak, nonatomic) IBOutlet UIView *batchNumView;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *noPointButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointButtonWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputPriceViewRight;



@end

@implementation IPCPayOrderProductCell

- (void)awakeFromNib
{
    [super awakeFromNib];

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

        if ([_cartItem.glasses filterType] == IPCTopFilterTypeCard)
        {
            [self.countNumView setHidden:NO];
        }else{
            [self.countLabel setHidden:NO];
        }
        
        if ([IPCPayOrderManager sharedManager].isTrade) {
            self.pointButtonWith.constant = 0;
            self.inputPriceViewRight.constant = 0;
            [self.inputPriceTextField setLeftImageView:@"icon_pricetype"];
            [self.inputPriceTextField setText:[NSString stringWithFormat:@"%.2f", _cartItem.unitPrice]];
        }else{
            [self.noPointButton setHidden:NO];
            self.pointButtonWith.constant = 130;
            self.inputPriceViewRight.constant = 20;
            
            if (_cartItem.isChoosePoint) {
                [self.inputPriceTextField setLeftImageView:@"icon_pointtype"];
                [self.inputPriceTextField setText:[NSString stringWithFormat:@"%d", _cartItem.pointValue]];
            }else{
                [self.noPointButton setSelected:NO];
                [self.inputPriceTextField setLeftImageView:@"icon_pricetype"];
                [self.inputPriceTextField setText:[NSString stringWithFormat:@"%.2f", _cartItem.unitPrice]];
            }
        }
        
        IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
        if (gi){
            [self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
        }
        self.glassesNameLbl.text = _cartItem.glasses.glassName;
        [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", _cartItem.glasses.price]];
        [self.countLabel setText:[NSString stringWithFormat:@"x%d",_cartItem.glassCount]];
        [self.inputCountLabel setText:[NSString stringWithFormat:@"%d",_cartItem.glassCount]];
        
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
        }else if ([_cartItem.glasses filterType] == IPCTopFilterTypeContactLenses && _cartItem.glasses.isBatch)
        {
            [self.batchNumView setHidden:NO];
            if (_cartItem.contactDegree.length && _cartItem.batchNum.length)
                [self.degreeLabel setText:[NSString stringWithFormat:@"度数: %@   批次号：%@",_cartItem.contactDegree,_cartItem.batchNum]];
            if (_cartItem.kindNum.length && _cartItem.validityDate.length){
                [self.kindNumLabel setText:[NSString stringWithFormat:@"准字号：%@  有效期：%@",_cartItem.kindNum,_cartItem.validityDate]];
            }
        }else if ([_cartItem.glasses filterType] ==IPCTopFilterTypeAccessory && _cartItem.glasses.solutionType){
            [self.batchNumView setHidden:NO];
            if (_cartItem.batchNum.length)
                [self.degreeLabel setText:[NSString stringWithFormat:@"批次号：%@",_cartItem.batchNum]];
            if (_cartItem.kindNum.length && _cartItem.validityDate.length){
                [self.kindNumLabel setText:[NSString stringWithFormat:@"准字号：%@  有效期：%@",_cartItem.kindNum,_cartItem.validityDate]];
            }
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)reduceCartNumAction:(id)sender {
    self.cartItem.glassCount--;
    if (self.cartItem.glassCount <= 1) {
        self.cartItem.glassCount = 1;
    }
    self.cartItem.pointValue = 0;
    if (self.cartItem.isChoosePoint) {
        [IPCPayOrderManager sharedManager].pointPrice = 0;
        [IPCPayOrderManager sharedManager].usedPoint = 0;
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IBAction)plusCartNumAction:(id)sender {
    self.cartItem.glassCount++;
    self.cartItem.pointValue = 0;
    if (self.cartItem.isChoosePoint) {
        [IPCPayOrderManager sharedManager].pointPrice = 0;
        [IPCPayOrderManager sharedManager].usedPoint = 0;
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IBAction)noPointAction:(UIButton *)sender {
    if ( ![IPCCurrentCustomer sharedManager].currentCustomer) {
        [IPCCustomUI showError:@"请先选择客户!"];
        return;
    }
    if ([IPCPayOrderManager sharedManager].point <= 0) {
        [IPCCustomUI showError:@"所选客户积分为零!"];
        return;
    }
    [sender setSelected:!sender.selected];
    self.cartItem.isChoosePoint = sender.selected;
    
    if (sender.selected) {
        self.cartItem.unitPrice = 0;
        [IPCPayOrderManager sharedManager].realTotalPrice = 0;
        [IPCPayOrderManager sharedManager].givingAmount = 0;
    }else{
        [IPCPayOrderManager sharedManager].usedPoint -= self.cartItem.pointValue * self.cartItem.glassCount;
        if ([IPCPayOrderManager sharedManager].usedPoint <= 0) {
            [IPCPayOrderManager sharedManager].usedPoint = 0;
        }
        [IPCPayOrderManager sharedManager].pointPrice -= self.cartItem.pointPrice;
        if ([IPCPayOrderManager sharedManager].pointPrice <= 0) {
            [IPCPayOrderManager sharedManager].pointPrice = 0;
        }
        self.cartItem.pointValue = 0;
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}


#pragma mark //UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.cartItem.isChoosePoint) {
        if (![IPCCommon judgeIsIntNumber:string]) {
            return NO;
        }
    }else{
        if (![IPCCommon judgeIsFloatNumber:string]) {
            return NO;
        }
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
        if (self.cartItem.isChoosePoint) {
            NSInteger usedPoint = [IPCPayOrderManager sharedManager].usedPoint;
            usedPoint -= self.cartItem.pointValue;
            NSInteger minumPoint = [IPCPayOrderManager sharedManager].point - usedPoint;
            
            if (minumPoint > 0) {
                if (minumPoint <= [str doubleValue] * self.cartItem.glassCount)
                {
                    self.cartItem.pointValue = minumPoint/self.cartItem.glassCount;
                }else{
                    self.cartItem.pointValue = [str integerValue];
                }
                self.cartItem.pointPrice = self.cartItem.totalPrice;
                
                [IPCPayOrderManager sharedManager].usedPoint = [[IPCShoppingCart sharedCart] totalUsedPoint];
                [IPCPayOrderManager sharedManager].pointPrice = [[IPCShoppingCart sharedCart] totalUsedPointPrice];
            }
        }else{
            if ([IPCPayOrderManager sharedManager].employeeResultArray.count == 0) {
                [IPCCustomUI showError:@"请先选择员工"];
            }else{
                if ( [self.cartItem.glasses filterType] != IPCTopFilterTypeCard) {
                    if ([[IPCPayOrderManager sharedManager] minimumEmployeeDiscountPrice:self.cartItem.glasses.price] > [str doubleValue]) {
                        [IPCCustomUI showError:@"该商品售价超出折扣范围！"];
                    }
                }
                self.cartItem.unitPrice = [str doubleValue];
                
                [IPCPayOrderManager sharedManager].realTotalPrice = 0;
                [IPCPayOrderManager sharedManager].givingAmount = 0;
                [IPCPayOrderManager sharedManager].remainAmount = 0;
                [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
            }
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}


@end
