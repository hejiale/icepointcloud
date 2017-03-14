//
//  UserDetailInfoViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerDetailViewController.h"
#import "IPCGlassDetailsViewController.h"
#import "IPCHistoryOptometryCell.h"
#import "IPCHistoryOrderCell.h"
#import "IPCCustomerDetailCell.h"
#import "IPCCustomerAddressListCell.h"
#import "IPCCustomerTopTitleCell.h"
#import "IPCCustomerBottomCell.h"
#import "IPCEditAddressView.h"
#import "IPCCustomEditOptometryView.h"
#import "IPCCustomDetailOrderView.h"
#import "IPCCustomerDetailViewMode.h"

static NSString * const topTitleIdentifier    = @"UserBaseTopTitleCellIdentifier";
static NSString * const footLoadIdentifier  = @"UserBaseFootCellIdentifier";
static NSString * const baseIdentifier        = @"UserBaseInfoCellIdentifier";
static NSString * const optometryIdentifier = @"HistoryOptometryCellIdentifier";
static NSString * const orderIdentifier       = @"HistoryOrderCellIdentifier";
static NSString * const addressIdentifier   = @"CustomerAddressListCellIdentifier";

@interface IPCCustomerDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IPCDataPickerViewDataSource,IPCDataPickerViewDelegate,UserDetailInfoCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IPCCustomerDetailViewMode * customerViewMode;
@property (strong, nonatomic) IPCEditAddressView  *  editAddressView;
@property (strong, nonatomic) IPCCustomEditOptometryView * editOptometryView;
@property (strong, nonatomic) IPCCustomDetailOrderView  *  detailOrderView;

@end

@implementation IPCCustomerDetailViewController

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
    
    [self setNavigationTitle:@"个人信息"];
    [self.topBarView addBottomLine];
    [self.cancelButton addTopLine];
    [self.detailTableView setTableHeaderView:[[UIView alloc]init]];
    [self.detailTableView setTableFooterView:[[UIView alloc]init]];
    [self.sureButton setBackgroundColor:COLOR_RGB_BLUE];
    [self commitUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)commitUI{
    [IPCUIKit show];
    [[IPCClient sharedClient] cancelAllRequest];
    self.customerViewMode = [[IPCCustomerDetailViewMode alloc]init];
    self.customerViewMode.customerID = self.customer.customerID;
    self.customerViewMode.customerPhone = self.customer.customerPhone;
    [self.customerViewMode isCanChoose:^(BOOL isCan) {
        [self.sureButton setEnabled:isCan];
        [self.sureButton setAlpha:isCan ? 1 : 0.5];
    }];
    
    __weak typeof (self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [strongSelf.customerViewMode queryCustomerDetailInfo:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.customerViewMode queryHistoryOptometryList:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.customerViewMode queryHistotyOrderList:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [strongSelf.customerViewMode queryCustomerAddressList:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.detailTableView reloadData];
            [IPCUIKit hiden];
        });
    });
}

#pragma mark //Set UI
- (void)loadEditAddressView{
    __weak typeof (self) weakSelf = self;
    self.editAddressView = [[IPCEditAddressView alloc]initWithFrame:self.view.bounds CustomerID:self.customer.customerID Complete:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removerAllPopView];
        [strongSelf.customerViewMode queryCustomerAddressList:^{
            [strongSelf.detailTableView reloadData];
        }];
    } Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removerAllPopView];
    }];
    [self.view addSubview:self.editAddressView];
    [self.view bringSubviewToFront:self.editAddressView];
}

- (void)loadEditOptometryView{
    __weak typeof (self) weakSelf = self;
    self.editOptometryView = [[IPCCustomEditOptometryView alloc]initWithFrame:self.view.bounds CustomerID:self.customer.customerID Complete:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removerAllPopView];
        [strongSelf.customerViewMode.optometryList removeAllObjects];
        [strongSelf.customerViewMode queryHistoryOptometryList:^{
            [strongSelf.detailTableView reloadData];
        }];
    } Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removerAllPopView];
    }];
    [self.view addSubview:self.editOptometryView];
    [self.view bringSubviewToFront:self.editOptometryView];
}

- (void)loadOrderDetailView:(IPCCustomerOrderMode *)orderObject{
    [self.view endEditing:YES];
    __weak typeof (self) weakSelf = self;
    self.detailOrderView = [[IPCCustomDetailOrderView alloc]initWithFrame:self.view.bounds OrderNum:orderObject.orderCode  ProductDetail:^(IPCGlasses *glass) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf pushToProductDetailViewController:glass];
    } Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removerAllPopView];
    }];
    [self.view addSubview:self.detailOrderView];
    [self.view bringSubviewToFront:self.detailOrderView];
    [self.detailOrderView show];
}

#pragma mark //ClickEvents
- (IBAction)backToLastAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/**
 *  Edit Action
 */
- (void)editAddressAction{
    [self.view endEditing:YES];
    [self loadEditAddressView];
}

- (void)editOptometryAction{
    [self.view endEditing:YES];
    [self loadEditOptometryView];
}

/**
 *  Load More
 */
- (void)loadMoreOptometryData{
    __weak typeof (self) weakSelf = self;
    self.customerViewMode.optometryCurrentPage++;
    [self.customerViewMode queryHistoryOptometryList:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.detailTableView reloadData];
    }];
}

- (void)loadMoreOrderData{
    __weak typeof (self) weakSelf = self;
    self.customerViewMode.orderCurrentPage++;
    [self.customerViewMode queryHistotyOrderList:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.detailTableView reloadData];
    }];
}

/**
 *   Choose Customer Opometry
 */
- (IBAction)chooseCustomerOpometryAction:(id)sender {
    __weak typeof (self) weakSelf = self;
    [self.sureButton jk_showIndicator];
    [self.customerViewMode updateUserInfo:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.sureButton jk_hideIndicator];
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
    } Failure:^{
         __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.sureButton jk_hideIndicator];
    }];
}

- (void)pushToProductDetailViewController:(IPCGlasses *)glass{
    IPCGlassDetailsViewController * detailVC = [[IPCGlassDetailsViewController alloc]initWithNibName:@"IPCGlassDetailsViewController" bundle:nil];
    detailVC.glasses = glass;
    [[detailVC rac_signalForSelector:@selector(pushToCartAction:)] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:@"ShowShoppingCartNotification" object:nil];
        [detailVC.navigationController popToRootViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)removerAllPopView{
    [self.editAddressView removeFromSuperview];
    [self.editOptometryView removeFromSuperview];
    [self.detailOrderView removeFromSuperview];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        if (self.customerViewMode.isLoadMoreOptometry)
            return self.customerViewMode.optometryList.count + 2;
        return self.customerViewMode.optometryList.count + 1;
    }else if (section == 2){
        if (self.customerViewMode.isLoadMoreOrder)
            return self.customerViewMode.orderList.count+2;
        return self.customerViewMode.orderList.count > 0 ? self.customerViewMode.orderList.count+1 : 0;
    }
    return self.customerViewMode.addressList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IPCCustomerDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCCustomerDetailCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        if (self.customerViewMode && self.customerViewMode.detailCustomer) {
            cell.currentCustomer = self.customerViewMode.detailCustomer;
            if (self.customerViewMode.isCanEdit)[cell setAllSubViewIsEnable];
            
            __weak typeof (self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(editAction:)] subscribeNext:^(id x) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                if (!strongSelf.customerViewMode.isCanEdit) {
                    strongSelf.customerViewMode.isCanEdit = YES;
                    [cell setAllSubViewIsEnable];
                    [cell.userNameTextField becomeFirstResponder];
                }
            }];
        }
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setButtonTitle:@"历史验光单信息" IsShow:YES];
            __weak typeof (self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(insertAction:)] subscribeNext:^(id x) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf editOptometryAction];
            }];
            return cell;
        }else if (self.customerViewMode.isLoadMoreOptometry && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
            IPCCustomerBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:footLoadIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerBottomCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }else{
            IPCHistoryOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:optometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCHistoryOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode && self.customerViewMode.optometryList.count) {
                IPCOptometryMode * optometry = self.customerViewMode.optometryList[indexPath.row -1];
                [cell setOptometryMode:optometry];
                [cell.selectButton setSelected:[self.customerViewMode.currentOptometryID isEqualToString:optometry.optometryID]];
                __weak typeof (self) weakSelf = self;
                [[cell rac_signalForSelector:@selector(selectOptometryAction:)] subscribeNext:^(id x) {
                    __strong typeof (weakSelf) strongSelf = weakSelf;
                    if ([strongSelf.customerViewMode.currentOptometryID isEqualToString:optometry.optometryID]) {
                        strongSelf.customerViewMode.currentOptometryID = nil;
                    }else{
                        IPCOptometryMode * optometry = strongSelf.customerViewMode.optometryList[indexPath.row-1];
                        strongSelf.customerViewMode.currentOptometryID = optometry.optometryID;
                    }
                    [strongSelf.detailTableView reloadData];
                }];
            }
            return cell;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setButtonTitle:@"历史订单信息" IsShow:NO];
            return cell;
        }else if (self.customerViewMode.isLoadMoreOrder && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
            IPCCustomerBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:footLoadIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerBottomCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }else{
            IPCHistoryOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCHistoryOrderCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode && self.customerViewMode.orderList.count) {
                IPCCustomerOrderMode * order = self.customerViewMode.orderList[indexPath.row-1];
                cell.customerOrder = order;
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setButtonTitle:@"收货地址信息" IsShow:YES];
            __weak typeof (self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(insertAction:)] subscribeNext:^(id x) {
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [strongSelf editAddressAction];
            }];
            return cell;
        }else{
            IPCCustomerAddressListCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerAddressListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode && self.customerViewMode.addressList.count) {
                IPCCustomerAddressMode * address = self.customerViewMode.addressList[indexPath.row-1];
                cell.addressMode = address;
                [cell.chooseButton setSelected:[self.customerViewMode.currentAddressID isEqualToString:address.addressID]];
                __weak typeof (self) weakSelf = self;
                [[cell rac_signalForSelector:@selector(chooseAction:)]subscribeNext:^(id x) {
                    __strong typeof (weakSelf) strongSelf = weakSelf;
                    if ([strongSelf.customerViewMode.currentAddressID isEqualToString:address.addressID]) {
                        strongSelf.customerViewMode.currentAddressID = nil;
                    }else{
                        IPCCustomerAddressMode * address = strongSelf.customerViewMode.addressList[indexPath.row-1];
                        strongSelf.customerViewMode.currentAddressID = address.addressID;
                    }
                    [strongSelf.detailTableView reloadData];
                }];
            }
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 345;
    }else if (indexPath.section == 1 && indexPath.row > 0){
        if (self.customerViewMode.isLoadMoreOptometry && indexPath.row == self.customerViewMode.optometryList.count + 1)
            return 50;
        return 190;
    }else if (indexPath.section == 2 && indexPath.row > 0){
        if (self.customerViewMode.isLoadMoreOrder && indexPath.row == self.customerViewMode.orderList.count + 1)
            return 50;
        return 95;
    }else if ((indexPath.section == 1 && indexPath.row == 0) || (indexPath.section == 2 && indexPath.row == 0) || (indexPath.section == 3 && indexPath.row == 0)){
        return 71;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ((self.customerViewMode.orderList.count == 0 && section == 2) || section == 0)return 0;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [headView setBackgroundColor:[UIColor clearColor]];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if(self.customerViewMode.isLoadMoreOptometry && indexPath.row == self.customerViewMode.optometryList.count + 1){
            [self loadMoreOptometryData];
        }
    }else if (indexPath.section == 2 && indexPath.row > 0) {
        if (self.customerViewMode.isLoadMoreOrder && indexPath.row == self.customerViewMode.orderList.count + 1) {
            [self loadMoreOrderData];
        }else{
            IPCCustomerOrderMode * order = self.customerViewMode.orderList[indexPath.row-1];
            [self loadOrderDetailView:order];
        }
    }
}

#pragma mark //UserDetailInfoCellDelegate
- (void)reloadCustomer:(IPCDetailCustomer *)customer{
    self.customerViewMode.detailCustomer = customer;
    [self.detailTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
