//
//  IPCManagerOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerOptometryViewController.h"
#import "IPCManagerOptometryViewModel.h"
#import "IPCEditOptometryView.h"
#import "IPCManagerOptometryCell.h"

static NSString * const managerIdentifier = @"IPCManagerOptometryCellIdentifier";

@interface IPCManagerOptometryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *optometryTableView;
@property (strong, nonatomic) IPCEditOptometryView * editOptometryView;
@property (strong, nonatomic) IPCManagerOptometryViewModel * managerViewModel;

@end

@implementation IPCManagerOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBarStatus:NO];
    [self setNavigationTitle:@"验光单"];
    [self setRightTitle:@"添加" Selection:@selector(insertNewOptometryAction)];
    [self.optometryTableView setTableFooterView:[[UIView alloc]init]];
    
    __weak typeof(self) weakSelf = self;
    [self.managerViewModel queryCustomerOptometryList:^(BOOL canLoadMore) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.optometryTableView reloadData];
    }];
}

- (void)setCustomerId:(NSString *)customerId
{
    _customerId = customerId;
    
    if (_customerId) {
        self.managerViewModel = [[IPCManagerOptometryViewModel alloc]init];
        self.managerViewModel.customerId = _customerId;
    }
}

#pragma mark //Set UI
- (IPCEditOptometryView *)editOptometryView{
    if (!_editOptometryView) {
        _editOptometryView = [[IPCEditOptometryView alloc]initWithFrame:self.view.bounds
                                                             CustomerID:self.managerViewModel.customerId
                                                               Complete:^(NSString *optometryId) {
            
        } Dismiss:^{
            
        }];
    }
    return _editOptometryView;
}

#pragma mark //Clicked Events
- (void)insertNewOptometryAction
{
    [self.view addSubview:self.editOptometryView];
    [self.view bringSubviewToFront:self.editOptometryView];
}


#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.managerViewModel.optometryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCManagerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:managerIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCManagerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCOptometryMode * optometry = self.managerViewModel.optometryList[indexPath.row];
    cell.optometryMode = optometry;
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
