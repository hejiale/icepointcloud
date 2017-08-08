//
//  IPCProgressHUD.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCProgressHUD.h"

@interface IPCProgressHUD()

@property (nonatomic, readonly) UIWindow *frontWindow;
@property (strong, nonatomic) UIVisualEffectView   *  contentView;
@property (strong, nonatomic) UILabel  *  statusLabel;
@property (strong, nonatomic) UIImageView * statusImageView;


@end

@implementation IPCProgressHUD

+ (IPCProgressHUD*)sharedView
{
    static dispatch_once_t once;
    
    static IPCProgressHUD *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        self.userInteractionEnabled = NO;
        
        self.maxSupportedWindowLevel = UIWindowLevelNormal;
    }
    return self;
}

+ (void)show {
    [[self sharedView] setStatus:nil];
}

+ (void)showWithStatus:(NSString *)status
{
    [self showImages:nil status:status];
}

+ (void)showImages:(NSArray<NSString *> *)images status:(NSString*)status
{
    [[self sharedView] setStatus:status];
    [[self sharedView] setAnimationImages:images];
    [[self sharedView] updateStatusFrame];
}

+ (void)dismiss{
    [[self sharedView] dismissWithDuration:0.15f Delay:0 completion:nil];
}

+ (void)dismissWithDuration:(NSTimeInterval)duration Delay:(NSTimeInterval)delay{
    [[self sharedView] dismissWithDuration:duration Delay:delay completion:nil];
}

- (void)setStatus:(NSString*)status
{
    if (!status) {
        return;
    }
    self.statusLabel.text = status;
}

- (void)setAnimationImages:(NSArray<NSString *> *)images
{
    if (!images && !images.count) {
        return;
    }
    __block NSMutableArray<UIImage *> * imageArray = [[NSMutableArray alloc]init];
    [images enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * image = [UIImage imageNamed:obj];
        [imageArray addObject:image];
    }];
    [self.statusImageView setAnimationImages:imageArray];
    [self.statusImageView setAnimationDuration:0.1*imageArray.count];
    [self.statusImageView startAnimating];
}

- (void)updateContentFrame
{
    [self.frontWindow addSubview:self];
    [self addSubview:self.contentView];
    [self.contentView addBorder:10 Width:0];
    [self bringSubviewToFront:self.contentView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.statusImageView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)updateStatusFrame
{
    [self updateContentFrame];
    // Calculate size of string
    CGRect labelRect = CGRectZero;
    CGFloat labelHeight = 0.0f;
    CGFloat labelWidth = 0.0f;
    
    if(self.statusLabel.text) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        labelRect = [self.statusLabel.text boundingRectWithSize:constraintSize
                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName: self.statusLabel.font}
                                                        context:NULL];
        labelHeight = ceilf(CGRectGetHeight(labelRect));
        labelWidth = ceilf(CGRectGetWidth(labelRect));
    }
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
}

- (void)dismissWithDuration:(NSTimeInterval)duration Delay:(NSTimeInterval)delay completion:(void(^)())completion
{
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        __block void (^animationsBlock)(void) = ^{
            // Shrink HUD a little to make a nice disappear animation
            strongSelf.contentView.transform = CGAffineTransformScale(strongSelf.contentView.transform, 1/1.3f, 1/1.3f);
            strongSelf.contentView.alpha = 0.f;
        };
        
        __block void (^completionBlock)(void) = ^{
            [strongSelf.statusImageView removeFromSuperview];strongSelf.statusImageView = nil;
            [strongSelf.statusLabel removeFromSuperview];strongSelf.statusLabel = nil;
            [strongSelf.contentView removeFromSuperview];strongSelf.contentView = nil;
            [strongSelf removeFromSuperview];
        };
        
        dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
        dispatch_after(dipatchTime, dispatch_get_main_queue(), ^
                       {
                           [UIView animateWithDuration:duration
                                                 delay:delay
                                               options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState)
                                            animations:^{
                                                animationsBlock();
                                            } completion:^(BOOL finished) {
                                                completionBlock();
                                            }];
                           [strongSelf setNeedsDisplay];
                       });
    }];
}

#pragma mark //Set UI
- (UIVisualEffectView *)contentView{
    if (!_contentView) {
        _contentView = [[UIVisualEffectView alloc]init];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        _contentView.layer.masksToBounds = YES;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _contentView.effect = blurEffect;
    }
    return _contentView;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        [_statusLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        [_statusLabel setTextColor:[UIColor lightGrayColor]];
        [_statusLabel setBackgroundColor:[UIColor clearColor]];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}

- (UIImageView *)statusImageView{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc]init];
        [_statusImageView setBackgroundColor:[UIColor clearColor]];
        _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusImageView;
}

- (UIWindow *)frontWindow {
#if !defined(SV_APP_EXTENSIONS)
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= self.maxSupportedWindowLevel);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
#endif
    return nil;
}


@end
