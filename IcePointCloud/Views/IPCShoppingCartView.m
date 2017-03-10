//
//  ShoppingCartView.m
//  IcePointCloud
//
//  Created by mac on 2017/2/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCShoppingCartView.h"
#import "IPCCartViewMode.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCEditShoppingCartCell.h"
#import "IPCGlassParameterView.h"

static NSString * const kNewShoppingCartItemName = @"ExpandableShoppingCartCellIdentifier";
static NSString * const kEditShoppingCartCellIdentifier = @"IPCEditShoppingCartCellIdentifier";

typedef  void(^PayBlock)();

@interface IPCShoppingCartView ()<UITableViewDelegate,UITableViewDataSource,IPCEditShoppingCartCellDelegate>
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
@property (strong, nonatomic) UIView * coverView;
@property (copy, nonatomic) PayBlock payBlock;
@property (strong, nonatomic) IPCCartViewMode    *cartViewMode;
@property (strong, nonatomic) IPCGlassParameterView * parameterView;

@end

@implementation IPCShoppingCartView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addLeftLine];
    [self.settlementButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.cartListTableView setTableFooterView:[[UIView alloc]init]];
    self.cartListTableView.emptyAlertImage = @"exception_cart";
    self.cartListTableView.emptyAlertTitle = @"您的购物车空空的,请前去选取眼镜!";
    [self.cartBottomView addTopLine];
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.bounds];
        [_coverView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.2]];
    }
    return _coverView;
}

- (void)showWithPay:(void (^)())pay
{
    self.payBlock = pay;
    
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
    __weak typeof (self) weakSelf = self;
    if ( ! [self.cartViewMode shoppingCartIsEmpty]){
        if (self.payBlock) {
            self.payBlock();
        }
    }else{
        [IPCUIKit showError:@"购物车中未选中任何商品!"];
    }
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
    return  [[IPCShoppingCart sharedCart] itemsCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isEditStatus) {
        IPCEditShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kEditShoppingCartCellIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCEditShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
        if (cartItem) {
            [cell setCartItem:cartItem Reload:^{
                [self updateCartUI];
            }];
        }
        return cell;
    }else{
        IPCExpandShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kNewShoppingCartItemName];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCExpandShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
        
        if (cartItem){
            [cell setCartItem:cartItem Reload:^{
                [self updateCartUI];
            }];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

#pragma mark //IPCEditShoppingCartCellDelegate
- (void)chooseParameter:(IPCEditShoppingCartCell *)cell{
    [self addSubview:self.coverView];
    
    NSIndexPath * indexPath = [self.cartListTableView indexPathForCell:cell];
    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
    
    _parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
        [_parameterView removeFromSuperview];
        [self.coverView removeFromSuperview];
    }];
    _parameterView.cartItem = cartItem;
    [[UIApplication sharedApplication].keyWindow addSubview:_parameterView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_parameterView];
    [_parameterView show];
}

- (void)judgeStock:(IPCEditShoppingCartCell *)cell{
    NSIndexPath * indexPath = [self.cartListTableView indexPathForCell:cell];
    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
    if (cartItem) {
        if ([cartItem.glasses filterType] == IPCTopFilterTypeAccessory) {
            [self.cartViewMode queryAccessoryStock:cartItem Complete:^(BOOL hasStock) {
                if (! hasStock) {
                    [IPCUIKit showError:@"当前选择护理液数量大于库存数"];
                }else{
                    [[IPCShoppingCart sharedCart] plusItem:cartItem];
                    [self updateCartUI];
                }
            }];
        }else{
            if ([self.cartViewMode judgeContactLensStock:cartItem]) {
                [IPCUIKit showError:@"当前选择隐形眼镜镜片数量大于库存数"];
            }else{
                [[IPCShoppingCart sharedCart] plusItem:cartItem];
                [self updateCartUI];
            }
        }
    }
}


@end
