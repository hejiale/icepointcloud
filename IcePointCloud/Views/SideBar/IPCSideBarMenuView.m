//
//  IPCRootBarMenuView.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSideBarMenuView.h"
#import "IPCPersonBaseView.h"
#import "IPCUpdatePasswordView.h"
#import "IPCQRCodeView.h"
#import "IPCWarehouseView.h"

#define IPCMenuShowWidth  400

@interface IPCSideBarMenuView()

@property (nonatomic, strong) IPCPersonBaseView * personBaseView;
@property (copy, nonatomic) void(^LogoutBlock)();
@property (nonatomic, copy) void(^DismissBlock)();

@end

@implementation IPCSideBarMenuView

- (instancetype)initWithFrame:(CGRect)frame
                       Logout:(void (^)())logout
                      Dismiss:(void (^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.LogoutBlock = logout;
        self.DismissBlock = dismiss;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSideBarMenuView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
        
        [self showPersonView];
    }
    return self;
}


#pragma mark //Set UI
- (void)showUpdatePasswordView
{
    __weak typeof(self) weakSelf = self;
    IPCUpdatePasswordView * updateView = [[IPCUpdatePasswordView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:updateView];
    
    [updateView showWithClose:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [updateView removeFromSuperview];
        [strongSelf.personBaseView reload];
    }];
}

- (void)showQRCodeView
{
    __weak typeof(self) weakSelf = self;
    IPCQRCodeView * codeView = [[IPCQRCodeView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:codeView];
    
    [codeView showWithClose:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [codeView removeFromSuperview];
        [strongSelf.personBaseView reload];
    }];
}

- (void)showWareHouseView
{
    __weak typeof(self) weakSelf = self;
    IPCWarehouseView * houseView = [[IPCWarehouseView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:houseView];
    
    [houseView showWithClose:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [houseView removeFromSuperview];
        [strongSelf.personBaseView reload];
    }];
}

- (void)showPersonView
{
    _personBaseView = [[IPCPersonBaseView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:_personBaseView];
    
    __weak typeof(self) weakSelf = self;
    [_personBaseView showWithLogout:^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.LogoutBlock)strongSelf.LogoutBlock();
    } UpdateBlock:^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showUpdatePasswordView];
        strongSelf.personBaseView.isHiden = YES;
    } QRCodeBlock:^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showQRCodeView];
        strongSelf.personBaseView.isHiden = YES;
    } WareHouseBlock:^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showWareHouseView];
        strongSelf.personBaseView.isHiden = YES;
    }];
}

#pragma mark //Clicked Events
- (IBAction)tapBgAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    if (!self.personBaseView.isHiden){
        [self.personBaseView dismiss:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.personBaseView removeFromSuperview];
            
            if (strongSelf.DismissBlock) {
                strongSelf.DismissBlock();
            }
        }];
    }else{
        if (self.DismissBlock) {
            self.DismissBlock();
        }
    }
}

@end
