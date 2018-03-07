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
@property (strong, nonatomic) NSArray * images;
@property (copy, nonatomic) NSString * imageName;
@property (copy, nonatomic) NSString * title;


@end

@implementation IPCEmptyAlertView

- (instancetype)initWithFrame:(CGRect)frame
                   AlertImage:(NSString *)imageName
                LoadingImages:(NSArray<UIImage *> *)images
                   AlertTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.images = images;
        self.imageName = imageName;
        self.title = title;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.images && self.images.count) {
        UIImage * image = self.images[0];
        
        [self addSubview:self.alertImageView];
        [self.alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(image.size.width);
            make.height.mas_equalTo(image.size.height);
        }];
        self.alertImageView.animationImages = self.images;
        [self.alertImageView setAnimationRepeatCount:0];
        [self.alertImageView setAnimationDuration:self.images.count * 0.1];
        [self.alertImageView startAnimating];
    }else if(self.imageName && [self.imageName isKindOfClass:[NSString class]])
    {
        UIImage * image = [UIImage imageNamed:self.imageName];
        [self.alertImageView setImage:image];
        [self addSubview:self.alertImageView];
        
        [self.alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(image.size.width);
            make.height.mas_equalTo(image.size.height);
        }];
    }
    
    if (self.title && self.title.length) {
        [self addSubview:self.alertLabel];
        [self.alertLabel setText:self.title];
        
        CGFloat width = [self.title jk_widthWithFont:self.alertLabel.font constrainedToHeight:30];
        
        [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertImageView.mas_bottom).with.offset(20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(30);
        }];
    }
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
