//
//  ZZPhotoPickerCell.m
//  IcePointCloud
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCPhotoPickerCell.h"

@implementation IPCPhotoPickerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _photo = [[UIImageView alloc]initWithFrame:self.bounds];
        
        _photo.layer.masksToBounds = YES;
        
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_photo];
        
    }
    return self;
}



-(void)loadPhotoData:(IPCPhoto *)photo
{
    if ([photo isKindOfClass:[IPCPhoto class]]) {
        [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:CGSizeMake(photo.asset.pixelWidth, photo.asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
            self.photo.image = result;
            
        }];
        
    }
}
@end
