//
//  IPCPhotoPickerBaseComponent.m
//  IcePointCloud
//
//  Created by gerry on 2017/10/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPhotoPickerBaseComponent.h"
#import "IPCPhotoDatas.h"
#import "IPCPhotoPickerCell.h"
#import "IPCPhoto.h"
#import "IPCEditFilterSampleController.h"
#import "IPCLibraryTypeTableView.h"


@interface IPCPhotoPickerBaseComponent()

@property (nonatomic, copy) void(^ResultImageBlock)(UIImage *);

@end

@implementation IPCPhotoPickerBaseComponent

- (instancetype)initWithResultImage:(void(^)(UIImage * image))imageBlock
{
    self = [super init];
    if (self) {
        self.ResultImageBlock = imageBlock;
    }
    return self;
}

- (void)showSampleWithController:(UIViewController *)controller
{
    if (!controller) return;
    
    IPCPhotoPickerViewController * photoVC = [[IPCPhotoPickerViewController alloc] initWithCompleteImage:^(UIImage *image) {
        if (self.ResultImageBlock) {
            self.ResultImageBlock(image);
        }
    }];
    IPCPortraitNavigationViewController * photoNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:photoVC];
    [controller presentViewController:photoNav  animated:YES completion:nil];
}

@end

@interface IPCPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IPCLibraryTypeTableViewDelegate>

@property (strong, nonatomic) IPCLibraryTypeTableView * libraryTypeTableView;
@property (strong, nonatomic) NSMutableArray<IPCPhoto *> *photoArray;
@property (strong, nonatomic) UICollectionView *picsCollection;
@property (strong, nonatomic) UIBarButtonItem *backBtn;
@property (strong, nonatomic) IPCPhotoDatas *datas;
@property (strong, nonatomic) IPCDynamicImageTextButton * button;
@property (copy,    nonatomic) void(^CompleteImageBlock)(UIImage *image);

@end

@implementation IPCPhotoPickerViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (instancetype)initWithCompleteImage:(void(^)(UIImage *image))imageBlock{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.CompleteImageBlock = imageBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackground];
    self.navigationItem.leftBarButtonItem = self.backBtn;
    [self setNavigationBarTitle:@"所有照片"];
    
    [self setupCollectionViewUI];
    [self loadPhotoData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark //Declaration Array
-(NSMutableArray<IPCPhoto *> *)photoArray
{
    if (!_photoArray)
        _photoArray = [NSMutableArray array];
    return _photoArray;
}

#pragma mark //Load Data
-(IPCPhotoDatas *)datas{
    if (!_datas)
        _datas = [[IPCPhotoDatas alloc]init];
    return _datas;
}

-(void)loadPhotoData
{
    if ([self.photoArray count] > 0)[self.photoArray removeAllObjects];
    
    if ([self.datas GetCameraRollFetchResul]) {
        self.photoArray = [self.datas GetPhotoAssets:[self.datas GetCameraRollFetchResul]];
    }
    
    if ([self.photoArray count] == 0) {
        [IPCCommonUI showError:@"相册中未查询到任何照片!"];
    }
    [self.picsCollection reloadData];
}

#pragma mark //Set UI
-(void)setupCollectionViewUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.minimumLineSpacing = 1.0;
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _picsCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_picsCollection registerClass:[IPCPhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
    _picsCollection.delegate = self;
    _picsCollection.dataSource = self;
    _picsCollection.backgroundColor = [UIColor whiteColor];
    [_picsCollection setUserInteractionEnabled:YES];
    [self.view addSubview:_picsCollection];
    [_picsCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

- (UIBarButtonItem *)backBtn{
    if (!_backBtn) {
        UIButton *back_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 44)];
        [back_btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        back_btn.frame = CGRectMake(0, 0, 60, 44);
        back_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [back_btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = [[UIBarButtonItem alloc] initWithCustomView:back_btn];
    }
    return _backBtn;
}

- (void)setNavigationBarTitle:(NSString *)title
{
    self.navigationItem.titleView = self.button;
    [self.button setTitle:title];
}

- (void)showLibraryTypeListView{
    if ([self.libraryTypeTableView superview]){
        [self.libraryTypeTableView dismiss];
        self.libraryTypeTableView = nil;
    }else{
        self.libraryTypeTableView = [[IPCLibraryTypeTableView alloc]initWithFrame:CGRectMake(0, self.view.jk_height, self.view.jk_width, self.view.jk_height)];
        [self.libraryTypeTableView setLibraryDelegate:self];
        [self.view addSubview:self.libraryTypeTableView];
        [self.view bringSubviewToFront:self.libraryTypeTableView];
        [self.libraryTypeTableView show];
    }
}

- (IPCDynamicImageTextButton *)button{
    if (!_button) {
        _button = [[IPCDynamicImageTextButton alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_button setImage:[UIImage imageNamed:@"icon_bar__down_arrow"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"icon_bar__up_arrow"] forState:UIControlStateSelected];
        [_button setTitleColor:[UIColor darkGrayColor]];
        [_button setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightThin]];
        [_button setButtonAlignment:IPCCustomButtonAlignmentLeft];
        [_button addTarget:self action:@selector(selectLibraryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark //Clicked Events
-(void)back{
    if ([self.libraryTypeTableView superview]) {
        [self.libraryTypeTableView dismiss];
        self.libraryTypeTableView = nil;
        [self.button setSelected:NO];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)selectLibraryAction{
    [self.button setSelected:!self.button.selected];
    [self showLibraryTypeListView];
}


#pragma mark //UICollectionView --- Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.photoArray.count > 0 ? 1 : 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPhotoPickerCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    IPCPhoto * photo = [self.photoArray objectAtIndex:indexPath.row];
    if (photo) {
        [photoCell loadPhotoData:photo];
    }
    return photoCell;
}

#pragma mark //UICollectionView --- Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.photoArray count]) {
        IPCPhotoPickerCell * cell = (IPCPhotoPickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        IPCEditFilterSampleController * sampleVC = [[IPCEditFilterSampleController alloc]initWithResultImage:^(UIImage *image)
                                                    {
                                                        if (self.CompleteImageBlock) {
                                                            self.CompleteImageBlock(image);
                                                        }
                                                        
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        if (cell.photo) {
            [sampleVC showImage:cell.photo.image];
        }
        [self.navigationController pushViewController:sampleVC animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 60);
}

#pragma mark //IPCLibraryTypeTableViewDelegate
- (void)getAlbumPhotos:(IPCPhotoListModel *)photoMode{
    [self.libraryTypeTableView dismiss];
    self.libraryTypeTableView = nil;
    [self.button setSelected:NO];
    [self.photoArray removeAllObjects];
    [self.photoArray addObjectsFromArray:photoMode.assetArray];
    [self.picsCollection reloadData];
    [self setNavigationBarTitle:photoMode.title];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

