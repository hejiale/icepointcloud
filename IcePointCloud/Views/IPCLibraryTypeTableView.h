//
//  IPCLibraryTypeTableView.h
//  IcePointCloud
//
//  Created by mac on 2016/11/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPhoto.h"
#import "IPCPhotoDatas.h"
#import "IPCPhotoListModel.h"

@protocol IPCLibraryTypeTableViewDelegate;

@interface IPCLibraryTypeTableView : UITableView

@property (nonatomic, assign) id<IPCLibraryTypeTableViewDelegate>libraryDelegate;

- (void)show;
- (void)dismiss;

@end

@protocol IPCLibraryTypeTableViewDelegate <NSObject>

- (void)getAlbumPhotos:(IPCPhotoListModel *)photoMode;

@end
