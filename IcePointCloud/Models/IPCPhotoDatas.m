//
//  ZZPhotoDatas.m
//  IcePointCloud
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 Doray. All rights reserved.
//

#import "IPCPhotoDatas.h"


@implementation IPCPhotoDatas


- (NSArray<NSString *> *)albumNameGroup{
    return @[@"相机胶卷",@"个人收藏",@"自拍",@"屏幕快照",@"最近添加"];
}

- (NSMutableArray<IPCPhotoListModel *> *)GetPhotoListDatas
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    //System photo album
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular  options:fetchOptions];
    //Traverse the camera film
    [smartAlbumsFetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        if (![collection.localizedTitle isEqualToString:@"video"])
        {
            [[self albumNameGroup] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([collection.localizedTitle isEqualToString:obj])
                {
                    NSArray<PHAsset *> *assets = [self GetAssetsInAssetCollection:collection];
                    if ([assets count] > 0) {
                        NSMutableArray<IPCPhoto *> * photoArray = [[NSMutableArray alloc]init];
                        
                        IPCPhotoListModel *listModel = [[IPCPhotoListModel alloc]init];
                        listModel.count = assets.count;
                        listModel.title = collection.localizedTitle;
                        listModel.lastObject = assets.lastObject;
                        listModel.assetCollection = collection;
                        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            IPCPhoto *photo = [[IPCPhoto alloc]init];
                            photo.asset = obj;
                            [photoArray addObject:photo];
                        }];
                        listModel.assetArray = photoArray;
                        [dataArray addObject:listModel];
                    }
                }
            }];
        }
    }];
    
    //Traverse the custom photo album
    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    [smartAlbumsFetchResult1 enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        NSArray<PHAsset *> *assets = [self GetAssetsInAssetCollection:collection];
        if ([assets count] > 0) {
            NSMutableArray<IPCPhoto *> * photoArray = [[NSMutableArray alloc]init];
            
            IPCPhotoListModel *listModel = [[IPCPhotoListModel alloc]init];
            listModel.count = assets.count;
            listModel.title = collection.localizedTitle;
            listModel.lastObject = assets.lastObject;
            listModel.assetCollection = collection;
            [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IPCPhoto *photo = [[IPCPhoto alloc]init];
                photo.asset = obj;
                [photoArray addObject:photo];
            }];
            listModel.assetArray = photoArray;
            [dataArray addObject:listModel];
        }
    }];
    
    return dataArray;
}


- (NSArray *)GetAssetsInAssetCollection:(PHAssetCollection *)assetCollection
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self GetFetchResult:assetCollection];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

-(PHFetchResult *)GetFetchResult:(PHAssetCollection *)assetCollection
{
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
}

- (NSMutableArray<IPCPhoto *> *) GetPhotoAssets:(PHFetchResult *)fetchResult
{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //Resources, only add images type filter in addition to the type of video resources
        if (asset.mediaType == PHAssetMediaTypeImage) {
            IPCPhoto *photo = [[IPCPhoto alloc]init];
            photo.asset = asset;
            [dataArray addObject:photo];
        }
    }
    return dataArray;
}

-(PHFetchResult *)GetCameraRollFetchResul
{
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    if ([smartAlbumsFetchResult count] > 0) {
        PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:[smartAlbumsFetchResult objectAtIndex:0] options:nil];
        return fetch;
    }
    return nil;
}

-(void) GetImageObject:(id)asset complection:(void (^)(UIImage *,NSURL *))complection
{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            
            //BOOL judgment to determine return hd pictures
            if (downloadFinined) {
                NSURL *imageUrl = (NSURL *)[info objectForKey:@"PHImageFileURLKey"];
                complection(result,imageUrl);
            }
        }];

    }
    
}

-(BOOL) CheckIsiCloudAsset:(PHAsset *)asset
{
    CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat pixelWidth = photoWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = YES;
    __block BOOL isICloudAsset = NO;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        if([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
            isICloudAsset = YES;
        }
    }];
    
    return isICloudAsset;
}
@end
