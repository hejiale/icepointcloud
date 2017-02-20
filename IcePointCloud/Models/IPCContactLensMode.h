//
//  ContactLensMode.h
//  IcePointCloud
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCContactLensMode : NSObject

@property (nonatomic, strong) NSMutableArray<NSDictionary *> * batchArray;

- (instancetype)initWithResponseObject:(NSArray<IPCContactLenSpec *> *)specificationArray;

@end


