//
//  IPCGlassesImage.h
//  IcePointCloud
//
//  Created by mac on 9/12/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCGlassesImage : NSObject

@property (nonatomic) IPCGlassesImageType type;

@property (nonatomic, copy, readwrite)   NSString *imageURL;
@property (nonatomic, assign, readonly) CGFloat    width;
@property (nonatomic, assign, readonly) CGFloat    height;


@end
