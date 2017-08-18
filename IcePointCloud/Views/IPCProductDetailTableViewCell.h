//
//  ProductInfoDetailTableViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCProductDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *leftContentView;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseTitleLabel;

@property (nonatomic, copy) IPCGlasses *glasses;

@end
