//
//  IPCSwipeView.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSwipeView.h"

@interface IPCSwipeView()

@property (nonatomic, strong) UIView * buttonView;


@end

@implementation IPCSwipeView

- (void)setContentView:(UIView *)contentView{
    _contentView = contentView;
    
    if (_contentView) {
        [self addSubview:_contentView];
        [self bringSubviewToFront:_contentView];
        
        UISwipeGestureRecognizer * leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
        [_contentView addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer * rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
        [self.contentView addGestureRecognizer:rightSwipe];
        
        [self buildButtonView];
    }
}

- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    
    if (_isOpen) {
        [self openMenu];
    }else{
        [self closeMenu];
    }
}

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc]init];
    }
    return _buttonView;
}

- (void)buildButtonView{
    CGFloat width = 60;
    
    [self addSubview:self.buttonView];
    [self sendSubviewToBack:self.buttonView];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.mas_equalTo(128);
    }];
    
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonView addSubview:deleteButton];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buttonView.mas_left).with.offset(0);
        make.right.equalTo(self.buttonView.mas_right).with.offset(0);
        make.top.equalTo(self.buttonView.mas_top).with.offset(0);
        make.bottom.equalTo(self.buttonView.mas_bottom).with.offset(0);
    }];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_isOpen)return;
        self.isOpen = YES;
        if( self.swipeBlock ){
            self.swipeBlock();
        }
    }else if (gesture.direction == UISwipeGestureRecognizerDirectionRight){
        if (!_isOpen)return;
        self.isOpen = NO;
    }
}

- (void)openMenu
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.contentView.center = CGPointMake(strongSelf.contentView.center.x - strongSelf.buttonView.jk_width, strongSelf.contentView.center.y);
    }completion:^(BOOL finished) {
        
    }];
}


- (void)closeMenu
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.contentView.center = CGPointMake(strongSelf.centerX, strongSelf.contentView.centerY);
    }completion:^(BOOL finished) {
        
    }];
}



- (void)deleteAction{
    
}

@end
