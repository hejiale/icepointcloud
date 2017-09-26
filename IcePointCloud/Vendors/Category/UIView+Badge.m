//
//  UIView+Badge.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "UIView+Badge.h"
#include <objc/runtime.h>

const static  void *BadgeLableString =&BadgeLableString;

@interface BadgeLable : UILabel

@end

@implementation BadgeLable


-(void)createBadgeViewWithframe:(CGRect )frame Text:(NSString *)text
{
    self.frame=frame;
    self.backgroundColor=COLOR_RGB_RED;
    self.textColor=[UIColor  whiteColor];
    self.font=[UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    self.text=text;
    self.textAlignment= NSTextAlignmentCenter;
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=frame.size.height/2;
}


@end

@implementation UIView (Badge)

-(void)createBadgeText:(NSString *)text
{
    if (![self badgeLable]) {
        BadgeLable *badgeLable =[[BadgeLable alloc] init];
        objc_setAssociatedObject(self, BadgeLableString, badgeLable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:badgeLable];
    }
    
    if ([text integerValue] > 0) {
        [[self badgeLable] setHidden:NO];
        
        CGSize textSize=[self sizeWithString:text font:[UIFont systemFontOfSize:10 weight:UIFontWeightThin] constrainedToWidth:self.frame.size.width];
        
        if ([self isKindOfClass:[UIButton class]])
        {
            UIButton *weakButton=(UIButton*)self;
            [[self  badgeLable] createBadgeViewWithframe:CGRectMake(weakButton.imageView.jk_width*0.6+weakButton.imageView.jk_left,weakButton.imageView.jk_top, textSize.width+8.0, textSize.height) Text:text];
        }else{
            [[self  badgeLable] createBadgeViewWithframe:CGRectMake(self.frame.size.width-(textSize.width+8.0)*0.5, -5, textSize.width+8.0, textSize.height) Text:text];
        }
    }else{
        [[self badgeLable] setHidden:YES];
    }
}


-(void)removeBadgeView{
    [[self badgeLable] removeFromSuperview];
}


-(BadgeLable *)badgeLable{
    BadgeLable *badgeLable=objc_getAssociatedObject(self, BadgeLableString);
    return badgeLable;
}


#pragma mark sizeLableText
-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:(NSStringDrawingUsesLineFragmentOrigin |
                                             NSStringDrawingTruncatesLastVisibleLine)
                                 attributes:attributes
                                    context:nil].size;
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

@end

