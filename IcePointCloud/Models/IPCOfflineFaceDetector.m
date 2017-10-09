//
//  IPCFaceDetector.m
//  IcePointCloud
//
//  Created by mac on 2016/11/28.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOfflineFaceDetector.h"

typedef void(^FaceBlock)(CGPoint position,CGSize sizer);
typedef void(^ErrorBlock)(NSError*error);

@interface IPCOfflineFaceDetector()

@property (nonatomic,retain) IFlyFaceDetector * faceDetector;
@property (nonatomic, copy) FaceBlock  faceBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@end

@implementation IPCOfflineFaceDetector

- (void)offLineDecectorFace:(UIImage *)faceImage Face:(void(^)(CGPoint position,CGSize sizer))face ErrorBlock:(void(^)(NSError*error))error
{
    self.faceBlock = face;
    self.errorBlock = error;
    
    self.faceDetector = [IFlyFaceDetector sharedInstance];
    [self offlineDecetorFace:faceImage];
}


#pragma mark //Off-line monitoring of face recognition
- (void)offlineDecetorFace:(UIImage *)image
{
    NSString* strResult=[self.faceDetector detectARGB:image];
    if (strResult.length) {
        [self praseDetectResult:strResult];
    }else{
        if (self.errorBlock) {
            NSError * error = [[NSError alloc]initWithDomain:@"未检测到人脸轮廓" code:0 userInfo:nil];
            self.errorBlock(error);
        }
    }
    
}

-(void)praseDetectResult:(NSString*)result{
    NSString *resultInfo = @"";
    
    @try {
        NSData* resultData=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic=[result jk_dictionaryValue];
        
        if(dic){
            NSNumber* ret=[dic objectForKey:@"ret"];
            NSArray* faceArray=[dic objectForKey:@"face"];

            if([faceArray count]==0){
                if (self.errorBlock) {
                    NSError * error = [[NSError alloc]initWithDomain:@"未检测到人脸轮廓" code:0 userInfo:nil];
                    self.errorBlock(error);
                    return;
                }
            }
            
            for(id faceInArr in faceArray){
                if(faceInArr && [faceInArr isKindOfClass:[NSDictionary class]]){
                    NSDictionary* position=[faceInArr objectForKey:@"position"];
                    if(position){
                        CGFloat bottom =[[position objectForKey:@"bottom"] floatValue];
                        CGFloat top=[[position objectForKey:@"top"] floatValue];
                        CGFloat left=[[position objectForKey:@"left"] floatValue];
                        CGFloat right=[[position objectForKey:@"right"] floatValue];
                        
                        CGFloat x = left;
                        CGFloat y = top;
                        CGFloat width = right- left;
                        CGFloat height = bottom- top;
                        
                        CGPoint center = CGPointMake(x+(width/2), y+(height/2));
                        CGSize size = CGSizeMake(width+120, 0);
                        
                        if (self.faceBlock) {
                            self.faceBlock(center,size);
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        if (self.errorBlock) {
            NSError * error = [[NSError alloc]initWithDomain:exception.name code:0 userInfo:nil];
            self.errorBlock(error);
        }
    }
    @finally {
    }
}

@end
