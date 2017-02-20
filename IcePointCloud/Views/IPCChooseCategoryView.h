//
//  ChooseCategoryView.h
//  IcePointCloud
//
//  Created by mac on 16/7/15.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCChooseCategoryView : UITableView<UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame CategoryList:(NSArray *)categoryList FilterType:(IPCTopFilterType)type Complete:(void(^)(IPCTopFilterType type))complete;

@end
