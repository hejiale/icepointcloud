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
        self.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:0.9];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        self.label.font = [UIFont systemFontOfSize:15];
        [self.label setTextColor:[UIColor darkGrayColor]];
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
@property (strong, nonatomic) IPCCollectionViewIndex * collectionViewIndex;
@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;
@property (strong, nonatomic) NSMutableArray<IPCCustomerMode *> * customerArray;

@end

@implementation IPCSearchCustomerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadCollectionView];
    [self beginReloadData];
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

- (NSMutableArray<IPCCustomerMode *> *)customerArray{
    if (!_customerArray) {
        _customerArray = [[NSMutableArray alloc]init];
    }
    return _customerArray;
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.view.jk_width - 2)/3;
    CGFloat itemHeight = (self.view.jk_height - 2)/5;
    
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
        _collectionViewIndex = [[IPCCollectionViewIndex alloc]initWithFrame:CGRectMake(self.view.jk_width - 20, 0, 20, self.view.jk_height)];
        _collectionViewIndex.isFrameLayer = NO;
    }
    return _collectionViewIndex;
}

#pragma mark //Refresh Method
- (void)beginReloadData{
    [self.customerArray removeAllObjects];
    [self refreshData];
}


- (void)refreshData{
    [self queryCustomerInfo:^{
        [self reload];
    }];
}

- (void)reload{
    [self.customerCollectionView reloadData];
    
    UIEdgeInsets edgeInsets = self.customerCollectionView.contentInset;
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:_sectionArr];
    [array  removeObjectAtIndex:0];
    
    self.collectionViewIndex.titleIndexes = array;
    
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
         
         _rowArr = [IPCSortCustomer getCustomerListDataBy:customerList.list];
         _sectionArr = [IPCSortCustomer getCustomerListSectionBy:[_rowArr mutableCopy]];
         
         if (complete) {
             complete();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:@"查询客户信息失败!"];
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
    CGSize size = {collectionView.jk_width,40};
    return size;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionHeadView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CollectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
        [headerView setLabelText:_sectionArr[indexPath.section+1]];
        reusableview = headerView;
    }
    return reusableview;
}


#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.customerArray.count) {
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
-(void)collectionViewIndex:(IPCCollectionViewIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title{
    
    if ([self.customerCollectionView numberOfSections] > index && index > -1)
    {
        [self.customerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword{
    searchKeyWord = keyword;
    [self beginReloadData];
}


@end
