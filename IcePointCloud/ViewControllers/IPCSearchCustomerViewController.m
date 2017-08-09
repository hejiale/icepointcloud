//
//  IPCSearchCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSearchCustomerViewController.h"
#import "IPCCustomerCollectionViewCell.h"
#import "IPCInsertCustomerViewController.h"
#import "IPCCustomerDetailViewController.h"
#import "IPCSearchViewController.h"
#import "IPCSortCustomer.h"
#import "IPCCollectionViewIndex.h"

static NSString * const customerIdentifier = @"CustomerCollectionViewCellIdentifier";

@interface CollectionHeadView : UICollectionReusableView

@property (strong, nonatomic) UILabel *label;

-(void)setLabelText:(NSString *)text;
@end

@implementation CollectionHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
        self.label.font = [UIFont systemFontOfSize:14];
        [self.label setTextColor:COLOR_RGB_BLUE];
        [self addSubview:self.label];
    }
    return self;
}

- (void) setLabelText:(NSString *)text
{
    self.label.text = text;
}

@end

@interface IPCSearchCustomerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,IPCSearchViewControllerDelegate,IPCCollectionViewIndexDelegate>
{
    NSString * searchKeyWord;
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *insertButton;
@property (strong, nonatomic) UILabel  * flotageLabel;          //中间显示的背景框
@property (strong, nonatomic) IPCCollectionViewIndex * collectionViewIndex;
@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;

@end

@implementation IPCSearchCustomerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadCollectionView];
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([IPCPayOrderManager sharedManager].isPayOrderStatus || [IPCInsertCustomer instance].isInsertStatus) {
        [self setNavigationTitle:@"客户"];
        [self setNavigationBarStatus:NO];
    }else{
        [self setNavigationBarStatus:YES];
    }
    [self.insertButton setHidden:[IPCInsertCustomer instance].isInsertStatus];
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.view.jk_width-2)/3;
    CGFloat itemHeight = (self.view.jk_height-2)/5;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    [_customerCollectionView setCollectionViewLayout:layout];
    _customerCollectionView.emptyAlertImage = @"exception_search";
    _customerCollectionView.emptyAlertTitle = @"未查询到客户信息!";
    
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
    [_customerCollectionView registerClass:[CollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.view addSubview:self.collectionViewIndex];
    [self.view bringSubviewToFront:self.collectionViewIndex];
}

- (IPCCollectionViewIndex *)collectionViewIndex
{
    if (!_collectionViewIndex) {
        _collectionViewIndex = [[IPCCollectionViewIndex alloc]initWithFrame:CGRectMake(self.view.jk_width - 30, 0, 30, self.view.jk_height)];
        _collectionViewIndex.isFrameLayer = NO;
    }
    return _collectionViewIndex;
}

- (UILabel *)flotageLabel
{
    if (!_flotageLabel) {
        _flotageLabel = [[UILabel alloc] init];
        _flotageLabel.backgroundColor = [UIColor lightGrayColor];
        [_flotageLabel.layer  setCornerRadius:32];
        _flotageLabel.layer.masksToBounds = YES;
        _flotageLabel.textAlignment = NSTextAlignmentCenter;
        _flotageLabel.textColor = [UIColor whiteColor];
    }
    return _flotageLabel;
}

- (void)loadFlotageLabel:(NSInteger)index Title:(NSString *)title
{
    [self.flotageLabel setText:title];
    [self.view addSubview:self.flotageLabel];
    [self.view bringSubviewToFront:self.flotageLabel];
    
    CGFloat offset = (index-1) * 16 + self.collectionViewIndex.origin.y - 8;
    [self.flotageLabel setFrame:CGRectMake(self.view.jk_width - 100, offset, 64, 64)];
}

#pragma mark //Refresh Method
- (void)refreshData
{
    [IPCCommonUI show];
    [self queryCustomerInfo:^{
        [self reload];
        [IPCCommonUI hiden];
    }];
}

- (void)reload{
    [self.customerCollectionView reloadData];
    
    UIEdgeInsets edgeInsets = self.customerCollectionView.contentInset;
    
    self.collectionViewIndex.titleIndexes = _sectionArr;
    
    CGRect rect = _collectionViewIndex.frame;
    rect.size.height = _collectionViewIndex.titleIndexes.count * 16;
    rect.origin.y = (self.view.jk_height - rect.size.height - edgeInsets.top - edgeInsets.bottom) / 2 + edgeInsets.top + 20;
    _collectionViewIndex.frame = rect;
    
    _collectionViewIndex.collectionDelegate = self;
}


#pragma mark //Request Data
- (void)queryCustomerInfo:(void(^)())complete
{
    [IPCCustomerRequestManager queryCustomerListWithKeyword:searchKeyWord ? : @""
                                                       Page:1
                                               SuccessBlock:^(id responseValue)
     {
         IPCCustomerList * customerList = [[IPCCustomerList alloc]initWithResponseValue:responseValue];
         
         _rowArr = [IPCSortCustomer PinYingData:customerList.list];
         _sectionArr = [IPCSortCustomer PinYingSection:[_rowArr mutableCopy]];
         
         if (complete) {
             complete();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:@"查询客户信息失败!"];
         if (complete) {
             complete();
         }
     }];
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender {
    IPCInsertCustomerViewController * insertCustomerVC = [[IPCInsertCustomerViewController alloc]initWithNibName:@"IPCInsertCustomerViewController" bundle:nil];
    [self.navigationController pushViewController:insertCustomerVC animated:YES];
}

- (IBAction)searchCustomerAction:(id)sender{
    IPCSearchViewController * searchVC = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
    searchVC.searchDelegate = self;
    [searchVC showSearchCustomerViewWithSearchWord:searchKeyWord];
    [self presentViewController:searchVC animated:YES completion:nil];
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _rowArr.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_rowArr[section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
    IPCCustomerMode * customer = _rowArr[indexPath.section][indexPath.row];
    cell.currentCustomer = customer;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {collectionView.jk_width,30};
    return size;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionHeadView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        [headerView setLabelText:_sectionArr[indexPath.section]];
        reusableview = headerView;
    }
    return reusableview;
}


#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_rowArr.count) {
        IPCCustomerMode * customer = _rowArr[indexPath.section][indexPath.row];
        
        if (customer) {
            if ([IPCInsertCustomer instance].isInsertStatus) {
                [IPCInsertCustomer instance].introducerId = customer.customerID;
                [IPCInsertCustomer instance].introducerName = customer.customerName;
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([IPCPayOrderManager sharedManager].isPayOrderStatus){
                [[IPCPayOrderManager sharedManager] resetPayPrice];
                [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:IPCChooseCustomerNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                IPCCustomerDetailViewController * detailVC = [[IPCCustomerDetailViewController alloc]initWithNibName:@"IPCCustomerDetailViewController" bundle:nil];
                [detailVC setCustomer:customer];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
}

#pragma mark //IPCCollectionViewIndexDelegate
-(void)collectionViewIndex:(IPCCollectionViewIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title Point:(CGPoint)point
{
    [self.customerCollectionView scrollRectToVisible:[self collectionViewVisable:index] animated:NO];
    [self loadFlotageLabel:index Title:title];
}

-(void)collectionViewIndexTouchesEnd:(IPCCollectionViewIndex *)collectionViewIndex
{
    [UIView animateWithDuration:0.6f animations:^{
        _flotageLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_flotageLabel removeFromSuperview];
            _flotageLabel = nil;
        }
    }];
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword{
    searchKeyWord = keyword;
    [self refreshData];
}

#pragma mark //Visable Rect
- (CGRect)collectionViewVisable:(NSInteger)index
{
    NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:index];
    
    UICollectionViewLayoutAttributes* attr = [self.customerCollectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
    UIEdgeInsets insets = self.customerCollectionView.scrollIndicatorInsets;
    
    CGRect rect = attr.frame;
    rect.size = self.customerCollectionView.frame.size;
    rect.size.height -= insets.top + insets.bottom;
    CGFloat offset = (rect.origin.y + rect.size.height) - self.customerCollectionView.contentSize.height;
    if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
    
    return rect;
}

@end
