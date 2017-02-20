//
//  EditFilterSampleController.m
//  IcePointCloud
//
//  Created by mac on 1/28/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditFilterSampleController.h"

@interface IPCEditFilterSampleController()

@property (nonatomic, copy) void(^ResultImageBlock)(UIImage *);

@end

@implementation IPCEditFilterSampleController

- (instancetype)initWithResultImage:(void(^)(UIImage * image))imageBlock{
    self = [super init];
    if (self) {
        self.ResultImageBlock = imageBlock;
    }
    return self;
}


- (void)showImage:(UIImage *)image{
    [self initParamsWithImage:image];
}

/**
 *  Set the parameters
 */
- (void)initParamsWithImage:(UIImage *)image
{
    self.inputImage = image;
    
    // Filter the history
    self.enableFilterHistory = NO;
    // Open online filter
    self.enableOnlineFilter = NO;
}

/**
 *  Notify the processing result
 *
 *  @param result SDK
 */
- (void)notifyProcessingWithResult:(TuSDKResult *)result;
{
    [super notifyProcessingWithResult:result];
    
    UIImage * sourceImage = [[result loadResultImage] lsqImageScale:0.68];
    UIImage *image = [result.image lsqImageCorpWithSize:sourceImage.size rect:CGRectMake(0, 60, self.view.jk_width, self.view.jk_height - 160) outputSize:CGSizeMake(531, 698) orientation:UIImageOrientationUp interpolationQuality:kCGInterpolationHigh];
    
    if (self.ResultImageBlock)
        self.ResultImageBlock(image);
    
    [self backActionHadAnimated];
}

@end
