//
//  UICollectionView+Alert.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/31.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "UICollectionView+Alert.h"

static char const *  emptyAlertViewKey = "EmptyAlertViewKey";
static char const *  emptyAlertTitleKey =  "EmptyAlertTitleKey";
static char const *  emptyAlertImageKey = "EmptyAlertImageKey";
static char const *  errorNetworkKey = "ErrorNetworkKey";
static char const *  isHidenAlertKey  =  "IsHidenAlertKey";

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
    
    AFNetworkReachabilityStatus status = [IPCReachability manager].currentNetStatus;
    if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
        if ([self checkIsEmpty]) {
            [self loadErrorNetworkAlertView];
        }
    }else{
        if ([self checkIsEmpty]) {
            [self loadEmptyAlertView];
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
    self.emptyAlertView = [[IPCEmptyAlertView alloc]initWithFrame:self.bounds
                                                       AlertImage:self.emptyAlertImage
                                                       AlertTitle:self.emptyAlertTitle];
    [self addSubview:self.emptyAlertView];
    [self bringSubviewToFront:self.emptyAlertView];
}

- (void)loadErrorNetworkAlertView{
    self.errorNetworkAlertView = [[IPCEmptyAlertView alloc]initWithFrame:self.bounds
                                                              AlertImage:@"exception_network"
                                                              AlertTitle:kIPCErrorNetworkAlertMessage];
    [self addSubview:self.errorNetworkAlertView];
    [self bringSubviewToFront:self.errorNetworkAlertView];
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

- (NSString *)emptyAlertTitle{
    return objc_getAssociatedObject(self, emptyAlertTitleKey);
}

- (void)setEmptyAlertTitle:(NSString *)emptyAlertTitle{
    objc_setAssociatedObject(self, emptyAlertTitleKey, emptyAlertTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setEmptyAlertImage:(UIImage *)emptyAlertImage{
    objc_setAssociatedObject(self, emptyAlertImageKey, emptyAlertImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)emptyAlertImage{
    return objc_getAssociatedObject(self, emptyAlertImageKey);
}

- (BOOL)isHiden{
    return [objc_getAssociatedObject(self, isHidenAlertKey) boolValue];
}

- (void)setIsHiden:(BOOL)isHiden{
    objc_setAssociatedObject(self, isHidenAlertKey, @(isHiden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
