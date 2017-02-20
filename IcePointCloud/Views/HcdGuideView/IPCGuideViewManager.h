//
//  HcdGuideViewManager.h
//  IcePointCloud
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCGuideViewManager : NSObject

+ (instancetype)sharedInstance;

/**
 *
 *  @param images
 *  @param title
 *  @param titleColor
 *  @param bgColor
 *  @param borderColor
 *  @param contentView
 *  @param finish      
 */
- (void)showGuideViewWithImages:(NSArray *)images
                         InView:(UIView *)contentView
                         Finish:(void (^)())finish;

@end
