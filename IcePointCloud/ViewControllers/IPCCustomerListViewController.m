//
//  ExpandUserOptometryViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerListViewController.h"
#import "IPCCustomerCollectionViewCell.h"
#import "IPCInsertCustomerViewController.h"
#import "IPCCustomerDetailViewController.h"
#import "IPCSearchItemTableViewCell.h"

static NSString * const customerIdentifier = @"CustomerCollectionViewCellIdentifier";
static NSString * const seachIdentifier = @"SearchItemCellIdentifier";

@interface IPCCustomerListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString * searchWord;
}
@property (weak, nonatomic) IBOutlet UIView *topSearchView;
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;
@property (strong, nonatomic) IPCCustomerList * customerList;

@end

@implementation IPCCustomerListViewController

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
    
    searchWord = @"";
    [IPCCustomUI clearAutoCorrection:self.topSearchView];
    [self.searchHistoryTableView setTableFooterView:[[UIView alloc]init]];
    self.searchHistoryTableView.emptyAlertTitle = @"暂无搜索历史!";
    self.searchHistoryTableView.emptyAlertImage = @"exception_search";
    [self.keywordHistory addObjectsFromArray:[IPCAppManager sharedManager].localCustomerHistory];
    
    CGFloat itemWidth = (self.customerCollectionView.jk_width - 40)/3;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, 110);
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    
    [self.customerCollectionView setCollectionViewLayout:layout];
    self.customerCollectionView.emptyAlertImage = @"exception_search";
    self.customerCollectionView.emptyAlertTitle = @"未查询到该客户信息!";
    [self.customerCollectionView registerNib:[UINib nibWithNibName:@"IPCCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
    [self.customerCollectionView reloadData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[IPCHttpRequest sharedClient] cancelAllRequest];
}


- (NSMutableArray<NSString *> *)keywordHistory{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}


#pragma mark //Request Data
- (void)queryCustomerInfo{
    [IPCCustomUI show];
    [self.searchHistoryTableView setHidden:YES];
    [self.customerCollectionView setHidden:NO];
    
    [IPCCustomerRequestManager queryCustomerListWithKeyword:searchWord
                                               SuccessBlock:^(id responseValue)
     {
         _customerList = [[IPCCustomerList alloc]initWithResponseValue:responseValue];
         [self.customerCollectionView reloadData];
         [IPCCustomUI hiden];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
         [self.customerCollectionView reloadData];
     }];
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender {
    IPCInsertCustomerViewController * insertCustomerVC = [[IPCInsertCustomerViewController alloc]initWithNibName:@"IPCInsertCustomerViewController" bundle:nil];
    [self.navigationController pushViewController:insertCustomerVC animated:YES];
}


- (void)clearHistoryAction{
    [self clearSearchHistory];
    [self.keywordHistory removeAllObjects];
    [self.searchHistoryTableView reloadData];
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.customerList.list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
    IPCCustomerMode * customer = self.customerList.list[indexPath.row];
    cell.currentCustomer = customer;
    
    return cell;
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomerMode * customer = self.customerList.list[indexPath.row];
    
    IPCCustomerDetailViewController * detailVC = [[IPCCustomerDetailViewController alloc]initWithNibName:@"IPCCustomerDetailViewController" bundle:nil];
    [detailVC setCustomer:customer];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keywordHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCSearchItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:seachIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCSearchItemTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    
    __weak typeof (self) weakSelf = self;
    [cell inputText:self.keywordHistory[indexPath.row] Complete:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.keywordHistory removeObjectAtIndex:indexPath.row];
        [strongSelf storeCustomer];
        [strongSelf.searchHistoryTableView reloadData];
    }];
    
    return cell;
}

#pragma mark //UITableViewDelegate
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.keywordHistory count] > 0)
        return 50;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 50)];
    
    UILabel * headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [headLabel setText:@"最近搜索"];
    [headLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightThin]];
    [headView addSubview:headLabel];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    searchWord = self.keywordHistory[indexPath.row];
    [self.searchTextField setText:searchWord];
    [self performSelectorOnMainThread:@selector(queryCustomerInfo) withObject:nil waitUntilDone:YES];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    searchWord = [textField.text jk_trimmingWhitespace];
    
    if (searchWord.length){
        [self performSelectorOnMainThread:@selector(queryCustomerInfo) withObject:nil waitUntilDone:YES];
        [self storeCustomer];
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    searchWord = @"";
    [self.searchHistoryTableView setHidden:NO];
    [self.customerCollectionView setHidden:YES];
    [self.searchHistoryTableView reloadData];
    return YES;
}


#pragma mark //Save search local users
- (void)storeCustomer
{
    if (searchWord.length && ![self.keywordHistory containsObject:searchWord]) {
        [self.keywordHistory insertObject:searchWord atIndex:0];
    }
    
    if ([self.keywordHistory.lastObject isKindOfClass:[NSNull class]])
        [self.keywordHistory removeLastObject];
    
    NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.keywordHistory];
    [NSUserDefaults jk_setObject:historyData forKey:IPCSearchCustomerkey];
}

- (void)clearSearchHistory
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCSearchCustomerkey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end



