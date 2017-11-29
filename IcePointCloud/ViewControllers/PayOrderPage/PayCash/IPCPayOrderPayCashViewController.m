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
#import "IPCCustomKeyboard.h"

static const NSString * recordCell = @"IPCPayOrderPayCashRecordCellIdentifier";
static const NSString * editRecordCell = @"IPCPayOrderEditPayCashRecordCellIdentifier";

@interface IPCPayOrderPayCashViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderEditPayCashRecordCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *payTypeNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *payRecordTableView;
@property (weak, nonatomic) IBOutlet UIView *payTypeContentView;
@property (weak, nonatomic) IBOutlet UIButton *walletButton;
@property (weak, nonatomic) IBOutlet UILabel *remainPayAmountLabel;



@property (nonatomic, strong) IPCCustomKeyboard * keyboard;
@property (nonatomic, strong) IPCPayRecord * insertRecord;

@end

@implementation IPCPayOrderPayCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.payRecordTableView setTableHeaderView:[[UIView alloc]init]];
    [self.payRecordTableView setTableFooterView:[[UIView alloc]init]];
    [self.view addSubview:self.keyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadRemainAmount];
}

#pragma mark //Set UI
- (IPCCustomKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[IPCCustomKeyboard alloc]initWithFrame:CGRectMake(self.payRecordTableView.jk_right+10, self.payTypeContentView.jk_bottom+10, 408, 367)];
    }
    return _keyboard;
}

#pragma mark // Clicked Events
- (IBAction)payTypeAction:(UIButton *)sender
{
    if ((sender.selected && self.insertRecord) || [[IPCPayOrderManager sharedManager] remainPayPrice] == 0)return;
    
    if (sender.tag == 4 && [IPCCurrentCustomer sharedManager].currentCustomer.integral == 0) {
        [IPCCommonUI showError:@"客户无可用积分"];
        return;
    }
    
    if (sender.tag == 3 && [IPCCurrentCustomer sharedManager].currentCustomer.balance == 0) {
        [IPCCommonUI showError:@"客户无可用储值余额"];
        return;
    }
    
    [self.payTypeContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)view;
            [button setSelected:NO];
        }
    }];
    [sender setSelected:YES];
    [self.payTypeNameLabel setText:[self payType:sender.tag]];
    
    self.insertRecord = [[IPCPayRecord alloc]init];
    self.insertRecord.payTypeInfo = [self payType:sender.tag];
    self.insertRecord.payDate = [NSDate date];
    
    [self.payRecordTableView reloadData];
}

- (NSString *)payType:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"现金";
            break;
        case 1:
            return @"支付宝";
            break;
        case 2:
            return @"微信";
            break;
        case 3:
            return @"储值卡";
            break;
        case 4:
            return @"积分";
            break;
        case 5:
            return @"其他";
            break;
        default:
            break;
    }
    return nil;
}

- (void)reload
{
    if ([IPCPayOrderManager sharedManager].payTypeRecordArray.count == 0) {
        self.insertRecord = nil;
        [self.walletButton setSelected:YES];
    }
    [self reloadRemainAmount];
}

- (void)reloadRemainAmount
{
    [self.remainPayAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCPayOrderManager sharedManager] remainPayPrice]]];
    [self.payRecordTableView reloadData];
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
            self.insertRecord = nil;
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
            [self reloadRemainAmount];
        }];
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark //IPCPayOrderEditPayCashRecordCellDelegate
- (void)reloadRecord:(IPCPayOrderEditPayCashRecordCell *)cell
{
    [self reloadRemainAmount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
