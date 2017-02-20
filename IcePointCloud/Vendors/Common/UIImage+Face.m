//
//  UIImage+Face.m
//  IcePointCloud
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "UIImage+Face.h"

#define MAX_IMAGEPIX_WIDTH 800.0f          // max pix 400.0px
#define MAX_IMAGEPIX_HEIGHT 600.0f          // max pix 400.0px
#define MAX_IMAGEDATA_LEN 150000.0f   // max data length 150K

@implementation UIImage (Face)


- (NSData *)compressedData{
    CGFloat quality = [self compressionQuality];
    return [self compressedData:quality];
}


- (NSData *)compressedData:(CGFloat)compressionQuality {
    assert(compressionQuality <= 1.0 && compressionQuality >= 0);
    return UIImageJPEGRepresentation(self, compressionQuality);
}

- (CGFloat)compressionQuality {
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger dataLength = [data length];
    
    if(dataLength > MAX_IMAGEDATA_LEN) {
        return 1.0 - MAX_IMAGEDATA_LEN / dataLength;
    } else {
        return 1.0;
    }
}

@end
