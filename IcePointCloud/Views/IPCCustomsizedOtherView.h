//
//  IPCCustomsizedOtherView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OtherType){
    OtherTypeParameter = 0,
    OtherTypeDescription = 1
};

@interface IPCCustomsizedOtherView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *otherParameterTextField;
@property (weak, nonatomic) IBOutlet UITextField *otherDescription;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (instancetype)initWithFrame:(CGRect)frame Insert:(void(^)(NSString *, OtherType))insert;

@end
