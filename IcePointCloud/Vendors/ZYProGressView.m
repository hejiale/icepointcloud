//
//  ZYProGressView.m
//  ProgressBar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ZYProGressView.h"

@interface ZYProGressView()
{
    UIView *viewTop;
    UIView *viewBottom;
}

@end
@implementation ZYProGressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self buildUI];
        
    }
    return self;
}

- (void)buildUI
{
    viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.jk_width, self.jk_height)];
    viewBottom.layer.cornerRadius = viewBottom.jk_height/2;
    [self addSubview:viewBottom];
    
    viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, viewBottom.frame.size.height)];
    viewTop.layer.cornerRadius = viewBottom.jk_height/2;
    [viewBottom addSubview:viewTop];
}


-(void)setProgressValue:(NSString *)progressValue
{
    _progressValue = progressValue;
    viewTop.frame = CGRectMake(viewTop.frame.origin.x, viewTop.frame.origin.y, viewBottom.frame.size.width*[progressValue floatValue], viewTop.frame.size.height);
}


-(void)setBottomColor:(UIColor *)bottomColor
{
    _bottomColor = bottomColor;
    viewBottom.backgroundColor = bottomColor;
}

-(void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    viewTop.backgroundColor = progressColor;
}

@end
