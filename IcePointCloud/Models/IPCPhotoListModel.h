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

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) PHAsset *lastObject;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) NSArray<IPCPhoto *> * assetArray;

@end
