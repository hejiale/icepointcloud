//
//  FJTagCollectionLayout.h
//  CollectionView
//
//  Created by jiale on 16/1/12.
//  Copyright © 2016年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IPCTagCollectionLayoutDelegate;

@interface IPCTagCollectionLayout : UICollectionViewLayout

@property (nonatomic, weak) id<IPCTagCollectionLayoutDelegate> delegate;

@property(nonatomic, assign) UIEdgeInsets sectionInset; //sectionInset
@property(nonatomic, assign) CGFloat lineSpacing;  //line space
@property(nonatomic, assign) CGFloat itemSpacing; //item space
@property(nonatomic, assign) CGFloat itemHeigh;  //item heigh

@end

@protocol IPCTagCollectionLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(IPCTagCollectionLayout*)collectionViewLayout widthAtIndexPath:(NSIndexPath *)indexPath;

@end
