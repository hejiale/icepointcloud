//
//  UICollectionView+Alert.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/31.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "UICollectionView+Alert.h"

static char const *  emptyAlertViewKey = "EmptyAlertViewKey";
static char const *  errorNetworkKey = "ErrorNetworkKey";
static char const *  loadingAlertImageKey = "LoadingAlertImageKey";

static char const *  emptyAlertTitleKey =  "EmptyAlertTitleKey";
static char const *  emptyAlertImageKey = "EmptyAlertImageKey";

static char const *  isHidenAlertKey  =  "IsHidenAlertKey";
static char const *  isBeginLoadKey  =  "IsBeginLoadKey";

@implementation UICollectionView (Alert)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jk_swizzleMethod:@selector(reloadData) withMethod:@selector(customReload)];
    });
}

- (void)customReload
{
    [self.errorNetworkAlertView removeFromSuperview];self.errorNetworkAlertView = nil;
    [self.emptyAlertView removeFromSuperview];self.emptyAlertView = nil;
    [self.loadingAlertView removeFromSuperview];self.loadingAlertView = nil;
    self.scrollEnabled = YES;
    
    AFNetworkReachabilityStatus status = [IPCReachability manager].currentNetStatus;
    if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
        if ([self checkIsEmpty]) {
            [self.mj_footer setHidden:YES];
            [self loadErrorNetworkAlertView];
        }else{
            [self.mj_footer setHidden:NO];
        }
    }else{
        if ([self checkIsEmpty]) {
            [self.mj_footer setHidden:YES];
            
            if (self.isBeginLoad) {
                self.scrollEnabled = NO;
                [self loadIsRefreshingView];
            }else{
                [self loadEmptyAlertView];
            }
        }else{
            [self.mj_footer setHidden:NO];
        }
    }
    [self customReload];
}


- (BOOL)checkIsEmpty{
    if (self.isHiden)return NO;
    
    BOOL isEmpty = YES;
    NSInteger sections = 1;
    
    id<UICollectionViewDataSource>dataSource = self.dataSource;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [dataSource numberOfSectionsInCollectionView:self] - 1;
    }
    
    for (NSInteger i = 0; i <= sections; i ++) {
        NSInteger rows = [dataSource collectionView:self numberOfItemsInSection:sections];
        if (rows > 0) {
            isEmpty = NO;
        }
    }
    return isEmpty;
}

- (void)loadEmptyAlertView{
    [self setContentOffset:CGPointZero];
    
    self.emptyAlertView = [[IPCEmptyAlertView alloc]initWithFrame:self.bounds
                                                       AlertImage:self.emptyAlertImage
                                                    LoadingImages:nil
                                                       AlertTitle:self.emptyAlertTitle];
    [self addSubview:self.emptyAlertView];
    [self bringSubviewToFront:self.emptyAlertView];
}

- (void)loadErrorNetworkAlertView{
    [self setContentOffset:CGPointZero];
    
    self.errorNetworkAlertView = [[IPCEmptyAlertView alloc]initWithFrame:self.bounds
                                                              AlertImage:@"exception_network"
                                                           LoadingImages:nil
                                                              AlertTitle:kIPCErrorNetworkAlertMessage];
    [self addSubview:self.errorNetworkAlertView];
    [self bringSubviewToFront:self.errorNetworkAlertView];
}

- (void)loadIsRefreshingView{
    [self setContentOffset:CGPointZero];
    
    __block NSMutableArray<UIImage *> * loadingArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 1 ; i< 17; i++) {
        [loadingArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%ld",(long)i]]];
    }
    
    self.loadingAlertView = [[IPCEmptyAlertView alloc]initWithFrame:self.bounds
                                                         AlertImage:nil
                                                      LoadingImages:loadingArray
                                                         AlertTitle:nil];
    [self addSubview:self.loadingAlertView];
    [self bringSubviewToFront:self.loadingAlertView];
}


- (IPCEmptyAlertView *)emptyAlertView{
    return objc_getAssociatedObject(self, emptyAlertViewKey);
}

- (void)setEmptyAlertView:(IPCEmptyAlertView *)emptyAlertView{
    objc_setAssociatedObject(self, emptyAlertViewKey, emptyAlertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (IPCEmptyAlertView *)errorNetworkAlertView{
    return objc_getAssociatedObject(self, errorNetworkKey);
}

- (void)setErrorNetworkAlertView:(IPCEmptyAlertView *)errorNetworkAlertView{
    objc_setAssociatedObject(self, errorNetworkKey, errorNetworkAlertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IPCEmptyAlertView *)loadingAlertView{
    return objc_getAssociatedObject(self, loadingAlertImageKey);
}

- (void)setLoadingAlertView:(IPCEmptyAlertView *)loadingAlertView{
    objc_setAssociatedObject(self, loadingAlertImageKey, loadingAlertView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyAlertTitle{
    return objc_getAssociatedObject(self, emptyAlertTitleKey);
}

- (void)setEmptyAlertTitle:(NSString *)emptyAlertTitle{
    objc_setAssociatedObject(self, emptyAlertTitleKey, emptyAlertTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setEmptyAlertImage:(NSString *)emptyAlertImage{
    objc_setAssociatedObject(self, emptyAlertImageKey, emptyAlertImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyAlertImage{
    return objc_getAssociatedObject(self, emptyAlertImageKey);
}

- (BOOL)isHiden{
    return [objc_getAssociatedObject(self, isHidenAlertKey) boolValue];
}

- (void)setIsHiden:(BOOL)isHiden{
    objc_setAssociatedObject(self, isHidenAlertKey, @(isHiden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isBeginLoad{
    return [objc_getAssociatedObject(self, isBeginLoadKey) boolValue];
}

- (void)setIsBeginLoad:(BOOL)isBeginLoad{
    objc_setAssociatedObject(self, isBeginLoadKey, @(isBeginLoad), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
