//
//  IPCCustomsizedContactLensView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomsizedOtherView.h"

@interface IPCCustomsizedContactLensView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *contactSphTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactCylTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactAxisTextField;
@property (weak, nonatomic) IBOutlet UIView *contactOtherContentView;
@property (weak, nonatomic) IBOutlet UITextView *contactRemarkView;
@property (weak, nonatomic) IBOutlet UILabel *contactCountLabel;
@property (weak, nonatomic) IBOutlet UIView *otherContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherContentHeight;
@property (assign, nonatomic) BOOL isRight;

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update;

@end
