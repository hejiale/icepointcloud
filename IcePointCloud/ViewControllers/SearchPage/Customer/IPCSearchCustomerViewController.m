//
//  IPCSearchCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/12/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSearchCustomerViewController.h"
#import "IPCSearchItemTableViewCell.h"

@interface IPCSearchCustomerViewController ()

@property (weak, nonatomic) IBOutlet UIView *topSearchView;
@property (nonatomic, weak) IBOutlet UITextField *keywordTf;
@property (nonatomic, weak) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;
@property (nonatomic, copy) NSString * currentSearchword;

@end

@implementation IPCSearchCustomerViewController

static NSString *const kSearchItemCellName      = @"SearchItemCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IPCCommonUI clearAutoCorrection:self.topSearchView];
    //Set TableView
    [self.searchTableView setTableFooterView:[[UIView alloc]init]];
    self.searchTableView.emptyAlertTitle = @"暂无搜索历史!";
    self.searchTableView.emptyAlertImage = @"exception_search";
    //Set TextField PlaceHolder
    [self.keywordTf setPlaceholder:@"请输入搜索客户关键词..."];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    //Set TextField FirstResponder
    [self.keywordTf becomeFirstResponder];
    
    if (self.currentSearchword.length) {
        [self.keywordTf setText:self.currentSearchword];
    }
}


- (NSMutableArray<NSString *> *)keywordHistory{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}


#pragma mark //Clicked Events
- (void)showSearchCustomerViewWithSearchWord:(NSString *)word
{
    self.currentSearchword = word;
    [self.keywordHistory addObjectsFromArray:[IPCAppManager sharedManager].localCustomerHistory];
    [self.searchTableView reloadData];
}

- (IBAction)onCancelBtnTapped:(id)sender{
    [self.keywordTf endEditing:YES];
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
    
    NSString * searchtext = self.keywordHistory[indexPath.row];
    [cell.seachTitleLabel setText:searchtext];
    
    __weak typeof(self) weakSelf = self;
    [[cell rac_signalForSelector:@selector(deleteSearchValueAction:)] subscribeNext:^(id x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.keywordHistory removeObjectAtIndex:indexPath.row];
        [weakSelf syncSearchHistory:nil];
        [tableView reloadData];
    }];
    return cell;
}

#pragma mark //UITableViewDelegate
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
    if (self.keywordHistory.count > 0) {
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.keywordHistory.count > 0) {
        return 50;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * searchText = self.keywordHistory[indexPath.row];
    
    if (self.searchDelegate) {
        if ([self.searchDelegate respondsToSelector:@selector(didSearchWithKeyword:)])
            [self.searchDelegate didSearchWithKeyword:searchText];
    }
    [self.keywordTf endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    NSString *curKeyword = [textField.text jk_trimmingWhitespace];
 
    [self syncSearchHistory:curKeyword];
    
    if (self.searchDelegate) {
        if ([self.searchDelegate respondsToSelector:@selector(didSearchWithKeyword:)]){
            [self.searchDelegate didSearchWithKeyword: curKeyword];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}

#pragma mark //Store Or Clear History Methods
- (void)syncSearchHistory:(NSString *)word
{
    if (word.length && ![self.keywordHistory containsObject:word]) {
        [self.keywordHistory insertObject:self.keywordTf.text atIndex:0];
    }
    
    if ([self.keywordHistory.lastObject isKindOfClass:[NSNull class]]){
        [self.keywordHistory removeLastObject];
    }
    
    NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.keywordHistory];
    [NSUserDefaults jk_setObject:historyData forKey:IPCSearchCustomerkey];
}

- (void)clearSearchHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCSearchCustomerkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
