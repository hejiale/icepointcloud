//
//  FilterGlassesView.m
//  IcePointCloud
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCFilterGlassesView.h"
#import "IPCFilterClassViewCell.h"
#import "IPCFilterValueCollectionViewCell.h"
#import "IPCTagCollectionLayout.h"
#import "IPCFilterDataSourceResult.h"
#import "IPCPriceRangeTableViewCell.h"
#import "IPCChooseCategoryView.h"

static NSString * const filterClassIdentifier = @"FilterClassViewCellIdentifier";
static NSString * const filterValueIdentifier = @"FilterValueCollectionViewCellIdentifier";
static NSString * const priceRandIdentifier = @"PriceRangeTableViewCellIdentifier";
static NSString * const chooseIdentifier = @"ChooseTypeCellIdentifier";

@interface IPCFilterGlassesView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,IPCTagCollectionLayoutDelegate,PriceRangeTableViewCellDelegate>
{
    NSArray * sectionTitles;
    BOOL       isFilter;
    CGFloat   chooseCellHeight;
}
@property (weak, nonatomic) IBOutlet UITableView        *leftClassTableView;
@property (weak, nonatomic) IBOutlet UIView                 *rightView;
@property (weak, nonatomic) IBOutlet UICollectionView *rightValueCollectionView;
@property (weak, nonatomic) IBOutlet UIView                *leftBgView;
@property (strong, nonatomic) IPCChooseCategoryView      *categoryView;
@property (strong, nonatomic) UIView                           *topChooseView;
@property (strong, nonatomic) NSMutableArray<UIButton *>     *allButtonsArray;

@end

@implementation IPCFilterGlassesView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    chooseCellHeight = 100;
    
    sectionTitles = @[@"类目",@"属性",@"价格区间"];
    self.allButtonsArray = [[NSMutableArray alloc]init];
    isFilter = NO;
    
    IPCTagCollectionLayout *tagLayout = [[IPCTagCollectionLayout alloc] init];
    tagLayout.sectionInset = UIEdgeInsetsMake(18, 15, 0, 0);
    tagLayout.lineSpacing  = 10;
    tagLayout.itemSpacing  = 10;
    tagLayout.itemHeigh    = 27;
    tagLayout.delegate     = self;
    
    [self.leftClassTableView setTableFooterView:[[UIView alloc]init]];
    [self.rightValueCollectionView setCollectionViewLayout:tagLayout animated:YES];
    self.rightValueCollectionView.isHiden = YES;
    [self.rightValueCollectionView registerNib:[UINib nibWithNibName:@"IPCFilterValueCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:filterValueIdentifier];
}

#pragma mark //Request Data
- (void)reloadFilterView
{
    isFilter = NO;
    if ([self.categoryView superview])
        [self.categoryView removeFromSuperview];self.categoryView = nil;
    
    [self.rightView addSubview:self.categoryView];
    [self reloadChooseTypeView];
    [self.leftClassTableView reloadData];
    [self.rightValueCollectionView reloadData];
    if ([self.dataSource filterDataSourceResult]) {
        [self.leftClassTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}


#pragma mark //CLicked Events
- (void)show
{
    [self.rightView setFrame:CGRectMake(0, 0, self.rightView.jk_width, self.jk_height)];
    [self addSubview:self.rightView];
    [self sendSubviewToBack:self.rightView];
    
    [UIView animateWithDuration:0.8f animations:^{
        CGRect frame    = self.frame;
        frame.origin.x += self.jk_width;
        self.frame      = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.1f animations:^{
                CGRect   rect  = self.rightView.frame;
                rect.origin.x += self.leftBgView.jk_width;
                self.rightView.frame = rect;
            } completion:nil];
        }
    }];
}


- (void)closeCompletion:(void (^)())completed
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect    = self.frame;
        rect.origin.x -= self.jk_width;
        self.frame     = rect;
    } completion:^(BOOL finished) {
        completed();
    }];
}

- (void)checkCategoryAction:(UIButton *)sender{
    [self.allButtonsArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == sender.tag) {
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
        }
    }];
}

#pragma mark //Obtain the selected filter
- (NSArray *)getAllChooseValue
{
    if ([[[self.dataSource filterKeySource] allValues] count] == 0)return nil;
    
    __block NSMutableArray * allChooseList = [[NSMutableArray alloc]init];
    
    [[[self.dataSource filterKeySource] allValues] enumerateObjectsUsingBlock:^(NSArray *  _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if (obj.length) {
                 [allChooseList addObject:obj];
             }
         }];
     }];
    
    [allChooseList sortUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return obj1.length > obj2.length;
    }];
    
    if ([allChooseList count] > 0)return allChooseList;
    return nil;
}


#pragma mark //Set UI
- (UIView *)topChooseView{
    if (!_topChooseView)
        _topChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.leftBgView.jk_width, 0)];
    return _topChooseView;
}


- (IPCChooseCategoryView *)categoryView{
    __weak typeof (self) weakSelf = self;
    if (!_categoryView) {
        _categoryView = [[IPCChooseCategoryView alloc]initWithFrame:self.rightValueCollectionView.bounds CategoryList:[[self.dataSource filterDataSourceResult] allCategoryName] FilterType:[self.dataSource filterType] Complete:^(IPCTopFilterType type)
                         {
                             __strong typeof (weakSelf) strongSelf = weakSelf;
                             if ([strongSelf.delegate respondsToSelector:@selector(filterGlassesWithClassType:)])
                                 [strongSelf.delegate filterGlassesWithClassType:type];
                         }];
    }
    return _categoryView;
}

- (void)reloadChooseTypeView{
    [self.topChooseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([[[self.dataSource filterKeySource] allValues] count] == 0)return;
    
    __block CGFloat line = 1,orignX = 20,orignY = 14;
    
    [[self getAllChooseValue] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize retSize = [obj boundingRectWithSize:CGSizeMake(self.topChooseView.jk_width, 20)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]}
                                           context:nil].size;
        
        if ((orignX + retSize.width + 45 > self.topChooseView.jk_width) && idx > 0) {
            orignX  = 20;
            orignY += 44;
            line++;
        }
        
        [self.topChooseView addSubview:[self chooseBgView:CGRectMake(orignX, orignY, MIN(retSize.width+40, self.topChooseView.jk_width - 40), 30) Text:obj]];
        
        orignX += retSize.width + 45;
    }];
    
    CGRect rect      = self.topChooseView.frame;
    rect.size.height = line * 44 + 14;
    self.topChooseView.frame = rect;
}

- (UIView *)chooseBgView:(CGRect)rect Text:(NSString *)text
{
    UIView * bgView = [[UIView alloc]initWithFrame:rect];
    [bgView setBackgroundColor:COLOR_RGB_BLUE];
    [bgView.layer setCornerRadius:rect.size.height/2];
    
    __weak typeof (self) weakSelf = self;
    [bgView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(deleteFilterSourceWithValue:)])
            [strongSelf.delegate deleteFilterSourceWithValue:text];
    }];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, rect.size.width - 30, rect.size.height)];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
    [bgView addSubview:label];
    
    UIImageView * closeImg = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width - 25, 5, 20, 20)];
    [closeImg setImage:[UIImage imageNamed:@"icon_close"]];
    [bgView addSubview:closeImg];
    
    return bgView;
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.dataSource filterDataSourceResult])
        return sectionTitles.count;
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1){
        if ([[[self.dataSource filterKeySource] allValues] count] )
            return [[self.dataSource filterDataSourceResult] allFilterKeys].count + 1;
        return [[self.dataSource filterDataSourceResult] allFilterKeys].count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == sectionTitles.count -1) {
        IPCPriceRangeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:priceRandIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPriceRangeTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        if ([self.dataSource respondsToSelector:@selector(startPrice)]) {
            [cell.startPriceTextField setText:[self.dataSource startPrice]];
        }
        if ([self.dataSource respondsToSelector:@selector(endPrice)]) {
            [cell.endPriceTextField setText:[self.dataSource endPrice]];
        }
        return cell;
    }else if ([[[self.dataSource filterKeySource] allValues] count] > 0 && (indexPath.section == 1 && indexPath.row == 0)){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:chooseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:self.topChooseView];
        
        return cell;
    }else{
        IPCFilterClassViewCell * cell = [tableView dequeueReusableCellWithIdentifier:filterClassIdentifier];
        
        if (!cell)
            cell = [[UINib nibWithNibName:@"IPCFilterClassViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        
        if (indexPath.section == 1) {
            if ([self.dataSource respondsToSelector:@selector(filterKeySource)]) {
                if ([[[self.dataSource filterKeySource] allValues] count]) {
                    [cell.filterClassLabel setText:[[self.dataSource filterDataSourceResult] allFilterKeys][indexPath.row -1]];
                }else{
                    [cell.filterClassLabel setText:[[self.dataSource filterDataSourceResult] allFilterKeys][indexPath.row]];
                }
            }
        }else{
            [cell.filterClassLabel setText:@"类型"];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 50)];
    
    UILabel * headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headView.jk_width, headView.jk_height-1)];
    [headLabel setTextColor:[UIColor lightGrayColor]];
    [headLabel setBackgroundColor:[UIColor clearColor]];
    [headLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
    [headLabel setTextAlignment:NSTextAlignmentCenter];
    [headLabel setText:sectionTitles[section]];
    [headView addSubview:headLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(30, headLabel.jk_bottom, headView.jk_width-60, 0.7)];
    [line setBackgroundColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.1]];
    [headView addSubview:line];
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 38)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == sectionTitles.count - 1)
        return 180;
    if ((indexPath.section == 1 && indexPath.row == 0) && [[[self.dataSource filterKeySource] allValues] count] > 0) {
        return self.topChooseView.jk_height;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != sectionTitles.count - 1) {
        if ([[[self.dataSource filterKeySource] allValues] count] > 0 && (indexPath.section == 1 && indexPath.row == 0))return;
        
        if (indexPath.section == 0) {
            [self.categoryView setHidden:NO];
        }else{
            [self.categoryView setHidden:YES];
        }
        [self.rightValueCollectionView reloadData];
    }
}

#pragma mark //PriceRangeTableViewCellDelegate
- (void)reloadPriceRangProducts:(double)startPirce EndPrice:(double)endPrice{
    if ([self.delegate respondsToSelector:@selector(filterProductsPrice:EndPrice:)]) {
        [self.delegate filterProductsPrice:startPirce EndPrice:endPrice];
    }
}


#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.leftClassTableView.indexPathForSelectedRow.section != 0){
        if ([self.dataSource respondsToSelector:@selector(filterDataSourceResult)]) {
            NSArray * filterValue = [[self.dataSource filterDataSourceResult] allFilterValues][[self filterKey]];
            return [filterValue count];
        }
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCFilterValueCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:filterValueIdentifier forIndexPath:indexPath];
    [cell.filterValueLabel setTextColor:[UIColor lightGrayColor]];
    [cell.contentView setBackgroundColor:[UIColor jk_colorWithHexString:@"#e6e6e6"]];

    if ([self.dataSource respondsToSelector:@selector(filterKeySource)]) {
        [[[self.dataSource filterKeySource] allValues] enumerateObjectsUsingBlock:^(NSArray *  _Nonnull array, NSUInteger idx, BOOL * _Nonnull stop) {
            [array enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[self filterValue:indexPath] isEqualToString:obj]){
                    [cell.contentView setBackgroundColor:COLOR_RGB_BLUE];
                    [cell.filterValueLabel setTextColor:[UIColor whiteColor]];
                }
            }];
        }];
    }
    [cell.filterValueLabel setText:[self filterValue:indexPath]];
    return cell;
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * filterValue = [self filterValue:indexPath];
    if (! [[self getAllChooseValue] containsObject:filterValue]) {
        if (!isFilter) {
            isFilter = YES;
            if ([self.delegate respondsToSelector:@selector(filterGlassesWithFilterKey:FilterName:)])
                [self.delegate filterGlassesWithFilterKey:[self filterKey] FilterName:filterValue];
        }
    }
}

#pragma mark //FJTagCollectionLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(IPCTagCollectionLayout*)collectionViewLayout widthAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    size.height = 27;
    
    CGSize temSize = CGSizeZero;
    temSize = [self sizeWithString:[self filterValue:indexPath] fontSize:14];
    
    size.width = temSize.width + 20;
    return size.width;
}

- (CGSize)sizeWithString:(NSString *)str fontSize:(float)fontSize
{
    CGSize constraint = CGSizeMake(self.rightValueCollectionView.jk_width - 36, fontSize);
    
    CGSize tempSize;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize weight:UIFontWeightThin]};
    CGSize retSize = [str boundingRectWithSize:constraint
                                       options:
                      NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attribute
                                       context:nil].size;
    tempSize = retSize;
    
    return tempSize ;
}


#pragma mark //For screening of key-value pairs
- (NSString *)filterKey{
    if ([[[self.dataSource filterKeySource] allValues] count] > 0)
        return [[self.dataSource filterDataSourceResult] allFilterKeys][self.leftClassTableView.indexPathForSelectedRow.row -1];
    return [[self.dataSource filterDataSourceResult] allFilterKeys][self.leftClassTableView.indexPathForSelectedRow.row];
}

- (NSString *)filterValue:(NSIndexPath *)indexPath{
    if ([[[self.dataSource filterDataSourceResult] allFilterValues] count] && [self.dataSource respondsToSelector:@selector(filterDataSourceResult)]) {
        NSArray * filterValue = [[self.dataSource filterDataSourceResult] allFilterValues][[self filterKey]];
        return filterValue[indexPath.row];
    }
    return nil;
}

#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = 50;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end
