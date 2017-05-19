//
//  GlassDetailsViewController.h
//  IcePointCloud
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCGlasses.h"

@interface IPCGlassDetailsViewController : IPCRootNavigationViewController

@property (nonatomic, copy) IPCGlasses *glasses;
@property (nonatomic, copy) IPCCustomsizedProduct * customsizedProduct;

@end


