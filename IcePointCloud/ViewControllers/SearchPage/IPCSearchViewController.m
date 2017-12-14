//
//  SearchViewController.m
//  IcePointCloud
//
//  Created by mac on 8/14/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCSearchViewController.h"

typedef NS_ENUM(NSInteger, IPCSearchType){
    IPCSearchTypeProduct,
    IPCSearchTypeCustomer
};

@interface IPCSearchViewController ()

@property (weak, nonatomic) IBOutlet UIView *topSearchView;
@property (nonatomic, weak) IBOutlet UITextField *keywordTf;
@property (nonatomic, weak) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) UIView * leftTextFieldView;
//@property (nonatomic, strong) NSMutableArray<NSArray *> * keywordHistory;
@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;
@property (nonatomic, strong) NSMutableArray<NSString *> * inputKeyArray;
@property (assign, nonatomic) IPCSearchType  searchType;
@property (nonatomic, copy) NSString * currentSearchword;

@end

@implementation IPCSearchViewController

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
    if (self.searchType == IPCSearchTypeProduct) {
        [self.keywordTf setPlaceholder:[NSString stringWithFormat:@"搜索%@类商品",[[IPCAppManager sharedManager] classTypeName:self.filterType]]];
    }else{
        [self.keywordTf setPlaceholder:@"请输入搜索客户关键词..."];
    }
    /*[self.keywordTf setLeftView:self.leftTextFieldView];
    [self.keywordTf setLeftViewMode:UITextFieldViewModeAlways];*/
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    //Set TextField FirstResponder
    [self.keywordTf becomeFirstResponder];
    [self.keywordTf setText:self.currentSearchword];
}


/*- (NSMutableArray<NSArray *> *)keywordHistory{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}*/

- (NSMutableArray<NSString *> *)keywordHistory{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}

/*- (NSMutableArray<NSString *> *)inputKeyArray
{
    if (!_inputKeyArray) {
        _inputKeyArray = [[NSMutableArray alloc]init];
    }
    return _inputKeyArray;
}*/

#pragma mark //Set UI
/*- (UIView *)leftTextFieldView
{
    if (!_leftTextFieldView) {
        _leftTextFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 30)];
        [_leftTextFieldView setBackgroundColor:[UIColor clearColor]];
    }
    return _leftTextFieldView;
}

- (void)updateLeftTextViewUI
{
    __block CGFloat totalWidth = 0;
    
    [self.leftTextFieldView removeAllSubviews];
    
    [self.inputKeyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIFont * font = [UIFont systemFontOfSize:13];
        double textWidth = [obj jk_sizeWithFont:font constrainedToHeight:30].width;
        double width = MAX(textWidth + 30, 40);
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(totalWidth, 0, width, 30)];
        [view setBackgroundColor:COLOR_RGB_BLUE];
        [view addBorder:15 Width:0 Color:[UIColor clearColor]];
        [self.leftTextFieldView addSubview:view];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, textWidth+5, 20)];
        [label setFont:font];
        [label setText:obj];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        UIImageView * closeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width-25, 5, 20, 20)];
        [closeImageView setBackgroundColor:[UIColor clearColor]];
        [closeImageView setImage:[UIImage imageNamed:@"icon_close"]];
        [view addSubview:closeImageView];
        
        totalWidth += width + 5;
    }];
    
    self.leftTextFieldView.jk_width = totalWidth;
}*/

#pragma mark //Clicked Events
- (void)showSearchProductViewWithSearchWord:(NSString *)word
{
    self.searchType = IPCSearchTypeProduct;
    self.currentSearchword = word;
    [self.keywordHistory addObjectsFromArray:[IPCAppManager sharedManager].localProductsHistory];
    [self.searchTableView reloadData];
}

- (void)showSearchCustomerViewWithSearchWord:(NSString *)word
{
    self.searchType = IPCSearchTypeCustomer;
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
    NSString * searchText = self.keywordHistory[indexPath.row];
    [cell.seachTitleLabel setText:searchText];
    
    /*NSArray * searchtextArray = self.keywordHistory[indexPath.row];
    [cell.seachTitleLabel setText:[searchtextArray componentsJoinedByString:@" "]];*/
    
    __weak typeof(self) weakSelf = self;
    [[cell rac_signalForSelector:@selector(deleteSearchValueAction:)] subscribeNext:^(id x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.keywordHistory removeObject:searchText];
        [strongSelf syncSearchHistory:nil];
        [tableView reloadData];
        
        /*[strongSelf.keywordHistory removeObjectAtIndex:indexPath.row];
        [strongSelf syncSearchHistory];
        [tableView reloadData];*/
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
    /*[self.inputKeyArray removeAllObjects];
    NSArray * searchText = self.keywordHistory[indexPath.row];
    [self.inputKeyArray addObjectsFromArray:searchText];
    [self updateLeftTextViewUI];*/
    
    NSString * searchText = self.keywordHistory[indexPath.row];
    
    if (self.searchDelegate) {
        if ([self.searchDelegate respondsToSelector:@selector(didSearchWithKeyword:)])
            [self.searchDelegate didSearchWithKeyword:searchText];
    }
    [self.keywordTf endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark //UITextFieldDelegate
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        NSString * str = [textField.text jk_trimmingWhitespace];
        if (str.length) {
            [self.inputKeyArray addObject: str];
            [self updateLeftTextViewUI];
        }
        [textField setText:@""];
        return NO;
    }
    return YES;
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    NSString *curKeyword = [textField.text jk_trimmingWhitespace];
    /*[self.inputKeyArray addObject:curKeyword];*/
    [self syncSearchHistory:curKeyword];
    
    if (self.searchDelegate) {
        if ([self.searchDelegate respondsToSelector:@selector(didSearchWithKeyword:)]){
            [self.searchDelegate didSearchWithKeyword:curKeyword];
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
    
    /*if (self.inputKeyArray.count && ![self isContain]) {
        [self.keywordHistory insertObject:self.inputKeyArray atIndex:0];
    }*/
    
    if ([self.keywordHistory.lastObject isKindOfClass:[NSNull class]]){
        [self.keywordHistory removeLastObject];
    }
    
    NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.keywordHistory];
    if (self.searchType == IPCSearchTypeProduct) {
        [NSUserDefaults jk_setObject:historyData forKey:IPCSearchHistoryListKey];
    }else{
        [NSUserDefaults jk_setObject:historyData forKey:IPCSearchCustomerkey];
    }
}

- (void)clearSearchHistory
{
    if (self.searchType == IPCSearchTypeProduct) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCSearchHistoryListKey];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCSearchCustomerkey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*- (BOOL)isContain
{
    __block BOOL isContain = NO;
    [self.keywordHistory enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj componentsJoinedByString:@" "] isEqualToString:[self.inputKeyArray componentsJoinedByString:@" "]]) {
            isContain = YES;
            *stop = YES;
        }
    }];
    return isContain;
}*/

@end
