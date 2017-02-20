//
//  ZZPhoto.m
//  IcePointCloud
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPhoto.h"

@implementation IPCPhoto

+(UIImage *) fetchThumbImageWithAsset:(PHAsset *)asset
{
    __block UIImage *thumbImage;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        //return high asset image
        if (downloadFinined) {

            thumbImage = result;
        }
        
    }];
    
    return thumbImage;
}

@end
