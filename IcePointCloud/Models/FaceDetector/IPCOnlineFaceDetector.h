//
//  FaceRecognition.h
//  IcePointCloud
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPCOnlineFaceDetector : NSObject

- (instancetype)initWithFaceFrame:(void(^)(CGPoint position,CGSize sizer))face Error:(void(^)(IFlySpeechError *error))error;

- (void)postFaceRequest:(UIImage *)faceImage;

@end
