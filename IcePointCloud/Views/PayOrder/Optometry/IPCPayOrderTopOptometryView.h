//
//  IPCPayOrderTopOptometryView.h
//  IcePointCloud
//
//  Created by gerry on 2018/3/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderTopOptometryView : UIView

- (instancetype)initWithFrame:(CGRect)frame UpdateBlock:(void(^)())update DefaultBlock:(void(^)(NSString *optometryId))defaultBlock;


@end