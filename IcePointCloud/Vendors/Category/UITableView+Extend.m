//
//  UITableView+Extend.m
//  IcePointCloud
//
//  Created by gerry on 2018/6/21.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "UITableView+Extend.h"

@implementation UITableView (Extend)

- (void)scrollViewToBottom:(BOOL)animated
{
    NSInteger s = [self numberOfSections];
    if (s<1) return;
    NSInteger r = [self numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [self scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
}

@end
