//
//  IPCPayOrderPayCashViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderPayCashViewController.h"
#import "IPCPayOrderEditPayCashRecordCell.h"
#import "IPCPayOrderPayCashRecordCell.h"
#import "IPCPayCashPayTypeViewCell.h"

static  NSString * const recordCell = @"IPCPayOrderPayCashRecordCellIdentifier";
static  NSString * const editRecordCell = @"IPCPayOrderEditPayCashRecordCellIdentifier";
static  NSString * const payTypeIdentifier = @"IPCPayCashPayTypeViewCellIdentifier";

@interface IPCPayOrderPayCashViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderEditPayCashRecordCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payRecordTableView;
@property (weak, nonatomic) IBOutlet UIView *payTypeContentView;
@property (weak, nonatomic) IBOutlet UILabel *remainPayAmountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *payTypeCollectionView;
@property (nonatomic, strong) IPCCustomKeyboard * keyboard;
@property (nonatomic, strong) IPCPayRecord * insertRecord;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation IPCPayOrderPayCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.payRecordTableView setTableHeaderView:[[UIView alloc]init]];
    [self.payRecordTableView setTableFooterView:[[UIView alloc]init]];
    [self.view addSubview:self.keyboard];
    
    __block CGFloat width = (self.payTypeContentView.jk_width - 15)/4;
    __block CGFloat height = (self.payTypeCollectionView.jk_height - 5)/2;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake(width, height)];
    [layout setMinimumLineSpacing:5];
    [layout setMinimumInteritemSpacing:5];
    
    [self.payTypeCollectionView setCollectionViewLayout:layout];
    [self.payTypeCollectionView registerNib:[UINib nibWithNibName:@"IPCPayCashPayTypeViewCell" bundle:nil] forCellWithReuseIdentifier:payTypeIdentifier];
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadPayStatus];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IPCTextFiledControl instance] clearPreTextField];
}

#pragma mark //Set UI
- (IPCCustomKeyboard *)keyboard
{
    if (!_keyboard)
        _keyboard = [[IPCCustomKeyboard alloc]initWithFrame:CGRectMake(self.payRecordTableView.jk_right+10, self.payTypeContentView.jk_bottom+10, 408, 377)];
    return _keyboard;
}

#pragma mark // Clicked Events
- (void)reloadRemainAmount
{
    [self.remainPayAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCPayOrderManager sharedManager] remainPayPrice]]];
}

- (void)reloadPayStatus
{
    ///无购物商品 收款记录
    if ([IPCShoppingCart sharedCart].allGlassesCount > 0 && [IPCPayOrderManager sharedManager].payTypeRecordArray.count == 0) {
        self.currentIndex = 0;
    }else if ([IPCShoppingCart sharedCart].allGlassesCount == 0){
        self.currentIndex = -1;
    }
    [self reloadRemainAmount];
}

- (void)resetPayTypeStatus
{
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= 0) {
        self.currentIndex = -1;
    }else{
        self.currentIndex = 0;
    }
    [self reloadRemainAmount];
}

#pragma mark //UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.insertRecord) {
        return [IPCPayOrderManager sharedManager].payTypeRecordArray.count + 1;
    }
    return [IPCPayOrderManager sharedManager].payTypeRecordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.insertRecord && indexPath.row == [IPCPayOrderManager sharedManager].payTypeRecordArray.count)
    {
        IPCPayOrderEditPayCashRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:editRecordCell];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderEditPayCashRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        cell.payRecord = self.insertRecord;
        
        [[cell rac_signalForSelector:@selector(cancelAddRecordAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            self.currentIndex = -1;
            [tableView reloadData];
        }];
        return cell;
    }else{
        IPCPayOrderPayCashRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:recordCell];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderPayCashRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCPayRecord * record = [IPCPayOrderManager sharedManager].payTypeRecordArray[indexPath.row];
        cell.payRecord = record;
        
        [[cell rac_signalForSelector:@selector(removePayRecordAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [[IPCPayOrderManager sharedManager].payTypeRecordArray removeObject:record];
            [self resetPayTypeStatus];
        }];
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [IPCPayOrderManager sharedManager].payTypeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPayCashPayTypeViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:payTypeIdentifier forIndexPath:indexPath];
    IPCPayOrderPayType * payType = [IPCPayOrderManager sharedManager].payTypeArray[indexPath.row];
    cell.payType = payType;
    
    if (self.currentIndex == indexPath.row) {
        [cell updateBorder:YES];
    }else{
        [cell updateBorder:NO];
    }
    
    return cell;
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPayOrderPayType * payType = [IPCPayOrderManager sharedManager].payTypeArray[indexPath.row];
    
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= 0)return;
    
    if (![IPCPayOrderManager sharedManager].integralTrade && [payType.payType isEqualToString:@"积分"]) {
        [IPCCommonUI showError:@"积分规则未配置"];
        return;
    }
    
    if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.integral == 0 && [payType.payType isEqualToString:@"积分"]) {
        [IPCCommonUI showError:@"客户无可用积分"];
        return;
    }
    
    if ([IPCPayOrderCurrentCustomer sharedManager].currentCustomer.balance == 0 && [payType.payType isEqualToString:@"储值卡"]) {
        [IPCCommonUI showError:@"客户无可用储值余额"];
        return;
    }
    
    if (self.currentIndex != indexPath.row) {
        self.currentIndex = indexPath.row;
    }
}

#pragma mark //IPCPayOrderEditPayCashRecordCellDelegate
- (void)reloadRecord:(IPCPayOrderEditPayCashRecordCell *)cell
{
    [self resetPayTypeStatus];
}

#pragma mark //KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentIndex"]) {
        [self.payTypeCollectionView reloadData];
        
        if (self.currentIndex > -1) {
            IPCPayOrderPayType * payType = [IPCPayOrderManager sharedManager].payTypeArray[self.currentIndex];
            
            self.insertRecord = [[IPCPayRecord alloc]init];
            self.insertRecord.payDate = [NSDate date];
            self.insertRecord.payOrderType = payType;
            
            [IPCPayOrderManager sharedManager].isInsertRecord = YES;
        }else{
            self.insertRecord = nil;
            [IPCPayOrderManager sharedManager].isInsertRecord = NO;
        }
        [self.payRecordTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
