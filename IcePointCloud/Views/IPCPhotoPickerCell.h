//
//  ZZPhotoPickerCell.h
//  IcePointCloud
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPhoto.h"

@interface IPCPhotoPickerCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *photo;

@property(strong,nonatomic) void(^selectBlock)();

@property(assign,nonatomic) BOOL isSelect;

-(void)loadPhotoData:(IPCPhoto *)photo;

@end
