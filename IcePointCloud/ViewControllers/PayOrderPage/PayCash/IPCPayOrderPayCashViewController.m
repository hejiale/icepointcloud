//
//  IPCPayOrderPayCashViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderPayCashViewController.h"
#import "IPCPayOrderPayCashRecordCell.h"

static const NSString * recordCell = @"IPCPayOrderPayCashRecordCellIdentifier";

@interface IPCPayOrderPayCashViewController ()<UITableViewDelegate,UITableViewDataSource,IPCParameterTableViewDelegate,IPCParameterTableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payRecordTableView;
@property (weak, nonatomic) IBOutlet UIView *cashEditContentView;
@property (weak, nonatomic) IBOutlet UIView *pointEditContentView;
@property (weak, nonatomic) IBOutlet UITextField *payAmountTextField;
@property (weak, nonatomic) IBOutlet UIImageView *selectPayTypeImageView;
@property (weak, nonatomic) IBOutlet UIView *payTypeContentView;
@property (strong, nonatomic) IPCDynamicImageTextButton *payTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *remainPayAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *pointTextField;
@property (weak, nonatomic) IBOutlet UILabel *pointPriceLabel;

@end

@implementation IPCPayOrderPayCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.payRecordTableView setTableHeaderView:[[UIView alloc]init]];
    [self.payRecordTableView setTableFooterView:[[UIView alloc]init]];
    [self.payTypeButton setButtonAlignment:IPCCustomButtonAlignmentLeft];
    [self.payAmountTextField addBottomLine];
    [self.pointTextField addBottomLine];
    [self.payTypeContentView addSubview:self.payTypeButton];
    
    [self.payTypeButton setTitle:@"现金"];
    [self.selectPayTypeImageView setImage:[[IPCAppManager sharedManager] payTypeImage:@"现金"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadRemainAmount];
}

#pragma mark //Set UI
- (IPCDynamicImageTextButton *)payTypeButton{
    if (!_payTypeButton) {
        _payTypeButton = [[IPCDynamicImageTextButton alloc]initWithFrame:self.payTypeContentView.bounds];
        [_payTypeButton setImage:[UIImage imageNamed:@"icon_down_arrow"] forState:UIControlStateNormal];
        [_payTypeButton setTitleColor:[UIColor darkGrayColor]];
        [_payTypeButton setFont:[UIFont systemFontOfSize:14]];
        [_payTypeButton setButtonAlignment:IPCCustomButtonAlignmentLeft];
        [_payTypeButton addTarget:self action:@selector(selectPayRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payTypeButton;
}

#pragma mark // Clicked Events
- (void)selectPayRecordAction:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCParameterTableViewController * pickerVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate     = self;
    [pickerVC showWithPosition:CGPointMake(sender.jk_width/2, 30) Size:CGSizeMake(150, 270) Owner:sender Direction:UIPopoverArrowDirectionUp];
}


- (IBAction)addPayRecordAction:(id)sender
{
    IPCPayRecord * insertRecord = [[IPCPayRecord alloc]init];
    insertRecord.payDate = [NSDate date];
    insertRecord.payTypeInfo = self.payTypeButton.title;
    if ([self.payTypeButton.title isEqualToString:@"积分"]) {
        insertRecord.integral = [self.pointTextField.text integerValue];
        insertRecord.pointPrice = [[self.pointPriceLabel.text substringFromIndex:1] doubleValue];
    }else{
        insertRecord.payPrice = [self.payAmountTextField.text doubleValue];
    }
    [[IPCPayOrderManager sharedManager].payTypeRecordArray addObject:insertRecord];
    
    [self.payRecordTableView reloadData];
    [self reloadRemainAmount];
}

- (void)reload
{
    [[IPCPayOrderManager sharedManager].payTypeRecordArray removeAllObjects];
    [self.payAmountTextField setText:@"0"];
    [self.pointTextField setText:[NSString stringWithFormat:@"%.f",[IPCPayOrderManager sharedManager].integralTrade.integral]];
    [self.pointPriceLabel setText:[NSString stringWithFormat:@"%.2f",[IPCPayOrderManager sharedManager].integralTrade.money]];
    [self reloadRemainAmount];
    
}

- (void)reloadRemainAmount
{
    if ([self.payTypeButton.title isEqualToString:@"积分"]) {
        [self.cashEditContentView setHidden:YES];
        [self.pointEditContentView setHidden:NO];
    }else{
        [self.pointEditContentView setHidden:YES];
        [self.cashEditContentView setHidden:NO];
    }
    [self.remainPayAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCPayOrderManager sharedManager] remainPayPrice]]];
    [self.payRecordTableView reloadData];
    
}

#pragma mark //UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [IPCPayOrderManager sharedManager].payTypeRecordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    if ([IPCPayOrderManager sharedManager].integralTrade && [IPCCurrentCustomer sharedManager].currentCustomer.integral > 0) {
        return @[@"现金",@"支付宝",@"微信",@"储值卡",@"积分",@"其他"];
    }
    return @[@"现金",@"支付宝",@"微信",@"储值卡",@"其他"];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    [self.payTypeButton setTitle: parameter];
    [self.selectPayTypeImageView setImage:[[IPCAppManager sharedManager] payTypeImage:parameter]];
    [self reloadRemainAmount];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![IPCCommon judgeIsFloatNumber:string]) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    double pointPrice =  ([textField.text doubleValue] * [IPCPayOrderManager sharedManager].integralTrade.money)/[IPCPayOrderManager sharedManager].integralTrade.integral;
    
    if ([textField isEqual:self.pointTextField]) {
        if (pointPrice >= [[IPCPayOrderManager sharedManager] remainPayPrice]) {
            [self.pointTextField setText:@"0"];
        }else{
            [self.pointPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", pointPrice]];
        }
    }else{
        if ([textField.text doubleValue] >= [[IPCPayOrderManager sharedManager] remainPayPrice]) {
            [textField setText:[NSString stringWithFormat:@"%.2f",[[IPCPayOrderManager sharedManager] remainPayPrice]]];
        }else{
            [textField setText:[NSString stringWithFormat:@"%.2f",[textField.text doubleValue]]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
