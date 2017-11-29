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

@interface IPCShoppingCartView ()<UITableViewDelegate,UITableViewDataSource,IPCEditShoppingCartCellDelegate,IPCExpandShoppingCartCellDelegate>
{
    BOOL   isEditStatus;
}

@property (weak, nonatomic) IBOutlet UITableView *cartListTableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UIView *cartBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) UIView * coverView;
@property (strong, nonatomic) IPCCartViewMode    *cartViewMode;
@property (strong, nonatomic) IPCGlassParameterView * parameterView;
@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCShoppingCartView


- (instancetype)initWithFrame:(CGRect)frame Complete:(void (^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCShoppingCartView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.cartBottomView addTopLine];
        //Load UITableView
        [self.cartListTableView setTableHeaderView:[[UIView alloc]init]];
        [self.cartListTableView setTableFooterView:[[UIView alloc]init]];
        self.cartListTableView.estimatedSectionFooterHeight = 0;
        self.cartListTableView.estimatedSectionHeaderHeight = 0;
        self.cartListTableView.emptyAlertImage = @"exception_cart";
        self.cartListTableView.emptyAlertTitle = @"暂无任何商品";

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self commitUI];
}

#pragma mark //Set UI
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.bounds];
        [_coverView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.2]];
    }
    return _coverView;
}

- (void)commitUI{
    self.cartViewMode = [[IPCCartViewMode alloc]init];
    [self updateCartUI:YES];
}

- (void)updateBottomStatus:(BOOL)isShown
{
    [self.editButton setSelected:isShown];
    [self.cartBottomView setHidden:!isShown];
    self.tableBottom.constant = isShown ? 60 : 10;
}

- (void)updateCartUI:(BOOL)isUpdateStatus
{
    [self.editButton setHidden:[self.cartViewMode shoppingCartIsEmpty]];
    [self.selectAllButton setSelected:[self.cartViewMode judgeCartItemSelectState]];
    [self.cartListTableView reloadData];
    
    if (isUpdateStatus) {
        if (self.CompleteBlock) {
            self.CompleteBlock();
        }
    }
}

- (void)resetShoppingCartStatus{
    if ([IPCShoppingCart sharedCart].itemsCount == 0) {
        isEditStatus = NO;
        [self updateBottomStatus:isEditStatus];
    }
    [self updateCartUI:YES];
}

- (void)reload
{
    [self updateCartUI:NO];
}

#pragma mark //Clicked Events
- (IBAction)onEditAction:(UIButton *)sender
{
    isEditStatus = !sender.selected;
    [self updateBottomStatus:isEditStatus];
    [self updateCartUI:NO];
}

- (IBAction)onSelectAllAction:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [self.cartViewMode changeAllCartItemSelected:sender.selected];
    [self updateCartUI:NO];
}


- (IBAction)onDeleteProductsAction:(id)sender {
    __weak typeof (self) weakSelf = self;
    if ([self.cartViewMode isSelectCart]) {
        [IPCCommonUI showAlert:@"温馨提示" Message:@"您确定要删除所选商品吗?" Owner:[UIApplication sharedApplication].keyWindow.rootViewController Done:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [[IPCShoppingCart sharedCart] removeSelectCartItem];
            [strongSelf resetShoppingCartStatus];
        }];
    }
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
            __weak typeof(self) weakSelf = self;
            [cell setCartItem:cartItem Reload:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf resetShoppingCartStatus];
            }];
        }
        return cell;
    }else{
        IPCExpandShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kNewShoppingCartItemName];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCExpandShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
        
        if (cartItem){
            [cell setCartItem:cartItem];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditStatus) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row];
        [[IPCShoppingCart sharedCart] removeItem:cartItem];
        [self updateCartUI:YES];
    }
}

#pragma mark //IPCEditShoppingCartCellDelegate
- (void)chooseParameter:(IPCEditShoppingCartCell *)cell{
    [self addSubview:self.coverView];
    
    NSIndexPath * indexPath = [self.cartListTableView indexPathForCell:cell];
    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] itemAtIndex:indexPath.row] ;
    
    __weak typeof(self) weakSelf = self;
    _parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [_parameterView removeFromSuperview];
        [strongSelf.coverView removeFromSuperview];
    }];
    _parameterView.cartItem = cartItem;
    [[UIApplication sharedApplication].keyWindow addSubview:_parameterView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_parameterView];
    [_parameterView show];
}

#pragma mark //IPCExpandShoppingCartCellDelegate
- (void)preEditing:(IPCExpandShoppingCartCell *)cell
{
    NSIndexPath *  indexPath = [self.cartListTableView indexPathForCell:cell];
    if (indexPath.row > 0)
    {
        IPCExpandShoppingCartCell * preCell = (IPCExpandShoppingCartCell *)[self.cartListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
        [[IPCTextFiledControl instance] clearAllEditingAddition:preCell.inputPriceTextField];
        [self.cartListTableView reloadData];
        [preCell.inputPriceTextField setIsEditing:YES];
    }
}

- (void)nextEditing:(IPCExpandShoppingCartCell *)cell
{
    NSIndexPath *  indexPath = [self.cartListTableView indexPathForCell:cell];
    if (indexPath.row < [[IPCShoppingCart sharedCart] itemsCount] - 1)
    {
        IPCExpandShoppingCartCell * nextCell = (IPCExpandShoppingCartCell *)[self.cartListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
        [[IPCTextFiledControl instance] clearAllEditingAddition:nextCell.inputPriceTextField];
        [self.cartListTableView reloadData];
        [nextCell.inputPriceTextField setIsEditing:YES];
    }
}

- (void)endEditing:(IPCExpandShoppingCartCell *)cell
{
    [IPCPayOrderManager sharedManager].customDiscount = -1;
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
    [self updateCartUI:YES];
}


@end
