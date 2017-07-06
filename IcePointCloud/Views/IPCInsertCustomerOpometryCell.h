//
//  UserBaseOpometryCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCOptometryView.h"

@protocol IPCInsertCustomerOpometryCellDelegate;

@interface IPCInsertCustomerOpometryCell : UITableViewCell

@property (nonatomic, strong) IPCOptometryView * optometryView;
@property (strong, nonatomic) UIButton *removeButton;
@property (assign, nonatomic) id<IPCInsertCustomerOpometryCellDelegate>delegate;
@property (copy, nonatomic) IPCOptometryMode * optometryMode;

@end

@protocol IPCInsertCustomerOpometryCellDelegate <NSObject>

- (void)updateOptometryMode:(IPCOptometryMode *)optometry Cell:(IPCInsertCustomerOpometryCell *)cell;

@end

