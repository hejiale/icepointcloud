//
//  CustomProgress.h
//
//  Created by mac on 16/4/11.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomProgress : UIView

@property(nonatomic, retain)UIImageView *bgimg;
@property(nonatomic, retain)UIImageView *leftimg;
@property(nonatomic)float maxValue;

-(void)setPresent:(int)present;


@end
