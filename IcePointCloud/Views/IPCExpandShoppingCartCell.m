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
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *glassNameHeight;
@property (weak, nonatomic) IBOutlet UIButton *noPointButton;
@property (weak, nonatomic) IBOutlet UIView *inputPirceView;
@property (weak, nonatomic) IBOutlet UITextField *inputPriceTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointButtonWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputPriceViewRight;
@property (copy, nonatomic) void(^ReloadBlock)();


@end

@implementation IPCExpandShoppingCartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.inputPirceView addBorder:3 Width:0.5];
    [self.glassesImgView addBorder:3 Width:0.5];
}



- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload
{
    _cartItem = cartItem;
    
    if (_cartItem) {
        self.ReloadBlock = reload;
        [self.checkBtn setSelected:_cartItem.selected];
        
        IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
        if (gi)[self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
        
        self.glassesNameLbl.text = _cartItem.glasses.glassName;
        self.countLbl.text      = [NSString stringWithFormat:@"x%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
        [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.f", _cartItem.glasses.price]];
        
        CGFloat nameHeight = [self.glassesNameLbl.text jk_sizeWithFont:self.glassesNameLbl.font constrainedToWidth:self.glassesNameLbl.jk_width].height;
        if (([self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [self.cartItem.glasses filterType] == IPCTopFilterTypeAccessory) && self.cartItem.glasses.isBatch)
        {
            nameHeight = 20;
        }
        self.glassNameHeight.constant = nameHeight;
        [self loadContactLensBatchSpecification:nameHeight];
        
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
    }
}


#pragma mark //Set UI
- (void)loadContactLensBatchSpecification:(CGFloat)height{
    UIView * specificationView = [[UIView alloc]initWithFrame:CGRectMake(self.glassesImgView.jk_right + 10, self.glassesNameLbl.jk_top+height+10, self.jk_width - self.glassesImgView.jk_right - 10, 30)];
    [self.mainContentView addSubview:specificationView];
    
    if ([self.cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass && self.cartItem.glasses.isBatch)
    {
        UILabel * degreeLabel = [[UILabel alloc]initWithFrame:specificationView.bounds];
        [degreeLabel setText:[NSString stringWithFormat:@"度数: %@",self.cartItem.batchReadingDegree]];
        [degreeLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        [degreeLabel setTextColor:[UIColor lightGrayColor]];
        [specificationView addSubview:degreeLabel];
    }else if ([self.cartItem.glasses filterType] == IPCTopFilterTypeLens && self.cartItem.glasses.isBatch){
        UILabel * sphLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, specificationView.jk_width/2, 20)];
        [sphLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@",self.cartItem.batchSph]];
        [sphLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        [sphLabel setTextColor:[UIColor lightGrayColor]];
        [specificationView addSubview:sphLabel];
        
        UILabel * cylLabel = [[UILabel alloc]initWithFrame:CGRectMake(sphLabel.jk_right, 0, specificationView.jk_width/2, 20)];
        [cylLabel setText:[NSString stringWithFormat:@"柱镜/CYL: %@",self.cartItem.bacthCyl]];
        [cylLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        [cylLabel setTextColor:[UIColor lightGrayColor]];
        [specificationView addSubview:cylLabel];
    }else if ([self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses && self.cartItem.glasses.isBatch){
        UILabel * degreeLabel = [[UILabel alloc]initWithFrame:specificationView.bounds];
        [degreeLabel setText:[NSString stringWithFormat:@"度数: %@",self.cartItem.contactDegree]];
        [degreeLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        [degreeLabel setTextColor:[UIColor lightGrayColor]];
        [specificationView addSubview:degreeLabel];
    }
}


#pragma mark //Clicked Events
- (IBAction)onCheckBtnTapped:(id)sender{
    self.cartItem.selected = !self.cartItem.selected;
    if (self.ReloadBlock) {
        self.ReloadBlock();
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
    if (self.ReloadBlock) {
        self.ReloadBlock();
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
                if ([[IPCPayOrderManager sharedManager] minimumEmployeeDiscountPrice:self.cartItem.glasses.price] > [str doubleValue]) {
                    [IPCCustomUI showError:@"该商品售价超出折扣范围！"];
                }
                self.cartItem.unitPrice = [str doubleValue];
                
                [IPCPayOrderManager sharedManager].realTotalPrice = 0;
                [IPCPayOrderManager sharedManager].givingAmount = 0;
                [IPCPayOrderManager sharedManager].remainAmount = 0;
                [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
            }
        }
    }
    
    if (self.ReloadBlock) {
        self.ReloadBlock();
    }
}

@end
