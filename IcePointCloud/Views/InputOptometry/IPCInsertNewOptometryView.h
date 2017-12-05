//
//  IPCInsertNewOptometryView.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCInsertNewOptometryView : UIView

- (instancetype)initWithFrame:(CGRect)frame CustomerId:(NSString *)customerId CompleteBlock:(void(^)(NSString * optometryId))complete;

@end
