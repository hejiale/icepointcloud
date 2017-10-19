//
//  HcdGuideViewManager.m
//  IcePointCloud
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGuideViewManager.h"
#import "IPCGuideViewCell.h"

static NSString *kCellIdentifier_HcdGuideViewCell = @"IPCGuideViewCell";

@interface IPCGuideViewManager()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) void(^FinishedBlock)();

@end

@implementation IPCGuideViewManager

+ (instancetype)sharedInstance {
    static IPCGuideViewManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [IPCGuideViewManager new];
    });
    return instance;
}

#pragma mark //Set UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = self.contentView.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[IPCGuideViewCell class] forCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectZero;
        _pageControl.currentPageIndicatorTintColor =  COLOR_RGB_BLUE;
        _pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    }
    return _pageControl;
}

- (void)showGuideViewWithImages:(NSArray *)images
                         InView:(UIView *)contentView
                         Finish:(void (^)())finish
{
    self.contentView = contentView;
    self.images = images;
    self.pageControl.numberOfPages = images.count;
    self.FinishedBlock = finish;
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.pageControl];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IPCGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell forIndexPath:indexPath];
    
    UIImage *img = [self.images objectAtIndex:indexPath.row];
    CGSize size = [self adapterSizeImageSize:img.size compareSize:self.contentView.bounds.size];
    
    //Adaptive image location, images can be any size, automatically zoom.
    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.imageView.image = img;
    cell.imageView.center = CGPointMake(self.contentView.jk_width / 2, self.contentView.jk_height / 2);
    
    if (indexPath.row == self.images.count - 1) {
        [cell.button setHidden:NO];
        [cell.button addTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.button removeTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setHidden:YES];
    }
    
    return cell;
}

- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (scrollView.contentOffset.x / self.contentView.jk_width);
}

#pragma mark //Clicked Events
- (void)nextButtonHandler:(id)sender{
    [NSUserDefaults jk_setObject:[NSNumber numberWithBool:YES] forKey:IPCFirstLanuchKey];
    
    if (self.FinishedBlock)
        self.FinishedBlock();
}

@end
