//
//  IPCCustomsizedOtherView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedOtherView.h"

@interface IPCCustomsizedOtherView()

@property (nonatomic, copy) void(^InsertBlock)(NSString *, OtherType);
@property (nonatomic, assign) OtherType otherType;

@end

@implementation IPCCustomsizedOtherView

- (instancetype)initWithFrame:(CGRect)frame Insert:(void(^)(NSString *,OtherType))insert
{
    self = [super initWithFrame:frame];
    if (self){
        self.InsertBlock = insert;
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomsizedOtherView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.otherParameterTextField addBorder:3 Width:0.5];
    [self.otherDescription addBorder:3 Width:0.5];
    [self.otherDescription setLeftSpace:10];
    [self.otherParameterTextField setLeftSpace:10];
    [self.deleteButton.layer setCornerRadius:3];
}

- (IBAction)deleteAction:(id)sender {
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([textField isEqual:self.otherParameterTextField]) {
            self.otherType = OtherTypeParameter;
        }else{
            self.otherType = OtherTypeDescription;
        }
        if (self.InsertBlock) {
            self.InsertBlock(str, self.otherType);
        }
    }
}


@end
