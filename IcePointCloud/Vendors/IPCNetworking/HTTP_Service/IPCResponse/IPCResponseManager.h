//
//  IPCResponse.h
//  IcePointCloud
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPCResponseManager : NSObject


/**
 Parse Response Data

 @param responseData
 @param complete
 @param failed 
 */
+ (void)parseResponseData:(id)responseData Complete:(void (^)(id responseValue))complete Failed:(void(^)(NSError * _Nonnull error))failed;

@end
