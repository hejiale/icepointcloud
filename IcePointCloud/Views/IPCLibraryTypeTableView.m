//
//  IPCLibraryTypeTableView.m
//  IcePointCloud
//
//  Created by mac on 2016/11/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCLibraryTypeTableView.h"
#import "LibraryTypeTableViewCell.h"


static NSString * const typeIdentifier = @"LibraryTypeTableViewCellIdentifier";

@interface IPCLibraryTypeTableView()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IPCPhotoDatas *datas;
@property (strong, nonatomic) NSMutableArray<IPCPhotoListModel *>  * photoList ;

@end

@implementation IPCLibraryTypeTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc]init];
        self.separatorColor = [UIColor whiteColor];
        [self setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.2]];
        
        self.datas = [[IPCPhotoDatas alloc]init];
        self.photoList = [self.datas GetPhotoListDatas];
  
        [self reloadData];
    }
    return self;
}

-  (NSMutableArray<IPCPhotoListModel *> *)photoList{
    if (!_photoList) {
        _photoList = [[NSMutableArray alloc]init];
    }
    return _photoList;
}


- (void)show{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect rect = self.frame;
        rect.origin.y -= self.jk_height;
        self.frame = rect;
    }];
}


- (void)dismiss{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect rect = self.frame;
        rect.origin.y += self.jk_height;
        self.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.photoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryTypeTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:typeIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"LibraryTypeTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCPhotoListModel * photoList = self.photoList[indexPath.row];
    IPCPhoto * photo = photoList.assetArray[0];
    
    if ([photo isKindOfClass:[IPCPhoto class]]) {
        [[PHImageManager defaultManager] requestImageForAsset:photo.asset targetSize:CGSizeMake(photo.asset.pixelWidth, photo.asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info){
            cell.thumblImageView.image = result;
        }];
    }
    
    [cell.libraryTypeLabel setText:[NSString stringWithFormat:@"%@(%d)",photoList.title,photoList.count]];
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCPhotoListModel * photoList = self.photoList[indexPath.row];
    
    if ([self.libraryDelegate respondsToSelector:@selector(getAlbumPhotos:)]) {
        [self.libraryDelegate getAlbumPhotos:photoList];
    }
}


@end
