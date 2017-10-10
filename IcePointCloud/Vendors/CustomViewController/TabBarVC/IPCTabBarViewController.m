//
//  RootMenuViewController.m
//  IcePointCloud
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCTabBarViewController.h"
#import "IPCSearchViewController.h"
#import "UIView+Badge.h"

@interface IPCTabBarViewController ()

@property (strong, nonatomic)  UIView  *  contentView;
@property (strong, nonatomic)  UIView   * menuBarView;
@property (strong, nonatomic)  UIImageView * coverLine;
@property (strong, nonatomic)  UIView   * menusView;
@property (strong, nonatomic)  UIImageView *logoImageView;
@property (strong, nonatomic)  UIButton * filterButton;
@property (strong, nonatomic)  UILabel  * titleLabel;
@property (copy, nonatomic) NSString * customerKeyword;

@end

@implementation IPCTabBarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setBackground];
    [self.view addSubview:self.menuBarView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.coverLine];
    [self.view bringSubviewToFront:self.coverLine];
    [self.menuBarView addSubview:self.menusView];
    [self setMenuButtons];
    [self.menuBarView addSubview:self.logoImageView];
    [self.menuBarView addSubview:self.filterButton];
    [self.menuBarView addSubview:self.titleLabel];
    
    [self.menuBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.height.mas_equalTo(64);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.menuBarView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    [self.coverLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuBarView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuBarView.mas_centerX);
        make.bottom.equalTo(self.menuBarView.mas_bottom).with.offset(-8);
        make.width.mas_equalTo(94);
        make.height.mas_equalTo(32);
    }];
    [self.menusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.menuBarView.mas_right).with.offset(0);
        make.top.equalTo(self.menuBarView.mas_top).with.offset(0);
        make.bottom.equalTo(self.menuBarView.mas_bottom).with.offset(0);
        make.width.mas_equalTo(390);
    }];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuBarView.mas_left).with.offset(5);
        make.top.equalTo(self.menuBarView.mas_top).with.offset(25);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuBarView.mas_centerX);
        make.top.equalTo(self.menuBarView.mas_top).with.offset(30);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
    }];
    
    [self requestTradeOrExchangeStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadCartBadge)
                                                 name:IPCNotificationShoppingCartChanged
                                               object:nil];
}


#pragma mark //Set UI
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [_contentView setBackgroundColor:[UIColor colorWithHexString:@"#F4F4F4"]];
    }
    return _contentView;
}
- (UIView *)menuBarView{
    if (!_menuBarView) {
        _menuBarView = [[UIView alloc]initWithFrame:CGRectZero];
        [_menuBarView setBackgroundColor:[UIColor whiteColor]];
    }
    return _menuBarView;
}

- (UIImageView *)coverLine{
    if (!_coverLine) {
        _coverLine = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_coverLine setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.1]];
    }
    return _coverLine;
}

- (UIView *)menusView{
    if (!_menusView) {
        _menusView = [[UIView alloc]initWithFrame:CGRectZero];
        [_menusView setBackgroundColor:[UIColor clearColor]];
    }
    return _menusView;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage  imageNamed:@"icon_logo"]];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_logoImageView setFrame:CGRectZero];
    }
    return _logoImageView;
}

- (void)setMenuButtons{
    for (NSInteger i = 0; i < 6; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        if (i < 5) {
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_normal_%ld",(long)i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_selected_%ld",(long)i]] forState:UIControlStateSelected];
        }else{
            [button setImage:[UIImage imageNamed:@"icon_login_head_male"] forState:UIControlStateNormal];
        }
        button.adjustsImageWhenHighlighted = NO;
        [button setFrame:CGRectMake(65 * i, 20, 44, 44)];
        [button setTag:i];
        [button addTarget:self action:@selector(menuTapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.menusView addSubview:button];
    }
}

- (UIButton *)filterButton{
    if (!_filterButton) {
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterButton setBackgroundColor:[UIColor clearColor]];
        [_filterButton setImage:[UIImage imageNamed:@"list_btn_filter"] forState:UIControlStateNormal];
        [_filterButton setFrame:CGRectZero];
        _filterButton.adjustsImageWhenHighlighted = NO;
        [_filterButton addTarget:self action:@selector(filterProductAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightThin]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

#pragma mark //Update SelectViewController
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    _viewControllers = [viewControllers copy];
    _selectedIndex = NSNotFound;
    self.selectedIndex = [viewControllers count] > 0 ? 1 : INT_MAX;
}


- (UIViewController *)selectedViewController
{
    if (self.selectedIndex < [self.viewControllers count] + 1 && self.selectedIndex > 0)
        return [self.viewControllers objectAtIndex:self.selectedIndex -1];
    return nil;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex != _selectedIndex && selectedIndex > 0 && selectedIndex < 5) {
        UIViewController * selectedViewController = [self.viewControllers objectAtIndex:selectedIndex -1];
        [self addChildViewController:selectedViewController];
        
        selectedViewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:selectedViewController.view];
        [self.contentView bringSubviewToFront:selectedViewController.view];
        [selectedViewController didMoveToParentViewController:self];
        
        if (_selectedIndex != NSNotFound && _selectedIndex < 5)
        {
            UIViewController *previousViewController = [self.viewControllers objectAtIndex:_selectedIndex-1];
            [previousViewController.view removeFromSuperview];
            [previousViewController removeFromParentViewController];
        }
        _selectedIndex = selectedIndex;
        
        [self updateSidebar];
        [self updateTopView];
        
        if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
            [self.delegate tabBarController:self didSelectViewController:selectedViewController];
    }else{
        if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectIndex:)]) {
            [self.delegate tabBarController:self didSelectIndex:selectedIndex];
        }
    }
}


- (void)updateTopView
{
    if (_selectedIndex < 5 && _selectedIndex > 0) {
        if (_selectedIndex == 1 || _selectedIndex == 3) {
            [self.filterButton setHidden:NO];
            [self.logoImageView setHidden:NO];
        }else{
            [self.logoImageView setHidden:YES];
            [self.filterButton setHidden:YES];
        }
        
        if(_selectedIndex == 2){
            [self.titleLabel setText:@"客户"];
        }else if (_selectedIndex == 4){
            [self.titleLabel setText:@"确认订单"];
        }else{
            [self.titleLabel setText:@""];
        }
    }
}


#pragma mark //Clicked Events
- (void)menuTapAction:(UIButton *)sender
{
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    
    if (sender.tag > 0 && sender.tag < 5) {
        if (sender.tag != 4) {
            [IPCPayOrderManager sharedManager].isPayOrderStatus = NO;
        }else{
            [IPCPayOrderManager sharedManager].isPayOrderStatus = YES;
        }
    }
    
    [self setSelectedIndex:sender.tag];
}

- (void)updateSidebar
{
    if (_selectedIndex < 5 && _selectedIndex > 0) {
        [self.menusView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button = (UIButton *)obj;
                if (idx == _selectedIndex) {
                    [button setSelected:YES];
                }else{
                    [button setSelected:NO];
                }
            }
        }];
    }
}

- (void)filterProductAction{
}

#pragma mark //Notification
- (void)reloadCartBadge{
    UIButton * button = (UIButton *)self.menusView.subviews[4];
    [button createBadgeText:[NSString stringWithFormat:@"%d",[[IPCShoppingCart sharedCart] allGlassesCount]]];
}

- (void)requestTradeOrExchangeStatus
{
    [IPCPayOrderRequestManager getStatusTradeOrExchangeWithSuccessBlock:^(id responseValue) {
        [IPCPayOrderManager sharedManager].isTrade = YES;
    } FailureBlock:^(NSError *error) {
        if ([error code] != NSURLErrorCancelled) {
            [IPCCommonUI showError:@"查询积分定制规则失败!"];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end