//
//  UITextField+Extend.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/30.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "UITextField+Extend.h"

@implementation UITextField (Extend)

- (void)setLeftImageView:(NSString *)imageName
{
    UIImage * leftImage = [UIImage imageNamed:imageName];
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, leftImage.size.width, self.jk_height)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, leftImage.size.width, leftImage.size.height)];
    [leftImageView setImage:leftImage];
    [leftImageView setCenter:leftView.center];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:leftImageView];
    
    [self setLeftView:leftView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}


- (void)setRightView:(id)target Action:(SEL)action
{
    UIButton * chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setFrame:CGRectMake(0, 0, 40, 40)];
    [chooseButton setImage:[UIImage imageNamed:@"icon_down_arrow"] forState:UIControlStateNormal];
    [chooseButton setBackgroundColor:[UIColor clearColor]];
    [chooseButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightView:chooseButton];
    [self setRightViewMode:UITextFieldViewModeAlways];
}


- (void)setRightButton:(id)target Action:(SEL)action OnView:(UIView *)onView
{
    UIButton * chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setFrame:self.frame];
    [chooseButton setBackgroundColor:[UIColor clearColor]];
    [chooseButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [onView addSubview:chooseButton];
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, self.jk_height)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, rightView.jk_height/2-6, 12, 12)];
    [rightImage setImage:[UIImage imageNamed:@"icon_down_arrow"]];
    rightImage.contentMode = UIViewContentModeScaleAspectFit;
    [rightImage setBackgroundColor:[UIColor clearColor]];
    [rightView addSubview:rightImage];
    
    [self setUserInteractionEnabled:NO];
    [self setRightView:rightView];
    [self setRightViewMode:UITextFieldViewModeAlways];
}

- (void)setLeftSpace:(double)spaceWidth{
    UIView * spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, spaceWidth, self.jk_height)];
    [spaceView setBackgroundColor:[UIColor clearColor]];
    [self setLeftView:spaceView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)setRightSpace:(double)spaceWidth{
    UIView * spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, spaceWidth, self.jk_height)];
    [spaceView setBackgroundColor:[UIColor clearColor]];
    [self setRightView:spaceView];
    [self setRightViewMode:UITextFieldViewModeAlways];
}

- (void)setLeftText:(NSString *)text
{
    CGFloat width  = [text jk_sizeWithFont:self.font constrainedToHeight:self.jk_height].width;
    
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width + 10, self.jk_height)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:leftView.bounds];
    [textLabel setText:text];
    [textLabel setTextColor:[UIColor lightGrayColor]];
    [textLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [leftView addSubview:textLabel];
    
    [self setLeftView:leftView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

@end
