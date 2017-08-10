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
@property (nonatomic, strong) UIControl *controlView;
@property (nonatomic, strong) UIView *backgroundView;
@property (strong, nonatomic) UIVisualEffectView   *  hudView;
@property (strong, nonatomic) UILabel  *  statusLabel;
@property (strong, nonatomic) UIImageView * statusImageView;
@property (strong, nonatomic) UIImage *successImage;
@property (strong, nonatomic) UIImage *errorImage;

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
        self.userInteractionEnabled = NO;
        
        self.hudView.contentView.alpha = 0.0f;
        self.backgroundView.alpha = 0.0f;
        
        self.errorImage = [UIImage imageNamed:@"icon_cancel"];
        self.successImage = [UIImage imageNamed:@"icon_sure"];
        
        self.maxSupportedWindowLevel = UIWindowLevelAlert;
    }
    return self;
}

+ (void)showWithStatus:(NSString *)status
{
    [self showAnimationImages:nil status:status];
}

+ (void)showAnimationImages:(NSArray<NSString *> *)images
{
    [self showAnimationImages:images status:nil];
}

+ (void)showError:(NSString *)error Duration:(NSTimeInterval)duration
{
    [[self sharedView] setStatus:error];
    [[self sharedView].statusImageView setImage:[self sharedView].errorImage];
    [[self sharedView] updateViewHierarchy];
    [[self sharedView] updateContentFrame];
    [[self sharedView] showWithDuration:duration];
}

+(void)showSuccess:(NSString *)success Duration:(NSTimeInterval)duration
{
    [[self sharedView] setStatus:success];
    [[self sharedView].statusImageView setImage:[self sharedView].successImage];
    [[self sharedView] updateViewHierarchy];
    [[self sharedView] updateContentFrame];
    [[self sharedView] showWithDuration:duration];
}

+ (void)showAnimationImages:(NSArray<NSString *> *)images status:(NSString*)status
{
    [[self sharedView] setStatus:status];
    [[self sharedView] setAnimationImages:images];
    [[self sharedView] updateViewHierarchy];
    [[self sharedView] updateContentFrame];
    [[self sharedView] showWithDuration:0.15f];
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


- (void)updateViewHierarchy {
    // Add the overlay to the application window if necessary
    if(!self.controlView.superview) {
        [self.frontWindow addSubview:self.controlView];
    } else {
        [self.controlView.superview bringSubviewToFront:self.controlView];
    }
    
    // Add self to the overlay view
    if(!self.superview) {
        [self.controlView addSubview:self];
    }
}

- (void)updateContentFrame
{
    [self insertSubview:self.backgroundView belowSubview:self.hudView];
    [self addSubview:self.hudView];
    
    [self.hudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [self.hudView addSubview:self.statusLabel];
    [self updateStatusLabelFrame];
    
    [self.hudView addSubview:self.statusImageView];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hudView.mas_centerX).offset(0);
        make.centerY.equalTo(self.hudView.mas_centerY).offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)updateStatusLabelFrame
{
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
        make.centerX.equalTo(self.hudView.mas_centerX).offset(0);
        make.bottom.equalTo(self.hudView.mas_bottom).offset(-10);
        make.width.mas_equalTo(labelWidth);
        make.height.mas_equalTo(labelHeight);
    }];
}

- (void)showWithDuration:(NSTimeInterval)duration
{
    if(self.hudView.contentView.alpha != 1.0f){
        // Zoom HUD a little to make a nice appear / pop up animation
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
        
        // Define blocks
        __block void (^animationsBlock)(void) = ^{
            // Shrink HUD to finish pop up animation
            self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3f, 1/1.3f);
            // Update alpha
            self.hudView.contentView.alpha = 1.0f;
            self.backgroundView.alpha = 1.0f;
        };
        
        __block void (^completionBlock)(void) = ^{
            [self dismissWithDuration:0 Delay:0 completion:nil];
        };
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             animationsBlock();
                         } completion:^(BOOL finished) {
                             completionBlock();
                         }];
        
        [self setNeedsDisplay];
    }
}

- (void)dismissWithDuration:(NSTimeInterval)duration Delay:(NSTimeInterval)delay completion:(void(^)())completion
{
    __weak typeof(self) weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        __block void (^animationsBlock)(void) = ^{
            // Shrink HUD a little to make a nice disappear animation
            strongSelf.hudView.transform = CGAffineTransformScale(strongSelf.hudView.transform, 1/1.3f, 1/1.3f);
            strongSelf.hudView.alpha = 0.f;
        };
        
        __block void (^completionBlock)(void) = ^{
            [strongSelf.hudView removeFromSuperview];strongSelf.hudView = nil;
            [strongSelf.backgroundView removeFromSuperview];strongSelf.backgroundView = nil;
            [strongSelf.controlView removeFromSuperview];strongSelf.controlView = nil;
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
- (UIControl*)controlView {
    if(!_controlView) {
        _controlView = [UIControl new];
        _controlView.frame = [[[UIApplication sharedApplication] delegate] window].bounds;
        _controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _controlView.backgroundColor = [UIColor clearColor];
    }
    return _controlView;
}


-(UIView *)backgroundView {
    if(!_backgroundView){
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _backgroundView;
}


- (UIVisualEffectView *)hudView{
    if (!_hudView) {
        _hudView = [[UIVisualEffectView alloc]init];
        [_hudView setBackgroundColor:[UIColor clearColor]];
        _hudView.layer.masksToBounds = YES;
        _hudView.layer.cornerRadius = 10;
        _hudView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _hudView.effect = blurEffect;
    }
    
    if(!_hudView.superview) {
        [self addSubview:_hudView];
    }
    return _hudView;
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
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= self.maxSupportedWindowLevel);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}

+ (BOOL)isVisible{
    return [self sharedView].hudView.alpha > 0;
}


@end
