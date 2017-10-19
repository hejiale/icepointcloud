//
//  IPCPhotoPickerBaseComponent.h
//  IcePointCloud
//
//  Created by gerry on 2017/10/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPhotoPickerBaseComponent : NSObject

- (instancetype)initWithResultImage:(void(^)(UIImage * image))imageBlock;

- (void)showSampleWithController:(UIViewController *)controller;

@end

@interface IPCPhotoPickerViewController : UIViewController

- (instancetype)initWithCompleteImage:(void(^)(UIImage *image))imageBlock;

@end
