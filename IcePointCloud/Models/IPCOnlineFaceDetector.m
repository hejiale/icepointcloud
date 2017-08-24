//
//  FaceRecognition.m
//  IcePointCloud
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOnlineFaceDetector.h"

@interface IPCOnlineFaceDetector()<IFlyFaceRequestDelegate>

@property (nonatomic,retain) NSString *resultStings;

@property (nonatomic,retain) IFlyFaceRequest * iFlySpFaceRequest;
@property (nonatomic, copy) void(^FaceFrameBlock)(CGPoint,CGSize);
@property (nonatomic, copy) void(^FaceErrorBlock)(IFlySpeechError *error);

@end

@implementation IPCOnlineFaceDetector


- (instancetype)initWithFaceFrame:(void(^)(CGPoint position,CGSize sizer))face Error:(void(^)(IFlySpeechError *error))error
{
    self = [super init];
    if (self) {
        self.FaceFrameBlock = face;
        self.FaceErrorBlock   = error;
        
        self.resultStings = [[NSString alloc]init];
        self.iFlySpFaceRequest=[IFlyFaceRequest sharedInstance];
        [self.iFlySpFaceRequest setDelegate:self];
        
        [IPCCommonUI show];
    }
    return self;
}


- (void)postFaceRequest:(UIImage *)faceImage
{
    [self.iFlySpFaceRequest setParameter:IPCIflyFaceDetectorKey forKey:[IFlySpeechConstant APPID]];
    [self.iFlySpFaceRequest setParameter:[IFlySpeechConstant FACE_ALIGN] forKey:[IFlySpeechConstant FACE_SST]];
    NSData* imgData=[faceImage compressedData];
    [self.iFlySpFaceRequest sendRequest:imgData];
}

#pragma mark - IFlyFaceRequestDelegate
/**
 * Data correction, may call many times, may also not call at a time
 * @param buffer        Binary data returned by the server
 */
- (void) onData:(NSData* )data{
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (result.length) {
        self.resultStings=[self.resultStings stringByAppendingString:result];
    }
}

/**
 * End of callback, there is no mistake，error is null
 * @param error         Wrong type
 */
- (void) onCompleted:(IFlySpeechError*)error
{
    @try {
        __block CGFloat leftEyeX = 0.0,rightEyeX = 0.0,leftEyeY = 0.0,rightEyeY = 0.0;
        
        
        if([error errorCode] != 0){
            if (self.FaceErrorBlock)
                self.FaceErrorBlock(error);
            return;
        }
        
        if (self.resultStings.length && self.resultStings){
            NSDictionary * dic = [self.resultStings objectFromJSONString];
            NSArray* resultArray=[dic objectForKey:@"result"];
            
            if ([resultArray count] > 0) {
                for (id anRst in resultArray) {
                    if(anRst && [anRst isKindOfClass:[NSDictionary class]]){
                        NSDictionary* landMarkDic=[anRst objectForKey:@"landmark"];
                        NSEnumerator* keys=[landMarkDic keyEnumerator];
                        
                        for(id key in keys){
                            id attr=[landMarkDic objectForKey:key];
                            
                            if(attr && [attr isKindOfClass:[NSDictionary class]]){
                                id attr=[landMarkDic objectForKey:key];
                                
                                if ([key isEqualToString:@"left_eyebrow_left_corner"]) {
                                    leftEyeX = [attr[@"x"]floatValue];
                                    leftEyeY = [attr[@"y"]floatValue];
                                }else if ([key isEqualToString:@"right_eyebrow_right_corner"]){
                                    rightEyeX=[[attr objectForKey:@"x"] floatValue];
                                    rightEyeY=[[attr objectForKey:@"y"] floatValue];
                                }
                            }
                        }
                    }
                }
            }else{
                if (self.FaceErrorBlock)
                    self.FaceErrorBlock(nil);
                return;
            }
        }
        
        CGPoint cameraEyePoint = CGPointMake(leftEyeX-30, MIN(leftEyeY, rightEyeY)-20);
        CGSize  cameraEyeSize   = CGSizeMake(rightEyeX - leftEyeX + 70, 0);
        
        if (self.FaceFrameBlock)
            self.FaceFrameBlock(cameraEyePoint,cameraEyeSize);
        
        self.resultStings = [[NSString alloc]init];
        [IPCCommonUI hiden];
    } @catch (NSException *exception) {
        
    }
}

@end
