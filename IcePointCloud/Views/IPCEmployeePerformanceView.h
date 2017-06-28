//
//  IPCEmployeeePerformanceView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCProgressView.h"

@interface IPCEmployeePerformanceView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *amountButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIView *progressBarView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IPCProgressView * progress;
@property (copy, nonatomic) IPCEmployeeResult * employeeResult;

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update;

@end
