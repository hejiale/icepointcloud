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
@property (strong, nonatomic)  UIButton *operationButton;
@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCEmptyAlertView

- (instancetype)initWithFrame:(CGRect)frame
                   AlertImage:(NSString *)imageName
                LoadingImages:(NSArray<UIImage *> *)images
                   AlertTitle:(NSString *)title
               OperationTitle:(NSString *)operationTitle
                     Complete:(void(^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
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

        if (operationTitle) {
            [self addSubview:self.operationButton];
            [self.operationButton setTitle:operationTitle forState:UIControlStateNormal];
            
            CGFloat width = [operationTitle jk_widthWithFont:self.operationButton.titleLabel.font constrainedToHeight:30];
            
            [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.top.equalTo(self.alertLabel.mas_bottom).with.offset(20);
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

- (UIButton *)operationButton{
    if (!_operationButton) {
        _operationButton = [[UIButton alloc]init];
        [_operationButton setBackgroundColor:COLOR_RGB_BLUE];
        [_operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_operationButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        [_operationButton addSignleCorner:UIRectCornerAllCorners Size:3];
        [_operationButton addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operationButton;
}

#pragma mark //Methods
- (void)operationAction:(id)sender {
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
}

@end
