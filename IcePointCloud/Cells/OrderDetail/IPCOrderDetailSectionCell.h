//
//  IPCOrderDetailSectionCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderDetailSectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueWithConstraint;


@end
