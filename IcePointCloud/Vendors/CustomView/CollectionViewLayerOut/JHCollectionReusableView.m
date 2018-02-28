//  JHCollectionReusableView.h
//  IcePointCloud
//
//  Created by mac on 8/14/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "JHCollectionReusableView.h"
#import "JHCollectionViewLayoutAttributes.h"

@implementation JHCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[JHCollectionViewLayoutAttributes class]]) {
        JHCollectionViewLayoutAttributes *attr = (JHCollectionViewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attr.backgroundColor;
    }
}
@end
