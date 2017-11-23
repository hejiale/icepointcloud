//
//  IPCCustomButton.h
//  IcePointCloud
//
//  Created by mac on 2016/11/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   Define the direction of the words and pictures of the Button
 */
typedef NS_ENUM(NSInteger, IPCCustomButtonAlignment) {
    /**
     *  title  is left
     */
    IPCCustomButtonAlignmentLeft = 0,
    /**
     *  title   is  right
     */
    IPCCustomButtonAlignmentRight   = 1,
    /**
     *  title  is top
     */
    IPCCustomButtonAlignmentTop  = 2,
    /**
     *  title is bottom
     */
    IPCCustomButtonAlignmentBottom   = 3,
};


@interface IPCDynamicImageTextButton : UIView

@property(nonatomic,getter=isSelected) BOOL selected;
@property(nonatomic, copy) NSString * title;

- (void)setTitle:(nullable NSString *)title;
- (void)setTitleColor:(nullable UIColor *)color UI_APPEARANCE_SELECTOR;
- (void)setFont:(UIFont *)font;
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state;
- (void)setButtonAlignment:(IPCCustomButtonAlignment)alignment;
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
