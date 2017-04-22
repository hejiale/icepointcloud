
//
//  CustomProgress.m
//
//  Created by mac on 16/4/11.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "CustomProgress.h"

@implementation CustomProgress
@synthesize bgimg,leftimg;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgimg.layer.borderColor = [UIColor clearColor].CGColor;
        bgimg.layer.borderWidth =  1;
        bgimg.layer.cornerRadius = frame.size.height/2;
        [bgimg.layer setMasksToBounds:YES];
        [self addSubview:bgimg];
        
        leftimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        leftimg.layer.borderColor = [UIColor clearColor].CGColor;
        leftimg.layer.borderWidth =  1;
        leftimg.layer.cornerRadius = frame.size.height/2;
        [leftimg.layer setMasksToBounds:YES];
        [self addSubview:leftimg];
        
        bgimg.backgroundColor =[[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        leftimg.backgroundColor =COLOR_RGB_BLUE;
    }
    return self;
}
-(void)setPresent:(int)present
{
    leftimg.frame = CGRectMake(0, 0, self.frame.size.width/self.maxValue*present, self.frame.size.height);
}


@end
