//
//  IPCPayOrderTopOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderTopOptometryView.h"
#import "IPCPayOrderOptometryView.h"

@interface IPCPayOrderTopOptometryView()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IPCOptometryList * optometryList;
@property (strong, nonatomic) NSMutableArray<IPCPayOrderOptometryView *> * optometryViews;

@end

@implementation IPCPayOrderTopOptometryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderTopOptometryView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self queryOptometryListRequest];
}


#pragma mark //Request Data
- (void)queryOptometryListRequest
{
    __weak typeof(self) weakSelf = self;
    
    [IPCCustomerRequestManager queryUserOptometryListWithCustomID:[IPCPayOrderManager sharedManager].currentCustomerId
                                                     SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         
         strongSelf.optometryList = [[IPCOptometryList alloc]initWithResponseValue:responseValue];
         [weakSelf loadOptometryScrollView];
     } FailureBlock:^(NSError *error) {
         
     }];
}

- (NSMutableArray<IPCPayOrderOptometryView *> *)optometryViews
{
    if (!_optometryViews) {
        _optometryViews = [[NSMutableArray alloc]init];
    }
    return _optometryViews;
}

#pragma mark //SetUI
- (void)loadOptometryScrollView
{
    [self.contentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.optometryViews removeAllObjects];
    
    __block CGFloat width = (self.contentScrollView.jk_width - 20)/3;
    __block CGFloat orignX = 0;
    
    __weak typeof(self) weakSelf = self;
    
    [self.optometryList.listArray enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        IPCPayOrderOptometryView * optometryView = [[IPCPayOrderOptometryView alloc]initWithFrame:CGRectMake(orignX, 0, width, strongSelf.contentScrollView.jk_height)];
        optometryView.optometry = obj;
        [strongSelf.contentScrollView addSubview:optometryView];
        [strongSelf.optometryViews addObject:optometryView];
        
        orignX += width+10;
    }];
    
    [self.contentScrollView setContentSize:CGSizeMake(orignX, 0)];
}


- (IBAction)insertOptometryAction:(id)sender {
}


@end
