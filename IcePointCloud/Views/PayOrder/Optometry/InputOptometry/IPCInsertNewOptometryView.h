//
//  IPCInsertNewOptometryView.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPayOrderInputOptometryHeadView.h"
#import "IPCPayOrderInputOptometryView.h"
#import "IPCPayOrderInputOptometryMemoView.h"

@interface IPCInsertNewOptometryView : UIView

@property (strong, nonatomic) IPCPayOrderInputOptometryHeadView  * inputHeadView;
@property (strong, nonatomic) IPCPayOrderInputOptometryView          * inputInfoView;
@property (strong, nonatomic) IPCPayOrderInputOptometryMemoView * inputMemoView;
@property (weak, nonatomic) IBOutlet UIView *editContentView;

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)())complete;

@end
