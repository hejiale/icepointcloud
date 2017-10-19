//
//  IPCAddressView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCAddressView : UIView

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update;

@property (weak, nonatomic) IBOutlet UITextField *contacterTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;


@end
