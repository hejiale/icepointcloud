//
//  IPCUpdateCustomerView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomerDetailViewDelegate.h"

@interface IPCUpdateCustomerView : UIView

@property (strong, nonatomic, readwrite) IPCDetailCustomer * currentDetailCustomer;
@property (assign, nonatomic, readwrite) id<IPCCustomerDetailViewDelegate>delegate;

@end
