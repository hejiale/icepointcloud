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
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parameterWidth;

- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload;

@end



