//
//  IPCPayOrderViewCellMode.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayOrderViewCellHeight : NSObject

- (BOOL)tableViewCell:(NSInteger)section;
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath;

@end
