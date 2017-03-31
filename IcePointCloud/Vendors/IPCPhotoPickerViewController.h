//
//  ZZPhotoPickerViewController.h
//  IcePointCloud
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPhotoPickerViewController : UIViewController

- (instancetype)initWithCompleteImage:(void(^)(UIImage *image))imageBlock;

@end