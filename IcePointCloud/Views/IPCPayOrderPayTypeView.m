//
//  IPCPayOrderPayTypeView.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderPayTypeView.h"
#import "IPCPayOrderTypeTopView.h"
#import "IPCPayOrderTypeBottomView.h"
#import "IPCOtherPayTypeView.h"

typedef void(^DismissBlock)();


@interface IPCPayOrderPayTypeView()
{
    NSInteger count;
}
@property (nonatomic, strong) IPCPayOrderTypeTopView * payTypeTopView;
@property (nonatomic, strong) IPCPayOrderTypeBottomView * payTypeBottomView;
@property (strong, nonatomic)  UIView * otherPayStyleContentView;

@property (strong, nonatomic)  UIView *otherPayTypeView;
@property (strong, nonatomic) UIImageView * backgroundView;
@property (strong, nonatomic) UIView * mainView;

@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, strong) NSMutableArray<IPCOtherPayTypeView *> * otherTypeArray;

@end

@implementation IPCPayOrderPayTypeView

- (instancetype)initWithFrame:(CGRect)frame Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dismissBlock = dismiss;
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
        
        [self addSubview:self.mainView];
        [self bringSubviewToFront:self.mainView];
        
        self.payTypeTopView = [[IPCPayOrderTypeTopView alloc]initWithFrame:CGRectMake(0, 0, self.mainView.jk_width, 330)];
        [self.mainView addSubview:self.payTypeTopView];
        [[self.payTypeTopView rac_signalForSelector:@selector(closeAction:)] subscribeNext:^(id x) {
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        }];
        
        self.payTypeBottomView = [[IPCPayOrderTypeBottomView alloc]initWithFrame:CGRectMake(0, self.mainView.jk_height-90, self.mainView.jk_width, 90)];
        [self.mainView addSubview:self.payTypeBottomView];
        
        __weak typeof(self) weakSelf = self;
        [[self.payTypeBottomView rac_signalForSelector:@selector(selectOtherPayStyleAction:)] subscribeNext:^(id x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf packUpOtherPayTypeView];
        }];
        
        [self.mainView addSubview:self.otherPayStyleContentView];
        [self.mainView bringSubviewToFront:self.otherPayStyleContentView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (NSMutableArray<IPCOtherPayTypeView *> *)otherTypeArray{
    if (!_otherTypeArray) {
        _otherTypeArray = [[NSMutableArray alloc]init];
    }
    return _otherTypeArray;
}


#pragma mark //Set UI
- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(self.jk_centerX - 270, self.jk_centerY - 220, 540, 425)];
        [_mainView setBackgroundColor:[UIColor whiteColor]];
        _mainView.layer.cornerRadius = 5;
    }
    return _mainView;
}

- (UIImageView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_backgroundView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.2]];
    }
    return _backgroundView;
}

- (UIView *)otherPayStyleContentView{
    if (!_otherPayStyleContentView) {
        _otherPayStyleContentView = [[UIView alloc]initWithFrame:CGRectMake(20, self.payTypeTopView.jk_bottom + 10, self.mainView.jk_width-40, 0)];
        [_otherPayStyleContentView setBackgroundColor:[UIColor clearColor]];
    }
    return _otherPayStyleContentView;
}

- (void)createOtherPayTypeView{
    [self.otherTypeArray removeAllObjects];
    [self.otherPayStyleContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < count; i++) {
        IPCOtherPayTypeView * otherTypeView = [[IPCOtherPayTypeView alloc]initWithFrame:CGRectMake(0, i*36, self.otherPayStyleContentView.jk_width, 30)];
        [otherTypeView.selectStyleButton setSelected:YES];
        [self.otherPayStyleContentView addSubview:otherTypeView];
        [[otherTypeView rac_signalForSelector:@selector(onSelectPayTypeAction:)] subscribeNext:^(id x) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.otherTypeArray removeObject:otherTypeView];
            [strongSelf packDownOtherPayTypeView];
        }];
        [self.otherTypeArray addObject:otherTypeView];
    }
}


#pragma mark //Clicked Events
- (void)packUpOtherPayTypeView
{
    count++;
     if (count > 6)return;
    
    CGRect frame = self.mainView.frame;
    frame.origin.y -= 18;
    frame.size.height += 36;
    self.mainView.frame = frame;
    
    frame = self.payTypeBottomView.frame;
    frame.origin.y += 36;
    self.payTypeBottomView.frame = frame;
    
    frame = self.otherPayStyleContentView.frame;
    frame.size.height += 36;
    self.otherPayStyleContentView.frame = frame;

    [self createOtherPayTypeView];
}

- (void)packDownOtherPayTypeView
{
    CGRect frame = self.mainView.frame;
    frame.origin.y += 18;
    frame.size.height -= 36;
    self.mainView.frame = frame;
    
    frame = self.payTypeBottomView.frame;
    frame.origin.y -= 36;
    self.payTypeBottomView.frame = frame;
    
    frame = self.otherPayStyleContentView.frame;
    frame.size.height -= 36;
    self.otherPayStyleContentView.frame = frame;
    
    count--;
    [self createOtherPayTypeView];
}


//- (IBAction)selectWechatAction:(UIButton *)sender {
//    if (!sender.selected)[sender setSelected:!sender.selected];
//    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeWechat;
//    [IPCPayOrderMode sharedManager].payStyleName = @"WECHAT";
//    if (self.updateBlock)
//        self.updateBlock();
//}
//
//
//- (IBAction)selectAlipayAction:(UIButton *)sender {
//    if (!sender.selected)[sender setSelected:!sender.selected];
//    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeAlipay;
//    [IPCPayOrderMode sharedManager].payStyleName = @"ALIPAY";
//    if (self.updateBlock)
//        self.updateBlock();
//}
//
//- (IBAction)selectCashAction:(UIButton *)sender {
//    if (!sender.selected)[sender setSelected:!sender.selected];
//    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCash;
//    [IPCPayOrderMode sharedManager].payStyleName = @"CASH";
//    if (self.updateBlock)
//        self.updateBlock();
//}
//
//
//- (IBAction)selectCardAction:(UIButton *)sender {
//    if (!sender.selected)[sender setSelected:!sender.selected];
//    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCard;
//    [IPCPayOrderMode sharedManager].payStyleName = @"CARD";
//    if (self.updateBlock)
//        self.updateBlock();
//}


@end
