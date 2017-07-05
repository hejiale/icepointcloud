//
//  EmptyAlertView.m
//  IcePointCloud
//
//  Created by mac on 16/11/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEmptyAlertView.h"

@interface IPCEmptyAlertView()

@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@end

@implementation IPCEmptyAlertView

- (instancetype)initWithFrame:(CGRect)frame AlertImage:(NSString *)imageName AlertTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *emptyAlertView = [UIView jk_loadInstanceFromNibWithName:@"IPCEmptyAlertView" owner:self];
        [emptyAlertView setFrame:self.bounds];
        [self addSubview:emptyAlertView];
        
        [self.alertImageView setImage:[UIImage imageNamed:imageName]];
        [self.alertLabel setText:title];
    }
    return self;
}

@end
