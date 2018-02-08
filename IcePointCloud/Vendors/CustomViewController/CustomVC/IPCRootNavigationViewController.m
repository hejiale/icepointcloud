//
//  IPCRootNavigationViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCRootNavigationViewController.h"
#import "IPCPayOrderViewController.h"

@interface IPCRootNavigationViewController ()

@end

@implementation IPCRootNavigationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackground];
}

#pragma mark //Set Navigation Bar
- (void)setNavigationTitle:(NSString *)title
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleLabel setTextColor:[UIColor darkGrayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightThin]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)setNavigationBarStatus:(BOOL)isHiden
{
    self.navigationController.navigationBarHidden = isHiden;
    
    if (!isHiden) {
        [self setLeftBack:NO];
//        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setFrame:CGRectMake(0, 0, 80, 40)];
//        [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
//        [backButton setAdjustsImageWhenHighlighted:NO];
//        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//
//        UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//        self.navigationItem.leftBarButtonItem = backItem;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navigationBar"] forBarMetrics:UIBarMetricsDefault];
    }
}


- (void)setRightItem:(NSString *)itemImageName Selection:(SEL)selection
{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 80, 40)];
    [rightButton setImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
    [rightButton setAdjustsImageWhenHighlighted:NO];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:selection forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setRightView:(UIView *)view{
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightTitle:(NSString *)itemName Selection:(SEL)selection
{
    UIFont * font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
    CGFloat width = [itemName jk_sizeWithFont:font constrainedToHeight:40].width;
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width + 10, 40)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, width, 40)];
    [rightButton setAdjustsImageWhenHighlighted:NO];
    [rightButton setTitle:itemName forState:UIControlStateNormal];
    [rightButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:font];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rightButton addTarget:self action:selection forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightButton];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
    }
}



@end
