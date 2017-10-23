//
//  IPCEditOptometryCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMangerOptometryView.h"

@protocol IPCManagerOptometryCellDelegate;

@interface IPCManagerOptometryCell : UITableViewCell

@property (strong, nonatomic) UIButton *defaultButton;
@property (nonatomic, strong) IPCMangerOptometryView * optometryView;
@property (nonatomic, copy) IPCOptometryMode * optometryMode;
@property (nonatomic, assign) id<IPCManagerOptometryCellDelegate>delegate;

@end

@protocol IPCManagerOptometryCellDelegate <NSObject>

- (void)setDefaultOptometry:(IPCManagerOptometryCell *)cell;

@end



