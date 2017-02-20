//
//  ZZPhotoDatas.h
//  IcePointCloud
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPhotoListModel.h"
#import "IPCPhoto.h"

@interface IPCPhotoDatas : NSObject


/*
 *    Query asset libray list
 */
- (NSMutableArray<IPCPhotoListModel *> *) GetPhotoListDatas;
/*
 *    To get a photo album of the result set
 */
-(PHFetchResult *) GetFetchResult:(PHAssetCollection *)collection;
/*
 *    Get photo entities, and the image results stored in the array, returns an array of values
 */
-(NSMutableArray<IPCPhoto *> *) GetPhotoAssets:(PHFetchResult *)fetchResult;
/*
 *    Only camera film results were obtained
 */
-(PHFetchResult *) GetCameraRollFetchResul;

/*
 *    Callback method using the array
 */
-(void) GetImageObject:(id)asset complection:(void (^)(UIImage *,NSURL *))complection;

/*
 *    Check for up to resources
 */
-(BOOL) CheckIsiCloudAsset:(PHAsset *)asset;
@end
