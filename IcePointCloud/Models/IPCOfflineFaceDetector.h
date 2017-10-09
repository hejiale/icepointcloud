//
//  IPCFaceDetector.h
//  IcePointCloud
//
//  Created by mac on 2016/11/28.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCOfflineFaceDetector : NSObject

- (void)offLineDecectorFace:(UIImage *)faceImage Face:(void(^)(CGPoint position,CGSize sizer))face ErrorBlock:(void(^)(NSError*error))error;

@end
