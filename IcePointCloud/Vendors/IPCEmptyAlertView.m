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
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (copy, nonatomic) void(^CompleteBlock)();
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationWidth;

@end

@implementation IPCEmptyAlertView

- (instancetype)initWithFrame:(CGRect)frame
                   AlertImage:(NSString *)imageName
                   AlertTitle:(NSString *)title
               OperationTitle:(NSString *)operationTitle
                     Complete:(void(^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
        UIView *emptyAlertView = [UIView jk_loadInstanceFromNibWithName:@"IPCEmptyAlertView" owner:self];
        [emptyAlertView setFrame:self.bounds];
        [self addSubview:emptyAlertView];
        
        [self.alertImageView setImage:[UIImage imageNamed:imageName]];
        [self.alertLabel setText:title];
        
        if (operationTitle) {
            [self.operationButton setHidden:NO];
            [self.operationButton setTitle:operationTitle forState:UIControlStateNormal];
            CGFloat width = [operationTitle jk_widthWithFont:self.operationButton.titleLabel.font constrainedToHeight:self.operationButton.jk_height];
            self.operationWidth.constant = width + 40;
        }
    }
    return self;
}


- (IBAction)operationAction:(id)sender {
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
}

@end
