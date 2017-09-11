//
//  IPCProgressHUD.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCProgressHUD.h"

#define Default_Duration  30.f

@interface IPCProgressHUD()

@property (nonatomic, strong) UIControl *controlView;
@property (nonatomic, strong) UIView *backgroundView;
@property (strong, nonatomic) UIVisualEffectView   *  hudView;
@property (strong, nonatomic) UIImageView * statusImageView;


@end

@implementation IPCProgressHUD

+ (IPCProgressHUD*)sharedView
{
    static dispatch_once_t once;
    static IPCProgressHUD *sharedView;

    dispatch_once(&once, ^{
        sharedView = [[self alloc] init];
    });

    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

+ (void)showAnimationImages:(NSArray<NSString *> *)images
{
    [[self sharedView] setFrame:[[UIApplication sharedApplication].windows lastObject].bounds];
    [[self sharedView] setAnimationImages:images];
    [[self sharedView] updateViewHierarchy];
    [[self sharedView] updateContentFrame];
    [[self sharedView] showWithDuration:Default_Duration];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:[self sharedView]];
    [[self sharedView].superview bringSubviewToFront:[self sharedView]];
}

+ (void)dismiss
{
    [[self sharedView] dismissWithDuration:0 Delay:0 completion:nil];
}

+ (void)dismissWithDuration:(NSTimeInterval)duration Delay:(NSTimeInterval)delay
{
    [[self sharedView] dismissWithDuration:duration Delay:delay completion:nil];
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
        [[UIApplication sharedApplication].windows.lastObject addSubview:self.controlView];
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
    
    [self.hudView addSubview:self.statusImageView];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hudView.mas_centerX).offset(0);
        make.centerY.equalTo(self.hudView.mas_centerY).offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
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
        _controlView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        _controlView.backgroundColor = [UIColor clearColor];
    }
    return _controlView;
}


-(UIView *)backgroundView {
    if(!_backgroundView){
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.2];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
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

- (UIImageView *)statusImageView{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc]init];
        [_statusImageView setBackgroundColor:[UIColor clearColor]];
        _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusImageView;
}

+ (BOOL)isVisible{
    return [self sharedView].alpha > 0;
}


@end
