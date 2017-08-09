//
//  IPCCollectionViewIndex.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCCollectionViewIndexDelegate;

@interface IPCCollectionViewIndex : UIView

/**
 *  是否有边框线
 */
@property(nonatomic, assign)BOOL isFrameLayer;
/**
 *  索引内容数组
 */
@property(nonatomic, strong)NSArray *titleIndexes;

@property(nonatomic, weak)id<IPCCollectionViewIndexDelegate>collectionDelegate;

@end

@protocol IPCCollectionViewIndexDelegate <NSObject>

/**
 *  触摸到索引时的反应
 *
 *  @param collectionViewIndex 触发的对象
 *  @param index               触发的索引的下标
 *  @param title               触发的索引的文字
 */
-(void)collectionViewIndex:(IPCCollectionViewIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title Point:(CGPoint)point;


/**
 *  触摸索引结束
 *
 *  @param tableViewIndex
 */
- (void)collectionViewIndexTouchesEnd:(IPCCollectionViewIndex *)collectionViewIndex;

@end
