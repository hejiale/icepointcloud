//
//  IPCCartItemViewCellMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPCCartItemViewCellModeDelegate;
@interface IPCCartItemViewCellMode : NSObject

@property (assign, nonatomic) id<IPCCartItemViewCellModeDelegate>delegate;

- (CGFloat)cartItemProductCellHeight:(IPCShoppingCartItem *)item;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath IsEditState:(BOOL)isEdit;

@end

@protocol IPCCartItemViewCellModeDelegate <NSObject>

- (void)reloadShoppingCartUI;

@end
