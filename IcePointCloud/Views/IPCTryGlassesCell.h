//
//  IPCTryGlassesCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCTryGlassesView.h"

@protocol IPCTryGlassesCellDelegate;

@interface IPCTryGlassesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *glassImageView;
@property (weak, nonatomic) IBOutlet UILabel *glassNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPriceLabel;

@property (nonatomic, copy) IPCGlasses *glasses;
@property (nonatomic, assign) id<IPCTryGlassesCellDelegate>delegate;

@end

@protocol IPCTryGlassesCellDelegate <NSObject>

- (void)chooseParameter:(IPCTryGlassesCell *)cell;
- (void)editBatchParameter:(IPCTryGlassesCell *)cell;
- (void)reloadProductList;
- (void)tryGlasses:(IPCTryGlassesCell *)cell;

@end
