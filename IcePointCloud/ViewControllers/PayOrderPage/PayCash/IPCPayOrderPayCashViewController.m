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
#import "IPCPayCashCustomerListView.h"
#import "IPCPayCashMemberCardView.h"
#import "IPCScanCodeViewController.h"

static  NSString * const recordCell = @"IPCPayOrderPayCashRecordCellIdentifier";
static  NSString * const editRecordCell = @"IPCPayOrderEditPayCashRecordCellIdentifier";
static  NSString * const payTypeIdentifier = @"IPCPayCashPayTypeViewCellIdentifier";

@interface IPCPayOrderPayCashViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderEditPayCashRecordCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,IPCCustomTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payRecordTableView;
@property (weak, nonatomic) IBOutlet UIView *payTypeContentView;
@property (weak, nonatomic) IBOutlet UILabel *remainPayAmountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *payTypeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *introduceTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *introducerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceButtonWidth;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIButton *couponTitleButton;
@property (weak, nonatomic) IBOutlet UILabel *couponDeductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *payRecordLabel;
@property (weak, nonatomic) IBOutlet UIView *inputPointView;
@property (weak, nonatomic) IBOutlet UILabel *usePointLabel;
@property (weak, nonatomic) IBOutlet UIView *usePointView;
@property (weak, nonatomic) IBOutlet UILabel *pointAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *editPointButton;
@property (weak, nonatomic) IBOutlet UIView *editPointView;
@property (weak, nonatomic) IBOutlet UIView *editCouponView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editPointTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editCouponTopConstraint;
@property (nonatomic, strong) IPCPortraitNavigationViewController * cameraNav;
@property (strong, nonatomic) UIImageView * scrollLineImageView;
@property (strong, nonatomic) IPCPayCashCustomerListView *selectCustomerCoverView;
@property (strong, nonatomic) IPCPayCashMemberCardView * memberCardView;
@property (nonatomic, strong) IPCCustomKeyboard * keyboard;
@property (nonatomic, strong) IPCPayRecord * insertRecord;
@property (nonatomic, strong) IPCPayCashAllCoupon * allCoupon;
@property (nonatomic, strong) IPCCustomTextField * inputPointTextField;
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
    
    if ([IPCPayOrderManager sharedManager].payTypeArray.count > 8) {
        [self.scrollContentView addSubview:self.scrollLineImageView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    [[IPCTextFiledControl instance] clearPreTextField];
    
    [self reloadPayStatus];
    
    if ([IPCPayOrderManager sharedManager].isChooseOther) {
        //查询卡券信息
        [self queryCouponList];
        [IPCPayOrderManager sharedManager].isChooseOther = NO;
    }
    //刷新不同状态显示积分或卡券页面
    if (![IPCPayOrderManager sharedManager].pointPayType) {
        self.pointHeightConstraint.constant = 0;
        self.editPointTopConstraint.constant = 0;
        [self.editPointView setHidden:YES];
    }
    if (![IPCPayOrderManager sharedManager].couponPayType) {
        self.couponHeightConstraint.constant = 0;
        self.editCouponTopConstraint.constant = 0;
        [self.editCouponView setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeObserver:self forKeyPath:@"currentIndex"];
}

#pragma mark //Set UI
- (IPCCustomKeyboard *)keyboard
{
    if (!_keyboard)
        _keyboard = [[IPCCustomKeyboard alloc]initWithFrame:CGRectMake(self.payRecordTableView.jk_right+10, self.payTypeContentView.jk_bottom+10, 408, 377)];
    return _keyboard;
}

- (UIImageView *)scrollLineImageView{
    if (!_scrollLineImageView) {
        _scrollLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollContentView.jk_right-2, 0, 2, self.scrollContentView.jk_height*2/3)];
        [_scrollLineImageView setBackgroundColor:[UIColor colorWithHexString:@"#999999"]];
    }
    return _scrollLineImageView;
}

- (IPCPayCashCustomerListView *)selectCustomerCoverView{
    if (!_selectCustomerCoverView) {
        __weak typeof(self) weakSelf = self;
        _selectCustomerCoverView = [[IPCPayCashCustomerListView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                                           Complete:^(IPCCustomerMode *customer)
                                    {
                                        [IPCPayOrderManager sharedManager].introducer = customer;
                                        [weakSelf reloadIntroducer];
                                    }];
    }
    return _selectCustomerCoverView;
}

- (IPCPayCashMemberCardView *)memberCardView{
    if (!_memberCardView) {
        _memberCardView = [[IPCPayCashMemberCardView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                                  Coupon:self.allCoupon
                                                                Complete:^{
                                                                    [self reloadPayStatus];
                                                                }];
    }
    return _memberCardView;
}

- (IPCCustomTextField *)inputPointTextField
{
    if (!_inputPointTextField) {
        _inputPointTextField = [[IPCCustomTextField alloc]initWithFrame:self.inputPointView.bounds];
        [_inputPointTextField setDelegate:self];
        _inputPointTextField.leftSpace = 5;
    }
    return _inputPointTextField;
}

- (void)reloadIntroducer
{
    if ([IPCPayOrderManager sharedManager].introducer) {
        [self.introducerButton setTitle:[IPCPayOrderManager sharedManager].introducer.customerName forState:UIControlStateNormal];
    }else{
        [self.introducerButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
    
    CGFloat width = [self.introducerButton.titleLabel.text jk_sizeWithFont:self.introducerButton.titleLabel.font constrainedToHeight:self.introducerButton.jk_height].width;
    self.introduceButtonWidth.constant = MAX(width, 70);
}

#pragma mark //Request Data
- (void)queryCouponList
{
    if ([[[IPCPayOrderManager sharedManager] currentMemberId] integerValue] > 0) {
        [IPCCommonUI show];
        
        [IPCPayOrderRequestManager getCouponListWithMemberId:[[IPCPayOrderManager sharedManager] currentMemberId]
                                                       Price:[[IPCPayOrderManager sharedManager] remainPayPrice]
                                                SuccessBlock:^(id responseValue)
         {
             self.allCoupon = [[IPCPayCashAllCoupon alloc]initWithResponseValue:responseValue];
             [self.couponTitleButton setTitle:[NSString stringWithFormat:@"%d张可用",self.allCoupon.canUseCouponCount ] forState:UIControlStateNormal];
             [IPCCommonUI hiden];
         } FailureBlock:^(NSError *error) {
             
         }];
    }else{
        self.allCoupon = nil;
        [self.couponTitleButton setTitle:@"无可用卡券" forState:UIControlStateNormal];
    }
}

- (void)scanCouponCode:(NSString *)code
{
    [IPCPayOrderRequestManager scanCouponCodeWithMemberId:[[IPCPayOrderManager sharedManager] currentMemberId]
                                                    Price:[[IPCPayOrderManager sharedManager] remainPayPrice]
                                                     Code:code
                                             SuccessBlock:^(id responseValue)
     {
         IPCPayOrderCoupon * coupon = [IPCPayOrderCoupon mj_objectWithKeyValues:responseValue];
         [IPCPayOrderManager sharedManager].coupon = coupon;
         [self refreshCouponAmount];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:error.domain];
     }];
}

- (void)refreshCouponAmount
{
    if ([[IPCPayOrderManager sharedManager] remainNoneCouponPayPrice] < [IPCPayOrderManager sharedManager].coupon.denomination) {
        [IPCPayOrderManager sharedManager].couponAmount = [[IPCPayOrderManager sharedManager] remainNoneCouponPayPrice];
    }else{
        [IPCPayOrderManager sharedManager].couponAmount  = [IPCPayOrderManager sharedManager].coupon.denomination;
    }
    [self reloadRemainAmount];
}

#pragma mark // Clicked Events
- (IBAction)selectIntroducerAction:(id)sender
{
    if (self.selectCustomerCoverView) {
        self.selectCustomerCoverView = nil;
    }
    [[IPCCommonUI currentView] addSubview:self.selectCustomerCoverView];
}


- (IBAction)useCouponAction:(id)sender {
    if ([[IPCPayOrderManager sharedManager] remainNoneCouponPayPrice] > 0) {
        if (self.memberCardView) {
            self.memberCardView = nil;
        }
        [[IPCCommonUI currentView] addSubview:self.memberCardView];
    }else{
        [IPCCommonUI showError:@"剩余应付金额为零"];
    }
}


- (IBAction)editPointAction:(id)sender {
    [self editPointStatus:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IPCPayCashChangeEditStatus" object:nil];
}



- (IBAction)scanCodeAction:(id)sender {
    if ([[[IPCPayOrderManager sharedManager] currentMemberId] integerValue] > 0) {
        if ([[IPCPayOrderManager sharedManager] remainNoneCouponPayPrice] == 0) {
            [IPCCommonUI showError:@"剩余应付金额为零"];
            return;
        }
        __weak typeof(self) weakSelf = self;
        IPCScanCodeViewController *scanVc = [[IPCScanCodeViewController alloc] initWithFinish:^(NSString *result, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.cameraNav dismissViewControllerAnimated:YES completion:^{
                [weakSelf scanCouponCode:result];
            }];
        }];
        self.cameraNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:scanVc];
        [self presentViewController:self.cameraNav  animated:YES completion:nil];
    }else{
        [IPCCommonUI showError:@"该客户为非会员，无卡券可用"];
    }
}


- (void)reloadPayStatus
{
    ///无购物商品 收款记录
    if ([IPCShoppingCart sharedCart].allGlassesCount > 0 && [[IPCPayOrderManager sharedManager] remainPayPrice] > 0) {
        self.currentIndex = 0;
    }else if ([IPCShoppingCart sharedCart].allGlassesCount == 0 || [[IPCPayOrderManager sharedManager] remainPayPrice] <= 0){
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

- (void)reloadRemainAmount
{
    [self.remainPayAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCPayOrderManager sharedManager] remainPayPrice]]];
    [self.couponDeductionLabel setText:[NSString stringWithFormat:@"本次抵扣:￥%.2f",[[IPCPayOrderManager sharedManager] totalCouponPointPrice]]];
    [self.payRecordLabel setText:[NSString stringWithFormat:@"本次收款:￥%.2f",[[IPCPayOrderManager sharedManager] payRecordTotalPrice]]];
    [self.pointAmountLabel setText:[NSString stringWithFormat:@"￥%.2f", [IPCPayOrderManager sharedManager].pointRecord.pointPrice]];
    [self.usePointLabel setText:[NSString stringWithFormat:@"%d", [IPCPayOrderManager sharedManager].pointRecord.integral]];
    
    if ([IPCPayOrderManager sharedManager].couponAmount > 0) {
        [self.couponTitleButton setTitle:[NSString stringWithFormat:@"￥%.f", [IPCPayOrderManager sharedManager].couponAmount] forState:UIControlStateNormal];
    }else{
        [self.couponTitleButton setTitle:[NSString stringWithFormat:@"%d张可用",self.allCoupon.canUseCouponCount ] forState:UIControlStateNormal];
    }
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
        
        __weak typeof(self) weakSelf = self;
        [[cell rac_signalForSelector:@selector(removePayRecordAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [[IPCPayOrderManager sharedManager].payTypeRecordArray removeObject:record];
            [weakSelf resetPayTypeStatus];
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
    IPCCustomerMode * member = [[IPCPayOrderManager sharedManager] currentMemberCard];
    IPCCustomerMode * customer = [[IPCPayOrderManager sharedManager] currentCustomer];
    
    if (!customer) {
        [IPCCommonUI showError:@"请先选择客户或会员卡!"];
        return;
    }
    
    IPCPayOrderPayType * payType = [IPCPayOrderManager sharedManager].payTypeArray[indexPath.row];
    
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= 0)return;
    
    if (![IPCPayOrderManager sharedManager].integralTrade && [payType.payType isEqualToString:@"积分"]) {
        [IPCCommonUI showError:@"积分规则未配置"];
        return;
    }
    
    if (![IPCPayOrderManager sharedManager].isValiateMember) {
        if (member.integral > 0 && [payType.payType isEqualToString:@"积分"]) {
            [IPCCommonUI showError:@"请先验证会员"];
            return;
        }
    }
    
    if (member.integral == 0 && [payType.payType isEqualToString:@"积分"]) {
        [IPCCommonUI showError:@"客户无可用积分"];
        return;
    }
    
    if (![IPCPayOrderManager sharedManager].isValiateMember) {
        if (member.balance > 0 && [payType.payType isEqualToString:@"储值卡"]) {
            [IPCCommonUI showError:@"请先验证会员"];
            return;
        }
    }
    
    if (member.balance == 0 && [payType.payType isEqualToString:@"储值卡"]) {
        [IPCCommonUI showError:@"客户无可用储值余额"];
        return;
    }
    
    if (self.currentIndex != indexPath.row) {
        self.currentIndex = indexPath.row;
        [self.payRecordTableView scrollViewToBottom:YES];
    }
}

#pragma mark //IPCPayOrderEditPayCashRecordCellDelegate
- (void)reloadRecord:(IPCPayOrderEditPayCashRecordCell *)cell
{
    [self resetPayTypeStatus];
    [self.payRecordTableView scrollViewToBottom:YES];
}

#pragma mark //KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentIndex"]) {
        if (self.currentIndex > -1) {
            [self hidenEditPointStatus];
            
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
        [self.payTypeCollectionView reloadData];
    }
}

#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.payTypeCollectionView]) {
        CGPoint offset = scrollView.contentOffset;
        CGFloat offsetY = offset.y*(scrollView.jk_height-self.scrollLineImageView.jk_height)/(scrollView.contentSize.height-scrollView.jk_height);
        
        CGRect frame= self.scrollLineImageView.frame;
        frame.origin.y= MAX(offsetY, 0);
        self.scrollLineImageView.frame = frame;
    }
}

#pragma mark //UITextFieldDelegate
- (void)textFieldEndEditing:(IPCCustomTextField *)textField
{
    if (!self.view.superview) {
        return;
    }
    IPCCustomerMode * customer = [[IPCPayOrderManager sharedManager] currentMemberCard];
    NSString * remainPriceStr = [NSString stringWithFormat:@"%f", [[IPCPayOrderManager sharedManager] remainNonePointPayPrice]];

    double pointPrice =  ([textField.text doubleValue] * [IPCPayOrderManager sharedManager].integralTrade.money)/[IPCPayOrderManager sharedManager].integralTrade.integral;

    NSInteger maxPoint = 0;
    
    if (customer.integral > 0) {
        maxPoint = ceil(([[IPCPayOrderManager sharedManager] remainNonePointPayPrice] * [IPCPayOrderManager sharedManager].integralTrade.integral) / [IPCPayOrderManager sharedManager].integralTrade.money);
    }
    
    if ([textField.text integerValue] > maxPoint){
        [IPCCommonUI showError:@"输入积分大于可使用积分"];
    }else{
        IPCPayRecord * payRecord = [[IPCPayRecord alloc]init];
        if (pointPrice > [[IPCPayOrderManager sharedManager] remainNonePointPayPrice]) {
            payRecord.pointPrice = [[IPCPayOrderManager sharedManager] remainNonePointPayPrice];
        }else{
            payRecord.pointPrice = pointPrice;
        }
        payRecord.integral = [textField.text integerValue];
        [IPCPayOrderManager sharedManager].pointRecord = payRecord;
    }
    [self editPointStatus:NO];
    [self reloadRemainAmount];
}

- (void)editPointStatus:(BOOL)isShow
{
    [self.usePointView setHidden:isShow];
    [self.inputPointView setHidden:!isShow];
    
    if (isShow) {
        [self.inputPointView addSubview:self.inputPointTextField];
        [self.inputPointTextField setIsEditing:YES];
        
        if ([IPCPayOrderManager sharedManager].pointRecord.integral > 0) {
            [self.inputPointTextField setText:[NSString stringWithFormat:@"%d",[IPCPayOrderManager sharedManager].pointRecord.integral]];
        }else{
            [self.inputPointTextField setText:@""];
        }
        
        self.currentIndex = -1;
    }else{
        [self.inputPointTextField removeFromSuperview];
        self.inputPointTextField = nil;
        
        [self.pointAmountLabel setText:[NSString stringWithFormat:@"￥%.2f", [IPCPayOrderManager sharedManager].pointRecord.pointPrice]];
        [self.usePointLabel setText:[NSString stringWithFormat:@"%d", [IPCPayOrderManager sharedManager].pointRecord.integral]];
    }
    
    [self.payRecordTableView reloadData];
}

- (void)hidenEditPointStatus
{
    [self.usePointView setHidden:NO];
    [self.inputPointView setHidden:YES];
    [self.inputPointTextField removeFromSuperview];
    self.inputPointTextField = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.insertRecord = nil;
        self.selectCustomerCoverView = nil;
        self.keyboard = nil;
        [IPCHttpRequest cancelAllRequest];
    }
}



@end
