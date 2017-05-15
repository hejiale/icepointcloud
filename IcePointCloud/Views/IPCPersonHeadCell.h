//
//  PersonHeadCell.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPersonHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *loginHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *loginUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginPhoneLabel;

@end
