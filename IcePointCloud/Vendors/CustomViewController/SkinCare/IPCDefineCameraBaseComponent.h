//
//  DefineCameraBaseComponent.h
//  IcePointCloud
//
//  Created by mac on 15/5/11.
//  Copyright (c) 2016年 Doray. All rights reserved.
//



/**
 *  Basic camera custom - the underlying API
 */

@interface IPCDefineCameraBaseComponent : NSObject

- (instancetype)initWithResultImage:(void(^)(UIImage * image))imageBlock;

- (void)showSampleWithController:(UIViewController *)controller;

@end

#pragma mark - DefineCameraViewController
/**
 *  Basic camera view controller
 */
@interface IPCDefineCameraViewController : UIViewController

- (instancetype)initWithImageBlock:(void(^)(UIImage *image))imageBlock;

@end
