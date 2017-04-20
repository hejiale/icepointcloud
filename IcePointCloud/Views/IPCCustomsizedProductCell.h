//
//  IPCCustomsizedProductCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomsizedProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *productContentView;
@property (copy, nonatomic) IPCCustomsizedProduct * customsizedProduct;

@end
