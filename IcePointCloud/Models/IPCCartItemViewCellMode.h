//
//  IPCCartItemViewCellMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCartItemViewCellMode : NSObject

- (CGFloat)cartItemProductCellHeight:(IPCShoppingCartItem *)item;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  IsPay:(BOOL)isPay;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath IsPay:(BOOL)isPay;

@end
