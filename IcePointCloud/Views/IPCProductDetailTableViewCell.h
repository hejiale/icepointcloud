//
//  ProductInfoDetailTableViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCProductDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, copy) IPCGlasses *glasses;
@property (nonatomic, copy) IPCCustomsizedProduct * customsizedProduct;

@end
