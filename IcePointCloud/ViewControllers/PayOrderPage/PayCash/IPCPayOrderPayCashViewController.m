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

@interface IPCPayOrderPayCashViewController ()<UITableViewDelegate,UITableViewDataSource,IPCParameterTableViewDelegate,IPCParameterTableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *payRecordTableView;
@property (weak, nonatomic) IBOutlet UITextField *payAmountTextField;
@property (weak, nonatomic) IBOutlet UIImageView *selectPayTypeImageView;
@property (weak, nonatomic) IBOutlet IPCStaticImageTextButton *payTypeButton;


@end

@implementation IPCPayOrderPayCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.payRecordTableView setTableHeaderView:[[UIView alloc]init]];
    [self.payRecordTableView setTableFooterView:[[UIView alloc]init]];
    [self.payTypeButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft];
}

#pragma mark // Clicked Events
- (IBAction)addNewPayRecordAction:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCParameterTableViewController * pickerVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate     = self;
    [pickerVC showWithPosition:CGPointMake(sender.jk_width/2, 30) Size:CGSizeMake(150, 270) Owner:sender Direction:UIPopoverArrowDirectionUp];
}

#pragma mark //UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCPayOrderPayCashRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:recordCell];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCPayOrderPayCashRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    return @[@"现金",@"支付宝",@"微信",@"储值卡",@"积分",@"其他"];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
//    [self.payTypeTextField setText:parameter];
//    [IPCPayOrderManager sharedManager].insertPayRecord.payTypeInfo = parameter;
//
//    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
//            [self.delegate reloadUI];
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
