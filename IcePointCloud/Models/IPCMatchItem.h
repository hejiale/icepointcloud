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

@property (nonatomic, strong, readwrite) IPCGlasses *glass;
@property (nonatomic, assign, readwrite) IPCModelType modelType;
@property (nonatomic, assign, readwrite) CGPoint position;
@property (nonatomic, assign, readwrite) CGFloat scale;
@property (nonatomic, strong, readwrite) UIImage *frontialPhoto;//Taken a positive figure
@property (nonatomic, assign, readwrite) IPCPhotoType photoType;

@end
