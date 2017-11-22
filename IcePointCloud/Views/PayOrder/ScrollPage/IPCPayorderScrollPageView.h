//
//  IPCPayorderScrollPageView.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/16.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCPayorderScrollPageViewDelegate;

@interface IPCPayorderScrollPageView : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberPages;
@property (nonatomic, copy) NSArray<NSString *> * pageTitles;
@property (nonatomic, copy) NSArray<NSString *> * onPageImages;
@property (nonatomic, copy) NSArray<NSString *> * pageImages;
@property (nonatomic, assign) id<IPCPayorderScrollPageViewDelegate>delegate;

@end

@protocol IPCPayorderScrollPageViewDelegate <NSObject>

- (void)changePageIndex:(NSInteger)index;

@end





