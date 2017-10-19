//
//  ZZPhoto.h
//  IcePointCloud
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPhoto : NSObject

/**
   Asset resource
 */
@property (nonatomic, strong, readwrite) PHAsset *asset;
/**
   Origin Size Image
 */
@property (nonatomic, strong, readwrite) UIImage *originImage;
/**
   Asset filePath
 */
@property (nonatomic, strong, readwrite) NSURL *imageUrl;
/**
   Asset save time
 */
@property (nonatomic, copy, readwrite)   NSDate *createDate;
/**
   Judge asset is selected
 */
@property (nonatomic, assign, readwrite) BOOL isSelect;

+(UIImage *) fetchThumbImageWithAsset:(PHAsset *)asset;

@end
