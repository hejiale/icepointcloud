//
//  IPCCustomButton.m
//  IcePointCloud
//
//  Created by mac on 2016/11/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomButton.h"

#define ImageIndexButtonWidth     5

@interface IPCCustomButton()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImage * normalImage;
@property (nonatomic, strong) UIImage * selectedImage;
@property (nonatomic) IPCCustomButtonAlignment  alignment;

@end

@implementation IPCCustomButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _titleLabel;
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imageView setBackgroundColor:[UIColor clearColor]];
    }
    return _imageView;
}


- (void)setTitle:(nullable NSString *)title{
    [self.titleLabel setText:title];
    [self buildUI];
}


- (void)setTitleColor:(nullable UIColor *)color UI_APPEARANCE_SELECTOR{
    [self.titleLabel setTextColor:color];
}

- (void)setFont:(UIFont *)font{
    [self.titleLabel setFont:font];
}


- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state{
    if (state == UIControlStateNormal) {
        self.normalImage = image;
    }else if (state == UIControlStateSelected){
        self.selectedImage = image;
    }
    [self setSelected:NO];
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    UIControl * control = [[UIControl alloc]initWithFrame:self.bounds];
    [control addTarget:target action:action forControlEvents:controlEvents];
    [self addSubview:control];
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    
    if (selected) {
        [self.imageView setImage:self.selectedImage];
    }else{
        [self.imageView setImage:self.normalImage];
    }
}

- (void)setButtonAlignment:(IPCCustomButtonAlignment)alignment{
    self.alignment = alignment;
}

- (void)buildUI
{
    CGPoint center = CGPointMake(self.jk_width/2, self.jk_height/2);
    CGSize  titleSize = CGSizeZero;
    CGSize  imageSize = CGSizeZero;
    
    if (self.titleLabel.text.length)
        titleSize = [self.titleLabel.text jk_sizeWithFont:self.titleLabel.font constrainedToHeight:self.titleLabel.jk_height];
    
    if (self.imageView.image)
        imageSize = self.imageView.image.size;

    switch (self.alignment) {
        case IPCCustomButtonAlignmentLeft:{
            CGRect  rect = self.titleLabel.frame;
            rect.size.width = titleSize.width + ImageIndexButtonWidth;
            rect.size.height = titleSize.height;
            self.titleLabel.frame  = rect;
            self.titleLabel.center = center;
            
            rect = self.imageView.frame;
            rect.origin.x = self.titleLabel.jk_right;
            rect.origin.y = center.y - imageSize.height/2;
            rect.size = imageSize;
            self.imageView.frame = rect;
        }
            break;
        case IPCCustomButtonAlignmentRight:{
            CGRect  rect = self.titleLabel.frame;
            rect.size.width = titleSize.width;
            rect.size.height = titleSize.height;
            self.titleLabel.frame  = rect;
            self.titleLabel.center = center;
            
            rect = self.imageView.frame;
            rect.origin.x = self.titleLabel.jk_left - imageSize.width - ImageIndexButtonWidth;
            rect.origin.y = center.y - imageSize.height/2;
            rect.size = imageSize;
            self.imageView.frame = rect;
        }
            break;
        case IPCCustomButtonAlignmentTop:{
            CGRect  rect = self.titleLabel.frame;
            rect.origin.x = center.x - titleSize.width/2;
            rect.origin.y = 0;
            rect.size.width = titleSize.width;
            rect.size.height = titleSize.height;
            self.titleLabel.frame  = rect;

            rect = self.imageView.frame;
            rect.origin.x = center.x - imageSize.width/2;
            rect.origin.y = self.titleLabel.jk_bottom + ImageIndexButtonWidth;
            rect.size = imageSize;
            self.imageView.frame = rect;
        }
            break;
        case IPCCustomButtonAlignmentBottom:{
            CGRect  rect = self.titleLabel.frame;
            rect.origin.x = center.x - titleSize.width/2;
            rect.origin.y = self.jk_height - titleSize.height - ImageIndexButtonWidth;
            rect.size.width = titleSize.width;
            rect.size.height = titleSize.height;
            self.titleLabel.frame  = rect;
            
            rect = self.imageView.frame;
            rect.origin.x = center.x - imageSize.width/2;
            rect.origin.y = ImageIndexButtonWidth;
            rect.size = imageSize;
            self.imageView.frame = rect;
        }
            break;
        default:
            break;
    }
    
//    switch (self.alignment) {
//        case IPCCustomButtonAlignmentLeft:{
//            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(titleSize);
//                make.center.equalTo(self);
//            }];
//            
//            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.titleLabel.mas_right).with.offset(ImageIndexButtonWidth);
//                make.centerY.mas_equalTo(self.mas_centerY);
//                make.size.mas_equalTo(imageSize);
//            }];
//        }
//            break;
//        case IPCCustomButtonAlignmentRight:{
//            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(titleSize);
//                make.center.equalTo(self);
//            }];
//            
//            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.titleLabel.mas_left).width.offset(ImageIndexButtonWidth);
//                make.centerY.mas_equalTo(self.mas_centerY);
//                make.size.mas_equalTo(imageSize);
//            }];
//        }
//            break;
//        case IPCCustomButtonAlignmentTop:{
//            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.mas_centerX);
//                make.top.equalTo(self.mas_top).width.offset(0);
//                make.size.mas_equalTo(titleSize);
//            }];
//            
//            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.mas_centerX);
//                make.top.equalTo(self.titleLabel.mas_bottom).width.offset(ImageIndexButtonWidth);
//                make.size.mas_equalTo(imageSize);
//            }];
//        }
//            break;
//        case IPCCustomButtonAlignmentBottom:{
//            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.mas_centerX);
//                make.bottom.equalTo(self.mas_bottom).width.offset(0);
//                make.size.mas_equalTo(titleSize);
//            }];
//            
//            [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.mas_centerX);
//                make.top.equalTo(self.mas_top).width.offset(ImageIndexButtonWidth);
//                make.size.mas_equalTo(imageSize);
//            }];
//        }
//            break;
//        default:
//            break;
//    }
}


@end
