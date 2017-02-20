//
//  EditOptometryView.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCEditOptometryView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray<UITextField *> * allTextFields;
@property (nonatomic, copy) NSArray * allOptometryInfo;

- (instancetype)initWithFrame:(CGRect)frame
               LensViewHeight:(CGFloat)lensViewHeight
                    ItemWidth:(CGFloat)itemWidth
                   OrignSpace:(CGFloat)orignSpace
                     Spaceing:(CGFloat)spacing
                OptometryInfo:(NSArray *)optometryInfo
                    IsCanEdit:(BOOL)isCanEdit;

- (UITextField *)subTextField:(NSInteger)tag;

- (NSString *)subString:(NSInteger)tag;


@end
