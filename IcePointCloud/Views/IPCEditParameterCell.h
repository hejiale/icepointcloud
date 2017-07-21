//
//  EditParameterCell.h
//  IcePointCloud
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IPCEditParameterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *cartNumLabel;

- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload;
- (void)reloadAddButtonStatus:(BOOL)hasStock;

@end



