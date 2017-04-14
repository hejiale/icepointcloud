//
//  IPCOptometryView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOptometryView : UIView

@property (nonatomic, strong) IPCOptometryMode * insertOptometry;

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update;

- (UITextField *)subTextField:(NSInteger)tag;

- (NSString *)subString:(NSInteger)tag;

@end
