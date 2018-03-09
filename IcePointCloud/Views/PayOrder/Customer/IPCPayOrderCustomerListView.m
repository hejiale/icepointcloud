//
//  IPCPayOrderCustomerListView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerListView.h"
#import "IPCCustomerListViewModel.h"
#import "IPCPayOrderCustomerCollectionViewCell.h"
#import "IPCPayOrderMemberCollectionViewCell.h"

static NSString * const customerIdentifier = @"IPCPayOrderCustomerCollectionViewCellIdentifier";
static NSString * const memberIdentifier = @"IPCPayOrderMemberCollectionViewCellIdentifier";

@interface IPCPayOrderCustomerListView()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
{
    BOOL  chooseStatus;
    BOOL  isSelectMember;
    NSString * currentSelectCustomer;//绑定会员时选择客户的临时参数
}
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (weak, nonatomic) IBOutlet UIView *searchTypeView;
@property (weak, nonatomic) IBOutlet UIView *rightButtonView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *insertButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonViewWidth;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter    *refreshFooter;
@property (nonatomic, strong) IPCCustomerListViewModel    * viewModel;
@property (nonatomic, strong) IPCDynamicImageTextButton * typeButton;
@property (nonatomic, copy) void(^DetailBlock)(IPCCustomerMode* customer, BOOL isMemberReload);
@property (nonatomic, copy) void(^IsSelectMemberBlock)(BOOL isMember);

@end

@implementation IPCPayOrderCustomerListView

- (instancetype)initWithFrame:(CGRect)frame  IsChooseStatus:(BOOL)isChoose Detail:(void(^)(IPCCustomerMode * customer, BOOL isMemberReload))detail SelectType:(void(^)(BOOL isSelectMemeber))isMember
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderCustomerListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        chooseStatus = isChoose;
        self.DetailBlock = detail;
        self.IsSelectMemberBlock = isMember;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self loadCollectionView];
    if (!chooseStatus) {
        [self reloadCollectionViewUI];
        [self.rightButtonView addSubview:self.typeButton];
    }else{
        self.rightButtonViewWidth.constant = 0;
    }
    self.viewModel = [[IPCCustomerListViewModel alloc]init];
    [self loadData];
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = 0;
    CGFloat itemHeight = 0;
    
    if (chooseStatus) {
        itemWidth = (self.jk_width-10)/2;
        itemHeight = (self.jk_height-40-60)/5;
    }else{
        itemWidth = (self.jk_width-20)/3;
        itemHeight = (self.jk_height-60-60)/7;
    }
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    [_customerCollectionView setCollectionViewLayout:layout];
    _customerCollectionView.emptyAlertImage = @"exception_search";
    _customerCollectionView.emptyAlertTitle = @"未查询到客户信息!";
    _customerCollectionView.mj_header = self.refreshHeader;
    _customerCollectionView.mj_footer = self.refreshFooter;
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCPayOrderCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCPayOrderMemberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:memberIdentifier];
}

- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    return _refreshFooter;
}

- (IPCDynamicImageTextButton *)typeButton{
    if (!_typeButton) {
        _typeButton = [[IPCDynamicImageTextButton alloc]initWithFrame:self.rightButtonView.bounds];
        [_typeButton setImage:[UIImage imageNamed:@"icon_down_arrow"] forState:UIControlStateNormal];
        [_typeButton setTitleColor:COLOR_RGB_BLUE];
        [_typeButton setTitle:@"客户"];
        [_typeButton setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]];
        [_typeButton setButtonAlignment:IPCCustomButtonAlignmentLeft];
        [_typeButton addTarget:self action:@selector(selectSearchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeButton;
}

#pragma mark //Refresh Methods
- (void)beginRefresh
{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [IPCHttpRequest  cancelAllRequest];
    }
    [self.refreshFooter resetDataStatus];
    [self.viewModel resetData];
    if (isSelectMember) {
        [self loadMemberList];
    }else{
        [self loadCustomerList];
    }
}

- (void)loadMore
{
    self.viewModel.currentPage++;
    if (isSelectMember) {
        [self loadMemberList];
    }else{
        [self loadCustomerList];
    }
}

#pragma mark //Load Data
- (void)loadData
{
    [self.viewModel resetData];
    self.customerCollectionView.isBeginLoad = YES;
    
    if (isSelectMember) {
        [self loadMemberList];
    }else{
        [self loadCustomerList];
    }
    [self.customerCollectionView reloadData];
}

#pragma mark //Request Data
- (void)loadCustomerList
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerListWithIsChooseStatus:chooseStatus Complete:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.viewModel.status == IPCFooterRefresh_HasNoMoreData) {
            [strongSelf.refreshFooter noticeNoDataStatus];
        }else if (strongSelf.viewModel.status == IPCRefreshError){
            if ([error code] != NSURLErrorCancelled) {
                [IPCCommonUI showError:@"查询客户失败,请稍后重试!"];
            }
        }
        [weakSelf reload];
    }];
}

- (void)loadMemberList
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryMemberList:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.viewModel.status == IPCFooterRefresh_HasNoMoreData) {
            [strongSelf.refreshFooter noticeNoDataStatus];
        }else if (strongSelf.viewModel.status == IPCRefreshError){
            if ([error code] != NSURLErrorCancelled) {
                [IPCCommonUI showError:@"查询会员失败,请稍后重试!"];
            }
        }
        [weakSelf reload];
    }];
}

#pragma mark //Reload CollectionView
- (void)reload
{
    self.customerCollectionView.isBeginLoad = NO;
    [self.customerCollectionView reloadData];
    [self stopRefresh];
}

- (void)stopRefresh
{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark //Clicked Events
- (IBAction)searchWithCustomerAction:(id)sender {
    isSelectMember = NO;
    [self.searchTypeView setHidden:YES];
    [self.typeButton setTitle:@"客户"];
    if (self.IsSelectMemberBlock) {
        self.IsSelectMemberBlock(NO);
    }
    [self reloadCollectionViewUI];
    [self loadData];
}


- (IBAction)searchWithMemberAction:(id)sender {
    isSelectMember = YES;
    [self.searchTypeView setHidden:YES];
    [self.typeButton setTitle:@"会员"];
    if (self.IsSelectMemberBlock) {
        self.IsSelectMemberBlock(YES);
    }
    [self reloadCollectionViewUI];
    [self loadData];
}


- (IBAction)insertCustomerAction:(id)sender {
}

- (void)reloadCollectionViewUI
{
    if (isSelectMember) {
        self.collectionViewBottom.constant = 0;
        [self.insertButton setHidden:YES];
    }else{
        CGFloat itemHeight = (self.jk_height-30-60)/7;
        self.collectionViewBottom.constant = itemHeight + 5;
        [self.insertButton setHidden:NO];
    }
}

- (void)selectSearchTypeAction:(id)sender{
    if (self.searchTypeView.isHidden) {
        [self.searchTypeView setHidden:NO];
    }else{
        [self.searchTypeView setHidden:YES];
    }
}

- (void)changeToCustomerStatus
{
    isSelectMember = NO;
    [self.typeButton setTitle:@"客户"];
    [self reloadCollectionViewUI];
    [self loadData];
}

- (void)changeToMemberStatus
{
    isSelectMember = YES;
    [self.typeButton setTitle:@"会员"];
    [self reloadCollectionViewUI];
    [self loadData];
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.customerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSelectMember) {
        IPCPayOrderMemberCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:memberIdentifier forIndexPath:indexPath];
        
        if (self.viewModel && self.viewModel.customerArray.count) {
            IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
            cell.currentCustomer = customer;
        }
        return cell;
    }else{
        IPCPayOrderCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
        
        if (self.viewModel && self.viewModel.customerArray.count) {
            IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
            if (chooseStatus) {
                cell.selectCustomerId = currentSelectCustomer;
            }else{
                cell.selectCustomerId = [IPCPayOrderManager sharedManager].currentCustomerId;
            }
            cell.currentCustomer = customer;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Prereload Data
    if (self.viewModel.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.viewModel.customerArray.count -10) {
                [self.refreshFooter beginRefreshing];
            }
        }
    }
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.customerArray.count) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        [IPCPayOrderManager sharedManager].isValiateMember = NO;
        [IPCPayOrderManager sharedManager].memberCheckType = @"NULL";
        [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = nil;
        
        if (isSelectMember) {
            if ([customer.memberCustomerId isEqualToString:[IPCPayOrderManager sharedManager].currentMemberCustomerId])return;
            
            if (customer) {
                [IPCPayOrderManager sharedManager].currentCustomerId = nil;
                [IPCPayOrderCurrentCustomer sharedManager].currentCustomer = nil;
                [IPCPayOrderCurrentCustomer sharedManager].currentMemberCustomer = nil;
                
                [IPCPayOrderCurrentCustomer sharedManager].currentMember = customer;
                [IPCPayOrderManager sharedManager].currentMemberCustomerId = customer.memberCustomerId;
                [IPCPayOrderManager sharedManager].customDiscount = [[IPCShoppingCart sharedCart] customDiscount];
            }
        }else{
            if (!chooseStatus) {
                if ([customer.customerID isEqualToString:[IPCPayOrderManager sharedManager].currentCustomerId])return;
            }
            
            if (customer) {
                if (!chooseStatus) {
                    [IPCPayOrderCurrentCustomer sharedManager].currentMember = nil;
                    [IPCPayOrderCurrentCustomer sharedManager].currentMemberCustomer = nil;
                    [IPCPayOrderManager sharedManager].currentMemberCustomerId = nil;
                    
                    [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
                    [IPCPayOrderCurrentCustomer sharedManager].currentCustomer = customer;
                    [IPCPayOrderManager sharedManager].customDiscount = [[IPCShoppingCart sharedCart] customDiscount];
                }else{
                    currentSelectCustomer = customer.customerID;
                }
            }
        }
        
        if (self.DetailBlock) {
            self.DetailBlock(customer, isSelectMember);
        }
        [collectionView reloadData];
    }
}


#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.viewModel.searchWord = [textField.text jk_trimmingWhitespace];
    [self loadData];
}


@end
