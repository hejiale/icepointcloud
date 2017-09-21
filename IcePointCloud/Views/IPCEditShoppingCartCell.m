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


@property (copy, nonatomic) void(^ReloadBlock)();

@end

@implementation IPCEditShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.glassesImgView addBorder:3 Width:0.5 Color:nil];
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
    if (gi)[self.glassesImgView sd_setImageWithURL:[NSURL URLWithString:[gi.imageURL stringByAppendingString:@"-320x160"]] placeholderImage:[UIImage imageNamed:@"default_placeHolder"]];
    
    self.glassesNameLbl.text = _cartItem.glasses.glassName;
    [self.cartCountLabel setText:[NSString stringWithFormat:@"%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]]];
    
    if (self.cartItem.glasses.isBatch || [self.cartItem.glasses filterType] == IPCTopFilterTypeCustomized)
    {
        [self.glassesNameLbl setText:@"参数设置"];
        [self.arrowImage setHidden:NO];
    }else{
        [self.arrowImage setHidden:YES];
        [self.glassesNameLbl setText:self.cartItem.glasses.glassName];
    }
}


- (IBAction)onMinusAction:(id)sender {
    if (self.cartItem.glassCount == 1) {
        [IPCCommonUI showAlert:@"冰点云" Message:@"确认要删除该商品吗?" Owner:[UIApplication sharedApplication].keyWindow.rootViewController Done:^{
            [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
            [[IPCPayOrderManager sharedManager] resetPayPrice];
            
            if (self.ReloadBlock) {
                self.ReloadBlock();
            }
        }];
    }else{
        [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
        [[IPCPayOrderManager sharedManager] resetPayPrice];
        
        if (self.ReloadBlock) {
            self.ReloadBlock();
        }
    }
}


- (IBAction)onPlusAction:(id)sender {
    [[IPCShoppingCart sharedCart] plusItem:self.cartItem];
    [[IPCPayOrderManager sharedManager] resetPayPrice];
    
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



- (IBAction)onChooseParameterAction:(id)sender {
    if (!self.arrowImage.isHidden) {
        if ([self.delegate respondsToSelector:@selector(chooseParameter:)]) {
            [self.delegate chooseParameter:self];
        }
    }
}

@end
