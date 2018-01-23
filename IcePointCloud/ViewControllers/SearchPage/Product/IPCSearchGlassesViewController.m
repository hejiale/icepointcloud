//
//  SearchViewController.m
//  IcePointCloud
//
//  Created by mac on 8/14/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCSearchGlassesViewController.h"
#import "IPCSearchItemTableViewCell.h"

@interface IPCSearchGlassesViewController ()

@property (weak, nonatomic) IBOutlet UIView *topSearchView;
@property (nonatomic, weak) IBOutlet UITextField *keywordTf;
@property (nonatomic, weak) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) UIView * leftTextFieldView;
@property (nonatomic, strong) NSMutableArray<NSArray *> * keywordHistory;
@property (nonatomic, strong) NSMutableArray<NSString *> * inputKeyArray;
@property (nonatomic, copy) NSString * currentSearchword;
@property (nonatomic, strong) UIButton *  clearButton;

@end

@implementation IPCSearchGlassesViewController

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
    [self.keywordTf setPlaceholder:[NSString stringWithFormat:@"搜索%@类商品",[[IPCAppManager sharedManager] classTypeName:self.filterType]]];
  
    [self.keywordTf setLeftView:self.leftTextFieldView];
    [self.keywordTf setRightView:self.clearButton];
    [self.keywordTf setLeftViewMode:UITextFieldViewModeAlways];
    [self.keywordTf setRightViewMode:UITextFieldViewModeAlways];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [[IPCHttpRequest sharedClient] cancelAllRequest];
    //Set TextField FirstResponder
    [self.keywordTf becomeFirstResponder];
    
    if (self.currentSearchword.length) {
        [self.inputKeyArray addObjectsFromArray: [self.currentSearchword componentsSeparatedByString:@","]];
        [self updateLeftTextViewUI];
    }
}


- (NSMutableArray<NSArray *> *)keywordHistory{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}


- (NSMutableArray<NSString *> *)inputKeyArray
{
    if (!_inputKeyArray) {
        _inputKeyArray = [[NSMutableArray alloc]init];
    }
    return _inputKeyArray;
}

#pragma mark //Set UI
- (UIView *)leftTextFieldView
{
    if (!_leftTextFieldView) {
        _leftTextFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 30)];
        [_leftTextFieldView setBackgroundColor:[UIColor clearColor]];
    }
    return _leftTextFieldView;
}

- (UIButton *)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setFrame:CGRectMake(0, 0, 50, 50)];
        [_clearButton setImage:[UIImage imageNamed:@"icon_searchClose"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearInputAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (void)updateLeftTextViewUI
{
    __block CGFloat totalWidth = 0;
    
    [self.leftTextFieldView removeAllSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.inputKeyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIFont * font = [UIFont systemFontOfSize:13];
        double textWidth = [obj jk_sizeWithFont:font constrainedToHeight:20].width;
        double width = MAX(textWidth + 45, 50);
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(totalWidth, 3, width, 24)];
        [view addBorder:12 Width:1 Color:COLOR_RGB_BLUE];
        [strongSelf.leftTextFieldView addSubview:view];
        [view jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [strongSelf.inputKeyArray removeObjectAtIndex:idx];
            [weakSelf updateLeftTextViewUI];
        }];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, textWidth, 20)];
        [label setFont:font];
        [label setText:obj];
        [label setTextColor:COLOR_RGB_BLUE];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        UIImageView * closeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width-25, 6, 12, 12)];
        [closeImageView setBackgroundColor:[UIColor clearColor]];
        [closeImageView setImage:[UIImage imageNamed:@"icon_small_close"]];
        closeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:closeImageView];
        
        totalWidth += width + 5;
    }];
    
    self.leftTextFieldView.jk_width = totalWidth;
}

#pragma mark //Clicked Events
- (void)showSearchProductViewWithSearchWord:(NSString *)word
{
    self.currentSearchword = word;
    [self.keywordHistory addObjectsFromArray:[IPCAppManager sharedManager].localProductsHistory];
    [self.searchTableView reloadData];
}


- (IBAction)onCancelBtnTapped:(id)sender{
    [self.keywordTf endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearInputAction:(id)sender
{
    [self.inputKeyArray removeAllObjects];
    [self.keywordTf setText:@""];
    [self updateLeftTextViewUI];
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
  
    NSArray * searchtextArray = self.keywordHistory[indexPath.row];
    [cell.seachTitleLabel setText:[searchtextArray componentsJoinedByString:@" "]];
    
    __weak typeof(self) weakSelf = self;
    [[cell rac_signalForSelector:@selector(deleteSearchValueAction:)] subscribeNext:^(id x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.keywordHistory removeObjectAtIndex:indexPath.row];
        [weakSelf syncSearchHistory];
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
    NSArray * searchText = self.keywordHistory[indexPath.row];
    
    if (self.searchDelegate) {
        if ([self.searchDelegate respondsToSelector:@selector(didSearchWithKeyword:)])
            [self.searchDelegate didSearchWithKeyword:[searchText componentsJoinedByString:@","]];
    }
    [self.keywordTf endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    NSString *curKeyword = [textField.text jk_trimmingWhitespace];
    if (curKeyword.length) {
        [self.inputKeyArray addObject:curKeyword];
    }
    [self syncSearchHistory];
    
    if (self.searchDelegate) {
        if ([self.searchDelegate respondsToSelector:@selector(didSearchWithKeyword:)]){
            [self.searchDelegate didSearchWithKeyword:[self.inputKeyArray componentsJoinedByString:@","]];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}

#pragma mark //Store Or Clear History Methods
- (void)syncSearchHistory
{
    if (self.inputKeyArray.count && ![self isContain]) {
        [self.keywordHistory insertObject:self.inputKeyArray atIndex:0];
    }
    
    if ([self.keywordHistory.lastObject isKindOfClass:[NSNull class]]){
        [self.keywordHistory removeLastObject];
    }
    
    NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.keywordHistory];
    [NSUserDefaults jk_setObject:historyData forKey:IPCSearchHistoryListKey];
}

- (void)clearSearchHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCSearchHistoryListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isContain
{
    __block BOOL isContain = NO;
    [self.keywordHistory enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj componentsJoinedByString:@" "] isEqualToString:[self.inputKeyArray componentsJoinedByString:@" "]]) {
            isContain = YES;
            *stop = YES;
        }
    }];
    return isContain;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
