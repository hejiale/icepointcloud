//
//  HelpViewController.m
//  IcePointCloud
//
//  Created by mac on 10/14/14.
//  Copyright (c) 2016年 Doray. All rights reserved.
//

#import "IPCHelpViewController.h"

@interface IPCHelpViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic) CGFloat pageWidth;

@end

@implementation IPCHelpViewController

static NSInteger const kPageCount = 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.pageControl.numberOfPages = kPageCount;
    self.pageControl.transform = CGAffineTransformMakeScale(1.25, 1.25);
    
    for (int i = 0; i < kPageCount; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"help_page%d", i + 1]];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        [imgView setFrame:CGRectMake(img.size.width*i, 0, img.size.width, img.size.height)];
        [self.mainScrollView addSubview:imgView];
        
        self.pageWidth = imgView.frame.size.width;
    }
    
    [self.mainScrollView setContentSize:CGSizeMake(kPageCount * self.pageWidth,0)];
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTapped
{
    NSInteger page = self.pageControl.currentPage + 1;
    if (page > kPageCount - 1) page = 0;
    [self.mainScrollView setContentOffset:CGPointMake(page * self.pageWidth, 0)
                                 animated:YES];
}

#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePageControl];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePageControl];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePageControl];
}

- (void)updatePageControl
{
    CGFloat x = self.mainScrollView.contentOffset.x;
    self.pageControl.currentPage = (NSInteger)round(x / self.pageWidth);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
