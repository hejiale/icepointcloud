//
//  IPCCustomsizedGlassesCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/5/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCCustomsizedGlassesCellDelegate;
@interface IPCCustomsizedGlassesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBottom;

@property (copy,  nonatomic) IPCGlasses * glasses;
@property (assign, nonatomic) id<IPCCustomsizedGlassesCellDelegate>delegate;

@end

@protocol IPCCustomsizedGlassesCellDelegate <NSObject>

- (void)confirmSelectGlass:(IPCCustomsizedGlassesCell *)cell;

@end
