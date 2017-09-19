//
//  EmptyAlertView.m
//  IcePointCloud
//
//  Created by mac on 16/11/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEmptyAlertView.h"

@interface IPCEmptyAlertView()

@property (strong, nonatomic)  UIImageView *alertImageView;
@property (strong, nonatomic)  UILabel *alertLabel;

@end

@implementation IPCEmptyAlertView

- (instancetype)initWithFrame:(CGRect)frame
                   AlertImage:(NSString *)imageName
                LoadingImages:(NSArray<UIImage *> *)images
                   AlertTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {        
        if (images && images.count) {
            UIImage * image = images[0];
            
            [self addSubview:self.alertImageView];
            [self.alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.width.mas_equalTo(image.size.width);
                make.height.mas_equalTo(image.size.height);
            }];
            self.alertImageView.animationImages = images;
            [self.alertImageView setAnimationRepeatCount:0];
            [self.alertImageView setAnimationDuration:images.count * 0.1];
            [self.alertImageView startAnimating];
        }else if(imageName && imageName.length)
        {
            __block UIImage * image = [UIImage imageNamed:imageName];
            
            [self addSubview:self.alertImageView];
            [self.alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.width.mas_equalTo(image.size.width);
                make.height.mas_equalTo(image.size.height);
            }];
            [self.alertImageView setImage:[UIImage imageNamed:imageName]];
        }
        
        if (title && title.length) {
            [self addSubview:self.alertLabel];
            [self.alertLabel setText:title];
            
            CGFloat width = [title jk_widthWithFont:self.alertLabel.font constrainedToHeight:30];
            
            [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.alertImageView.mas_bottom).with.offset(20);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(30);
            }];
        }
    }
    return self;
}

#pragma mark //Set UI
- (UIImageView *)alertImageView{
    if (!_alertImageView) {
        _alertImageView = [[UIImageView alloc]init];
        _alertImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_alertImageView setBackgroundColor:[UIColor clearColor]];
    }
    return _alertImageView;
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]init];
        [_alertLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        [_alertLabel setBackgroundColor:[UIColor clearColor]];
        [_alertLabel setTextColor:[UIColor lightGrayColor]];
    }
    return _alertLabel;
}


@end
