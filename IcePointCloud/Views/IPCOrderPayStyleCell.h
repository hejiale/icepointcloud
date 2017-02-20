//
//  IPCOrderPayStyleCell.h
//  IcePointCloud
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderPayStyleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;

- (void)updateUIWithUpdate:(void(^)())update;

@end
