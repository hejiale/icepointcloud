//
//  IPCManagerOptometryViewModel.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCManagerOptometryViewModel : NSObject

@property (nonatomic, copy) NSString * customerId;
@property (nonatomic, strong) NSMutableArray<IPCOptometryMode *> * optometryList;

- (void)queryCustomerOptometryList:(void(^)())completeBlock;
- (void)setCurrentOptometry:(NSString *)optometryID Complete:(void(^)())completeBlock;

@end
