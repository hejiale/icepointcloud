//
//  SearchViewController.m
//  IcePointCloud
//
//  Created by mac on 8/14/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCSearchViewController.h"

@interface IPCSearchViewController ()

@property (nonatomic, strong) NSMutableArray<NSString *>     *keywordHistory;

@property (weak, nonatomic) IBOutlet UIView *topSearchView;
@property (nonatomic, weak) IBOutlet UITextField *keywordTf;
@property (nonatomic, weak) IBOutlet UITableView *searchTableView;

@end

@implementation IPCSearchViewController

static NSString *const kSearchItemCellName      = @"SearchItemCellIdentifier";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IPCCustomUI clearAutoCorrection:self.topSearchView];
    [self.searchTableView setTableFooterView:[[UIView alloc]init]];
    self.searchTableView.emptyAlertTitle = @"暂无搜索历史!";
    self.searchTableView.emptyAlertImage = @"exception_search";
    [self.keywordHistory addObjectsFromArray:[IPCAppManager sharedManager].localProductsHistory];
    [self.keywordTf setText:self.currentSearchword];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.keywordTf becomeFirstResponder];
}

- (NSMutableArray<NSString *> *)keywordHistory{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}


#pragma mark //Clicked Events
- (IBAction)onCancelBtnTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)clearHistoryAction{
    [self clearSearchHistory];
    [self.keywordHistory removeAllObjects];
    [self.searchTableView reloadData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keywordHistory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCSearchItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchItemCellName];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCSearchItemTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }

    __weak typeof (self) weakSelf = self;
    [cell inputText:self.keywordHistory[indexPath.row] Complete:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.keywordHistory removeObjectAtIndex:indexPath.row];
        [strongSelf syncSearchHistory:nil];
        [strongSelf.searchTableView reloadData];
    }];
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item = self.keywordHistory[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didSearchWithKeyword:)])
        [self.delegate didSearchWithKeyword:item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 50)];
    
    UILabel * headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [headLabel setText:@"最近搜索"];
    [headLabel setTextColor:[UIColor darkGrayColor]];
    [headLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightThin]];
    [headView addSubview:headLabel];
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 50)];
    
    UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:footView.bounds];
    [clearButton setTitle:@"清除搜索历史记录" forState:UIControlStateNormal];
    [clearButton setTitleColor:COLOR_RGB_RED forState:UIControlStateNormal];
    [clearButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightThin]];
    [clearButton addTarget:self action:@selector(clearHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:clearButton];
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.keywordHistory count] > 0)
        return 50;
    return 0;
}

#pragma mark //Do Search History
- (void)syncSearchHistory:(NSString *)keyWord
{
    if (keyWord.length && ![self.keywordHistory containsObject:keyWord]) {
        [self.keywordHistory insertObject:keyWord atIndex:0];
    }
    
    if ([self.keywordHistory.lastObject isKindOfClass:[NSNull class]]){
        [self.keywordHistory removeLastObject];
    }
    
    NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.keywordHistory];
    [NSUserDefaults jk_setObject:historyData forKey:IPCListSearchHistoryKey];
}

- (void)clearSearchHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCListSearchHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *curKeyword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self syncSearchHistory:curKeyword];
    
    if ([self.delegate respondsToSelector:@selector(didSearchWithKeyword:)])
        [self.delegate didSearchWithKeyword:curKeyword];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}

@end
