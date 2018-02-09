//
//  LoginHistoryViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCLoginHistoryViewController.h"

static NSString * const historyIdentifier = @"HistoryCellIdentifier";

@interface IPCLoginHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (nonatomic, strong) NSMutableArray<NSString *> * loginHistory;
@property (nonatomic, strong) UIPopoverController * popoverController;

@end

@implementation IPCLoginHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.historyTableView setTableFooterView:[[UIView alloc]init]];
    [self.loginHistory addObjectsFromArray:[IPCAppManager sharedManager].loginAccountHistory];
    [self.historyTableView reloadData];
}


- (NSMutableArray<NSString *> *)loginHistory{
    if (!_loginHistory) {
        _loginHistory = [[NSMutableArray alloc]init];
    }
    return _loginHistory;
}

- (void)showWithSize:(CGSize)size Position:(CGPoint)position Owner:(UIView *)owner
{
    self.popoverController = [[UIPopoverController alloc]initWithContentViewController:self];
    [self.popoverController setDelegate:self];
    self.popoverController.popoverContentSize = size;
    [self.popoverController presentPopoverFromRect:CGRectMake(position.x, position.y, 1, 1) inView:owner permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark //UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return YES;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loginHistory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setText:self.loginHistory[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.delegate respondsToSelector:@selector(chooseHistoryLoginName:)]){
        [self.delegate chooseHistoryLoginName:self.loginHistory[indexPath.row]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.loginHistory = nil;
    self.view = nil;
}



@end
