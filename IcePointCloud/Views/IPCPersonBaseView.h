//
//  PersonBaseView.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPersonBaseView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personTableView;
@property (weak, nonatomic) IBOutlet UIButton *logouOutButton;
@property (copy, nonatomic) void(^LogoutBlock)(void);
@property (copy, nonatomic) void(^CloseBlock)(void);
@property (copy, nonatomic) void(^LibraryBlock)(void);
@property (copy, nonatomic) void(^UpdateBlock)(void);
@property (copy, nonatomic) void(^QRCodeBlock)(void);
@property (copy, nonatomic) void(^HelpBlock)(void);

- (void)showWithClose:(void(^)())close
               Logout:(void(^)())logout
          ShowLibrary:(void(^)())libraryBlock
          UpdateBlock:(void(^)())update
          QRCodeBlock:(void(^)())qrcode
            HelpBlock:(void(^)())help;;

@end
