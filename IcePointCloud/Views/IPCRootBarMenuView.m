//
//  IPCRootBarMenuView.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCRootBarMenuView.h"
#import "IPCPersonBaseView.h"
#import "IPCUpdatePasswordView.h"
#import "IPCQRCodeView.h"
#import "IPCShoppingCartView.h"

#define IPCMenuShowWidth  400

@interface IPCRootBarMenuView()

@property (nonatomic, strong) IPCShoppingCartView * cartView;
@property (nonatomic, strong) IPCPersonBaseView * personBaseView;
@property (copy, nonatomic) void(^PayOrderBlock)();
@property (copy, nonatomic) void(^LogoutBlock)();
@property (nonatomic, copy) void(^DismissBlock)();

@end

@implementation IPCRootBarMenuView

- (instancetype)initWithFrame:(CGRect)frame
                    MenuIndex:(NSInteger)index
                     PayOrder:(void (^)())payOrder
                       Logout:(void (^)())logout
                      Dismiss:(void (^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.PayOrderBlock = payOrder;
        self.LogoutBlock = logout;
        self.DismissBlock = dismiss;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCRootBarMenuView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
        
        if (index == 4) {
            [self showShoppingCartView];
        }else if (index == 5){
            [self showPersonView];
        }
    }
    return self;
}


#pragma mark //Set UI
- (void)showUpdatePasswordView{
    IPCUpdatePasswordView * updateView = [[IPCUpdatePasswordView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:updateView];
    
    [updateView showWithClose:^{
        [updateView removeFromSuperview];
    }];
}

- (void)showQRCodeView{
    IPCQRCodeView * codeView = [[IPCQRCodeView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:codeView];
    [codeView showWithClose:^{
        [codeView removeFromSuperview];
    }];
}

- (void)showShoppingCartView
{
    _cartView = [[IPCShoppingCartView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:_cartView];
    [_cartView showWithPay:^{
        if (self.PayOrderBlock)
            self.PayOrderBlock();
    }];
}

- (void)showPersonView
{
    _personBaseView = [[IPCPersonBaseView alloc]initWithFrame:CGRectMake(self.jk_width, 0, IPCMenuShowWidth, self.jk_height)];
    [self addSubview:_personBaseView];
    [_personBaseView showWithLogout:^{
        if (self.LogoutBlock)self.LogoutBlock();
    } UpdateBlock:^{
        [self showUpdatePasswordView];
    } QRCodeBlock:^{
        [self showQRCodeView];
    }];
}

#pragma mark //Clicked Events
- (IBAction)tapBgAction:(id)sender {
    if ([self.cartView superview]) {
        [self.cartView dismiss:^{
            [self.cartView removeFromSuperview];
            if (self.DismissBlock) {
                self.DismissBlock();
            }
        }];
    }else if ([self.personBaseView superview]){
        [self.personBaseView dismiss:^{
            [self.personBaseView removeFromSuperview];
            if (self.DismissBlock) {
                self.DismissBlock();
            }
        }];
    }
}

@end
