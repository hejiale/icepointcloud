//
//  OrderProductTableViewCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderDetailProductCell : UITableViewCell

@property (nonatomic, copy) IPCGlasses * glasses;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic)  UILabel *productNameLabel;
@property (strong, nonatomic) UILabel * suggestPriceLabel;
@property (strong, nonatomic) UILabel * productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactDegreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *batchNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *degreeWidthConstraint;
@property (strong, nonatomic) UIImageView * pointImageView;


@end
