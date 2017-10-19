//
//  ZZPhotoListModel.h
//  IcePointCloud
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPhoto.h"

@interface IPCPhotoListModel : NSObject

@property (assign, nonatomic, readwrite) NSInteger count;
@property (strong, nonatomic, readwrite) PHAsset *lastObject;
@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) PHAssetCollection *assetCollection;
@property (strong, nonatomic, readwrite) NSArray<IPCPhoto *> * assetArray;

@end
