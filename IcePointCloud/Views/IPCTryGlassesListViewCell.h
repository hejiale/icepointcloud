//
//  IPCTryGlassesCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCTryGlassesCellDelegate;

@interface IPCTryGlassesListViewCell : UITableViewCell

@property (nonatomic, copy) IPCGlasses *glasses;
@property (nonatomic, assign) id<IPCTryGlassesCellDelegate>delegate;

@end

@protocol IPCTryGlassesCellDelegate <NSObject>

- (void)chooseParameter:(IPCTryGlassesListViewCell *)cell;
- (void)editBatchParameter:(IPCTryGlassesListViewCell *)cell;
- (void)reloadProductList;
- (void)tryGlasses:(IPCTryGlassesListViewCell *)cell;

@end
