//
//  MatchItem.h
//  IcePointCloud
//
//  Created by heartace on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCGlasses.h"

@interface IPCMatchItem : NSObject

@property (nonatomic, strong) IPCGlasses *glass;
@property (nonatomic) IPCModelType modelType;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat scale;
@property (nonatomic, strong) UIImage *frontialPhoto;//Taken a positive figure
@property (nonatomic) IPCPhotoType photoType;

@end
