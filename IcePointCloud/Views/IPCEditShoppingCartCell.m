//
//  IPCEditShoppingCartCell.m
//  IcePointCloud
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCEditShoppingCartCell.h"

@interface IPCEditShoppingCartCell()

@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *cartCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *preSellImage;


@property (copy, nonatomic) void(^ReloadBlock)();

@end

@implementation IPCEditShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.glassesImgView addBorder:3 Width:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload
{
    _cartItem = cartItem;
    self.ReloadBlock = reload;
    
    [self.checkBtn setSelected:_cartItem.selected];
    
    IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
    if (gi)[self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
    
    self.glassesNameLbl.text = _cartItem.glasses.glassName;
    [self.cartCountLabel setText:[NSString stringWithFormat:@"%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]]];
    if ([self.cartItem.glasses filterType] == IPCTopFIlterTypeFrames || [self.cartItem.glasses filterType] == IPCTopFilterTypeSunGlasses) {
        [self.glassesNameLbl setText:self.cartItem.glasses.glassName];
        [self.arrowImage setHidden:YES];
    }else{
        [self.glassesNameLbl setText:@"参数设置"];
        [self.arrowImage setHidden:NO];
    }
    if (self.cartItem.isPreSell) {
        [self.preSellImage setHidden:NO];
    }else{
        [self.preSellImage setHidden:YES];
    }
}


- (IBAction)onMinusAction:(id)sender {
    if (self.cartItem.count == 1) {
        [IPCUIKit showAlert:@"冰点云" Message:@"确认要删除该商品吗?" Owner:[UIApplication sharedApplication].keyWindow.rootViewController Done:^{
            [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
            if (self.ReloadBlock) {
                self.ReloadBlock();
            }
        }];
    }else{
        [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
        if (self.ReloadBlock) {
            self.ReloadBlock();
        }
    }
}


- (IBAction)onPlusAction:(id)sender {
    if (([self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses && self.cartItem.glasses.isBatch) || ([self.cartItem.glasses filterType] == IPCTopFilterTypeAccessory && self.cartItem.glasses.solutionType))
    {
        //判断库存
    }else{
        [[IPCShoppingCart sharedCart] plusItem:self.cartItem];
    }
    if (self.ReloadBlock) {
        self.ReloadBlock();
    }
}

- (IBAction)onCheckBtnTapped:(id)sender{
    self.cartItem.selected = !self.cartItem.selected;
    if (self.ReloadBlock) {
        self.ReloadBlock();
    }
}


@end
