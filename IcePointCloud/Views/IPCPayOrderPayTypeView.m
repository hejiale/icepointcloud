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
typedef void(^PayBlock)();

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

@property (nonatomic, copy) PayBlock payBlock;
@property (nonatomic, copy) DismissBlock dismissBlock;
@property (nonatomic, strong) NSMutableArray<IPCOtherPayTypeView *> * otherTypeViewArray;

@end

@implementation IPCPayOrderPayTypeView

- (instancetype)initWithFrame:(CGRect)frame Pay:(void (^)())pay Dismiss:(void (^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dismissBlock = dismiss;
        self.payBlock = pay;
        
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
        
        [self addSubview:self.mainView];
        [self bringSubviewToFront:self.mainView];
        
        __weak typeof(self) weakSelf = self;
        
        self.payTypeTopView = [[IPCPayOrderTypeTopView alloc]initWithFrame:CGRectMake(0, 0, self.mainView.jk_width, 330) Update:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.otherTypeViewArray removeAllObjects];
            count = 0;
            [strongSelf packDownOtherPayTypeView];
        }];
        [self.payTypeTopView reloadUI];
        [self.mainView addSubview:self.payTypeTopView];
        
        [[self.payTypeTopView rac_signalForSelector:@selector(closeAction:)] subscribeNext:^(id x) {
            [[IPCPayOrderMode sharedManager] clearPayTypeData];
            
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        }];
        
        self.payTypeBottomView = [[IPCPayOrderTypeBottomView alloc]initWithFrame:CGRectMake(0, self.mainView.jk_height-90, self.mainView.jk_width, 90)];
        [self.mainView addSubview:self.payTypeBottomView];
        
        [[self.payTypeBottomView rac_signalForSelector:@selector(selectOtherPayStyleAction:)] subscribeNext:^(id x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf packUpOtherPayTypeView];
        }];
        [[self.payTypeBottomView rac_signalForSelector:@selector(payOrderAction:)] subscribeNext:^(id x) {
            if ([[IPCPayOrderMode sharedManager] isExistEmptyOtherTypeName]) {
                [IPCCustomUI showError:@"请检查其它支付方式名称填写完整"];
            }else if ([[IPCPayOrderMode sharedManager] isExistZeroOtherTypeAmount]){
                [IPCCustomUI showError:@"请检查其它支付方式支付金额,确保金额大于零"];
            }else{
                if ([[IPCPayOrderMode sharedManager] waitPayAmount] == [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount] + [[IPCPayOrderMode sharedManager] usedBalanceAmount] + [IPCPayOrderMode sharedManager].payTypeAmount)
                {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf.payBlock) {
                        strongSelf.payBlock();
                    }
                }else{
                    [IPCCustomUI showError:@"付款金额计算有误!"];
                }
            }
        }];
        
        [self.mainView addSubview:self.otherPayStyleContentView];
        [self.mainView bringSubviewToFront:self.otherPayStyleContentView];
    }
    return self;
}

- (NSMutableArray<IPCOtherPayTypeView *> *)otherTypeViewArray{
    if (!_otherTypeViewArray) {
        _otherTypeViewArray = [[NSMutableArray alloc]init];
    }
    return _otherTypeViewArray;
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
        _otherPayStyleContentView = [[UIView alloc]initWithFrame:CGRectMake(20, self.payTypeTopView.jk_bottom + 10, self.mainView.jk_width, 0)];
        [_otherPayStyleContentView setBackgroundColor:[UIColor clearColor]];
    }
    return _otherPayStyleContentView;
}

- (void)createOtherPayTypeView
{
    [self.otherTypeViewArray removeAllObjects];
    [self.otherPayStyleContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __weak typeof(self) weakSelf = self;
    [[IPCPayOrderMode sharedManager].otherPayTypeArray enumerateObjectsUsingBlock:^(IPCOtherPayTypeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         IPCOtherPayTypeView * otherTypeView = [[IPCOtherPayTypeView alloc]initWithFrame:CGRectMake(0, idx*36, self.otherPayStyleContentView.jk_width, 30)
                                                                                  Update:^(IPCOtherPayTypeResult * result){
                                                                                      //刷新价格
                                                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                                      [[IPCPayOrderMode sharedManager] reloadWithOtherTypeAmount];
                                                                                      [strongSelf.payTypeTopView reloadUI];
                                                                                      [strongSelf createOtherPayTypeView];
                                                                                  }];
         otherTypeView.otherPayTypeResult = obj;
         [otherTypeView updateUI];
         [self.otherPayStyleContentView addSubview:otherTypeView];
         //移除该选中其它支付方式
         [[otherTypeView rac_signalForSelector:@selector(onSelectPayTypeAction:)] subscribeNext:^(id x) {
             __strong typeof(weakSelf) strongSelf = weakSelf;
             [[IPCPayOrderMode sharedManager].otherPayTypeArray removeObject:obj];
             [strongSelf.otherTypeViewArray removeObject:otherTypeView];
             [[IPCPayOrderMode sharedManager] reloadWithOtherTypeAmount];
             [strongSelf.payTypeTopView reloadUI];
             [strongSelf packDownOtherPayTypeView];
         }];
         [self.otherTypeViewArray addObject:otherTypeView];
     }];
}


#pragma mark //Clicked Events
- (void)packUpOtherPayTypeView
{
    count++;
    if (count > 6)return;
    
    double minum = [[IPCPayOrderMode sharedManager] waitPayAmount] - [IPCPayOrderMode sharedManager].usedBalanceAmount - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount];
    if (minum <= 0) {
        [IPCCustomUI showError:@"支付金额已达上限!"];
        return;
    }
  
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
    
    IPCOtherPayTypeResult * result = [[IPCOtherPayTypeResult alloc]init];
    [[IPCPayOrderMode sharedManager].otherPayTypeArray addObject:result];
    
    [self createOtherPayTypeView];
}

- (void)packDownOtherPayTypeView
{
    count--;
    if (count <= 0)count = 0;
    
    CGFloat originHeight = self.otherPayStyleContentView.jk_height;
    BOOL  isClear = NO;
    if ([IPCPayOrderMode sharedManager].otherPayTypeArray.count == 0) {
        isClear = YES;
    }
    
    CGRect frame = self.mainView.frame;
    frame.origin.y += (isClear ? originHeight/2 : 18);
    frame.size.height -= (isClear ? originHeight : 36);
    self.mainView.frame = frame;
    
    frame = self.payTypeBottomView.frame;
    frame.origin.y -= (isClear ? originHeight : 36);
    self.payTypeBottomView.frame = frame;
    
    frame = self.otherPayStyleContentView.frame;
    frame.size.height -= (isClear ? originHeight : 36);
    self.otherPayStyleContentView.frame = frame;
    
    [self createOtherPayTypeView];
}


@end
