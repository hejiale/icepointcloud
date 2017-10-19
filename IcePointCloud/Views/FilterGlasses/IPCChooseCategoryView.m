//
//  ChooseCategoryView.m
//  IcePointCloud
//
//  Created by mac on 16/7/15.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCChooseCategoryView.h"
#import "IPCChooseCategoryCell.h"

static NSString * identifier = @"CategoryCellIdentifier";

@interface IPCChooseCategoryView()

@property (nonatomic, copy) NSArray * categoryList;
@property (nonatomic, assign) IPCTopFilterType currentType;
@property (nonatomic, copy) void(^CompleteBlock)(IPCTopFilterType);

@end

@implementation IPCChooseCategoryView

- (instancetype)initWithFrame:(CGRect)frame CategoryList:(NSArray *)categoryList FilterType:(IPCTopFilterType)type Complete:(void(^)(IPCTopFilterType type))complete{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        
        _categoryList = categoryList;
        _currentType = type;
        self.CompleteBlock = complete;
        
        self.isHiden = YES;
        [self setDataSource:self];
        [self setDelegate:self];
        [self reloadData];
    }
    return self;
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCChooseCategoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCChooseCategoryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }

    [cell.categoryNameLabel setText:self.categoryList[indexPath.row]];
    
    if (self.currentType == indexPath.row) {
        [cell.chooseImageView setImage:[UIImage imageNamed:@"icon_sure"]];
    }else{
        [cell.chooseImageView setImage:nil];
    }
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    
    if (self.CompleteBlock) {
        self.CompleteBlock(indexPath.row);
    }
}



@end
