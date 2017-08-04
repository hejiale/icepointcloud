//
//  UITableView+Alert.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/31.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "UITableView+Alert.h"

static char const *  emptyAlertViewKey = "EmptyAlertViewKey";
static char const *  emptyAlertTitleKey =  "EmptyAlertTitleKey";
static char const *  emptyAlertImageKey = "EmptyAlertImageKey";
static char const *  operationKey      = "OperationKey";
static char const *  errorNetworkKey = "ErrorNetworkKey";
static char const *  isHidenAlertKey  =  "IsHidenAlertKey";

@implementation UITableView (Alert)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jk_swizzleMethod:@selector(reloadData) withMethod:@selector(customReload)];
    });
}

- (void)customReload{
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
    
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [self.dataSource numberOfSectionsInTableView:self] - 1;
    }
    
    for (NSInteger i = 0; i <= sections; i ++) {
        NSInteger rows = [self.dataSource tableView:self numberOfRowsInSection:sections];
        if (rows > 0) {
            isEmpty = NO;
        }
    }
    return isEmpty;
}

- (void)loadEmptyAlertView{
    self.emptyAlertView = [[IPCEmptyAlertView alloc]initWithFrame:self.bounds
                                                       AlertImage:self.emptyAlertImage
                                                       AlertTitle:self.emptyAlertTitle
                                                   OperationTitle:self.operationTitle
                                                         Complete:^{
                                                             [self operationAction];
                                                         }];
    [self addSubview:self.emptyAlertView];
    [self bringSubviewToFront:self.emptyAlertView];
}

- (void)loadErrorNetworkAlertView{
    self.errorNetworkAlertView = [[IPCEmptyAlertView alloc]initWithFrame:self.bounds
                                                              AlertImage:@"exception_network"
                                                              AlertTitle:kIPCErrorNetworkAlertMessage
                                                          OperationTitle:self.operationTitle
                                                                Complete:nil];
    [self addSubview:self.errorNetworkAlertView];
    [self bringSubviewToFront:self.errorNetworkAlertView];
}

- (void)operationAction{
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

- (void)setEmptyAlertImage:(NSString *)emptyAlertImage{
    objc_setAssociatedObject(self, emptyAlertImageKey, emptyAlertImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)emptyAlertImage{
    return objc_getAssociatedObject(self, emptyAlertImageKey);
}

- (void)setOperationTitle:(NSString *)operationTitle{
    objc_setAssociatedObject(self, operationKey, operationTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)operationTitle{
    return objc_getAssociatedObject(self, operationKey);
}

- (BOOL)isHiden{
    return [objc_getAssociatedObject(self, isHidenAlertKey) boolValue];
}

- (void)setIsHiden:(BOOL)isHiden{
    objc_setAssociatedObject(self, isHidenAlertKey, @(isHiden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
