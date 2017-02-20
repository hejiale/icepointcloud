//
//  HistoryOptometryCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCEditOptometryView.h"

@interface IPCHistoryOptometryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IPCEditOptometryView * optometryView;

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode;


@end

