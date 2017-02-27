//
//  ShoppingCartView.m
//  IcePointCloud
//
//  Created by mac on 2017/2/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCShoppingCartView.h"
#import "IPCCartViewMode.h"
#import "IPCCartItemViewCellMode.h"

typedef  void(^DismissBlock)();

@interface IPCShoppingCartView ()<UITableViewDelegate,UITableViewDataSource,IPCCartItemViewCellModeDelegate>
{
    BOOL   isEditStatus;
}
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *cartListTableView;
@property (weak, nonatomic) IBOutlet UIButton *settlementButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIView *cartBottomView;
@property (copy, nonatomic) DismissBlock dismissBlock;
@property (strong, nonatomic) IPCCartViewMode    *cartViewMode;
@property (strong, nonatomic) IPCCartItemViewCellMode * cartItemViewCellMode;

@end

@implementation IPCShoppingCartView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.settlementButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.cartListTableView setTableFooterView:[[UIView alloc]init]];
    self.cartListTableView.emptyAlertImage = @"exception_cart";
    self.cartListTableView.emptyAlertTitle = @"您的购物车空空的,请前去选取眼镜!";
    [self.cartBottomView addTopLine];
}

- (void)show
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x -= self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self commitUI];
    }];
}

- (void)commitUI{
    self.cartViewMode = [[IPCCartViewMode alloc]init];
    self.cartItemViewCellMode = [[IPCCartItemViewCellMode alloc]init];
    self.cartItemViewCellMode.delegate = self;
    [self updateCartUI];
    [[IPCClient sharedClient] cancelAllRequest];
    [self.cartViewMode reloadContactLensStock];
}

- (void)updateTotalPrice{
    [self.totalPriceLabel setAttributedText:[IPCUIKit subStringWithText:[NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]] BeginRang:0 Rang:3 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:[UIColor blackColor]]];
    [self.navigationTitleLabel setText:[NSString stringWithFormat:@"购物车 (%d)",(long)[[IPCShoppingCart sharedCart] selectedGlassesCount]]];
}


#pragma mark //Clicked Methods
- (IBAction)onEditAction:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [self.settlementButton setHidden:sender.selected];
    [self.deleteButton setHidden:!sender.selected];
    isEditStatus = sender.selected;
    [self updateCartUI];
}

- (IBAction)onSettlementAction:(id)sender {
    
}

- (IBAction)onSelectAllAction:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [self.cartViewMode changeAllCartItemSelected:sender.selected];
    [self updateCartUI];
}


- (IBAction)onDeleteProductsAction:(id)sender {
    __weak typeof (self) weakSelf = self;
    if (! [self.cartViewMode shoppingCartIsEmpty]) {
        [IPCUIKit showAlert:@"冰点云" Message:@"您确定要删除所选商品吗?" Owner:[UIApplication sharedApplication].keyWindow.rootViewController Done:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [[IPCShoppingCart sharedCart] removeSelectCartItem];
            [strongSelf updateCartUI];
        }];
    }else{
        [IPCUIKit showError:@"未选中任何商品!"];
    }
}

- (void)updateCartUI{
    [self updateTotalPrice];
    [self.selectAllButton setSelected:[self.cartViewMode judgeCartItemSelectState]];
    [self.settlementButton setTitle:[NSString stringWithFormat:@"结算(%d)",[[IPCShoppingCart sharedCart] selectedGlassesCount]] forState:UIControlStateNormal];
    [self.cartListTableView reloadData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cartItemViewCellMode tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [self.cartItemViewCellMode tableView:tableView cellForRowAtIndexPath:indexPath IsEditState:isEditStatus];
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

#pragma mark //IPCCartItemViewCellModeDelegate
- (void)reloadShoppingCartUI{
    [self updateCartUI];
}

@end
