//
//  EditFilterSampleController.h
//  IcePointCloud
//
//  Created by mac on 1/28/16.
//  Copyright © 2016年 Doray. All rights reserved.
//


/**
 *  Filter components sample
 */
@interface IPCEditFilterSampleController : TuSDKPFEditFilterController

- (instancetype)initWithResultImage:(void(^)(UIImage * image))imageBlock;

- (void)showImage:(UIImage *)image;

@end
