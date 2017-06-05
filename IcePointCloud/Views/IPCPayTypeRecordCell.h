//
//  IPCPayTypeRecordCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayTypeRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;

@end
