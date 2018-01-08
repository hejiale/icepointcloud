//
//  IPCScanCodeViewController.h
//  IcePointCloud
//
//  Created by gerry on 2018/1/8.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMScanView.h"

@interface IPCScanCodeViewController : UIViewController

- (instancetype)initWithFinish:(void (^)(NSString *result, NSError *error))finish;

@end
