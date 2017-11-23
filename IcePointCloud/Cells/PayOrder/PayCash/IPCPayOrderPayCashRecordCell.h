//
//  IPCPayOrderPayCashRecordCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderPayCashRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (nonatomic, copy) IPCPayRecord * payRecord;


@end
