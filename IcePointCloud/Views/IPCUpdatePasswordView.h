//
//  UpdatePwView.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCUpdatePasswordView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *updateTableView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (copy, nonatomic) void(^CloseBlock)(void);

- (void)showWithClose:(void(^)())closeBlock;

@end
