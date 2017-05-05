//
//  IPCRootNavigationViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCRootNavigationViewController.h"

@interface IPCRootNavigationViewController ()<UITextFieldDelegate>

@property (nonatomic, copy) void(^SearchBlock)(NSString *);

@end

@implementation IPCRootNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setNavigationBarStatus:(BOOL)isHiden
{
    self.navigationController.navigationBarHidden = isHiden;
    
    if (!isHiden) {
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 80, 40)];
        [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [backButton setAdjustsImageWhenHighlighted:NO];
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
        
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

- (void)setRightEmptyView{
    UIView * view = [[UIView alloc]init];
    UIBarButtonItem * emptyItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = emptyItem;
}

- (void)setTopSearchBar:(void (^)(NSString * text))searchBlock
{
    self.SearchBlock = searchBlock;
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 490, 30)];
    [searchView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_search_border"]]];
    
    UITextField * searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, searchView.jk_width-30, searchView.jk_height)];
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.returnKeyType = UIReturnKeyDone;
    searchTextField.delegate = self;
    [searchTextField setPlaceholder:@"请输入搜索关键词"];
    [searchTextField setTextColor:[UIColor darkGrayColor]];
    [searchTextField setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
    [searchView addSubview:searchTextField];

    self.navigationItem.titleView = searchView;
}

#pragma mark //Clicked Events
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    if (self.SearchBlock) {
        self.SearchBlock(str);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
