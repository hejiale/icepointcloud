//
//  RootMenuViewController.m
//  IcePointCloud
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCTabBarViewController.h"
#import "IPCSearchViewController.h"

@interface IPCTabBarViewController ()<IPCSearchViewControllerDelegate>

@property (strong, nonatomic)  UIView  *  contentView;
@property (strong, nonatomic)  UIView   * menuBarView;
@property (strong, nonatomic)  UIImageView * coverLine;
@property (strong, nonatomic)  UIView   * menusView;
@property (strong, nonatomic)  UIImageView *logoImageView;
@property (strong, nonatomic)  UIButton * filterButton;
@property (strong, nonatomic)  UILabel  * titleLabel;
@property (strong, nonatomic)  UIView   * bageView;
@property (strong, nonatomic) UILabel   * bageLabel;
@property (copy, nonatomic) NSString * productKeyword;
@property (copy, nonatomic) NSString * tryKeyword;
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
    
//    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundImage];
    [self.view addSubview:self.menuBarView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.coverLine];
    [self.view bringSubviewToFront:self.coverLine];
    [self.menuBarView addSubview:self.menusView];
    [self setMenuButtons];
    [self.menuBarView addSubview:self.logoImageView];
    [self.menuBarView addSubview:self.filterButton];
    [self.menuBarView addSubview:self.titleLabel];
    [self.menusView addSubview:self.bageView];
    [self.bageView addSubview:self.bageLabel];
    
    [self.menuBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.height.mas_equalTo(70);
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
        make.height.mas_equalTo(5.5);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuBarView.mas_centerX);
        make.bottom.equalTo(self.menuBarView.mas_bottom).with.offset(-9);
        make.width.mas_equalTo(92);
        make.height.mas_equalTo(35);
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
        make.top.equalTo(self.menuBarView.mas_top).with.offset(35);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    [self.bageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menusView.mas_top).with.offset(30);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(16);
        make.right.equalTo(self.menusView.mas_right).with.offset(-88);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenuCartAction) name:IPCNotificationShoppingCartChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearSearchwordAction) name:IPClearSearchwordNotification object:nil];
}


#pragma mark //Set UI
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [_contentView setBackgroundColor:[UIColor clearColor]];
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
        [_coverLine setImage:[UIImage imageNamed:@"icon_cover"]];
        [_coverLine setBackgroundColor:[UIColor clearColor]];
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
        [button setFrame:CGRectMake(65 * i, 25, 44, 44)];
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

- (UIView *)bageView{
    if (!_bageView) {
        _bageView = [[UIView alloc]initWithFrame:CGRectZero];
        [_bageView setBackgroundColor:COLOR_RGB_BLUE];
        _bageView.layer.cornerRadius = 6;
        [_bageView setHidden:YES];
    }
    return _bageView;
}

- (UILabel *)bageLabel{
    if (!_bageLabel) {
        _bageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_bageLabel setBackgroundColor:[UIColor clearColor]];
        [_bageLabel setTextColor:[UIColor whiteColor]];
        [_bageLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        _bageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bageLabel;
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
    if ( selectedIndex > 0)
    {
        if (selectedIndex != _selectedIndex && selectedIndex < 4) {
            UIViewController * selectedViewController = [self.viewControllers objectAtIndex:selectedIndex -1];
            [self addChildViewController:selectedViewController];
            
            selectedViewController.view.frame = self.contentView.bounds;
            [self.contentView addSubview:selectedViewController.view];
            [self.contentView bringSubviewToFront:selectedViewController.view];
            [selectedViewController didMoveToParentViewController:self];
            
            if (_selectedIndex != NSNotFound)
            {
                UIViewController *previousViewController = [self.viewControllers objectAtIndex:_selectedIndex-1];
                [previousViewController.view removeFromSuperview];
                [previousViewController removeFromParentViewController];
            }
            
            _selectedIndex = selectedIndex;
            
            [self updateSidebar];
            [self updateTopView:selectedIndex];
            
            if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
                [self.delegate tabBarController:self didSelectViewController:selectedViewController];
        }else{
            if ([self.delegate respondsToSelector:@selector(tabBarControllerNoneChange:TabBarIndex:)])
                [self.delegate tabBarControllerNoneChange:self TabBarIndex:selectedIndex];
        }
    }else if (selectedIndex == 0){
        [self searchProductAction];
    }
}


- (void)updateTopView:(NSInteger)selectedIndex
{
    if (selectedIndex == 1 || selectedIndex == 3) {
        [self.filterButton setHidden:NO];
        [self.logoImageView setHidden:NO];
    }else{
        [self.logoImageView setHidden:YES];
        [self.filterButton setHidden:YES];
    }
    
    if(selectedIndex == 2){
        [self.titleLabel setText:@"客户"];
    }else{
        [self.titleLabel setText:@""];
    }
}


#pragma mark //Clicked Events
- (void)menuTapAction:(UIButton *)sender {
    [self setSelectedIndex:sender.tag];
}


- (void)updateSidebar
{
    if (_selectedIndex < 4 && _selectedIndex > 0) {
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
    if (self.selectedIndex == 1) {
        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCHomeFilterProductNotification object:nil];
    }else if (self.selectedIndex == 3){
        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCTryFilterProductNotification object:nil];
    }
}

- (void)searchProductAction{
    if (_selectedIndex == 1 || _selectedIndex == 3) {
        IPCSearchViewController * searchViewMode = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
        searchViewMode.searchDelegate = self;
        [searchViewMode showSearchProductViewWithSearchWord:(_selectedIndex == 1 ? self.productKeyword : self.tryKeyword)];
        [self presentViewController:searchViewMode animated:YES completion:nil];
    }
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword
{
    if (_selectedIndex == 1) {
        self.productKeyword = keyword;
    }else if (_selectedIndex == 3){
        self.tryKeyword = keyword;
    }
    if (self.selectedIndex == 1) {
        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCHomeSearchProductNotification object:nil userInfo:@{IPCSearchKeyWord:keyword}];
    }else if (self.selectedIndex == 3){
        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCTrySearchProductNotification object:nil userInfo:@{IPCSearchKeyWord:keyword}];
    }
}


#pragma mark //Notification
- (void)reloadMenuCartAction{
    if ([[IPCShoppingCart sharedCart] allGlassesCount] > 0) {
        [self.bageView setHidden:NO];
        [self.bageLabel setText:[[NSNumber numberWithInteger:[[IPCShoppingCart sharedCart] allGlassesCount]]stringValue]];
        [self.bageLabel setFrame:self.bageView.bounds];
    }else{
        [self.bageView setHidden:YES];
    }
}

- (void)clearSearchwordAction{
    if (_selectedIndex == 0) {
        self.productKeyword = @"";
    }else if (_selectedIndex == 2){
        self.tryKeyword = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
