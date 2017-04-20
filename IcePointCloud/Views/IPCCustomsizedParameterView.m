//
//  IPCCustomsizedParameterView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedParameterView.h"
#import "IPCCustomsizedOtherView.h"

@implementation IPCCustomsizedParameterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomsizedParameterView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBorder:3 Width:0.5];
        }
    }];
    
    [self.addLayerTextField setLeftSpace:10];
    [self.dyeingTextField setLeftSpace:10];
    [self.remarkTextField setLeftSpace:10];
    
    [self.sphTextField setRightButton:self Action:@selector(onGetSphAction) OnView:self.mainView];
    [self.cylTextField setRightButton:self Action:@selector(onGetSphAction) OnView:self.mainView];
    [self.sphTextField setLeftText:@"球镜/SPH"];
    [self.cylTextField setLeftText:@"柱镜/CYL"];
    [self.axisTextField setLeftText:@" 轴位/AXIS"];
}

#pragma mark //Clicked Events
- (IBAction)addOtherAction:(id)sender {
    
}

- (void)reloadOtherParameterView{
    if ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count > 0)
    {
        [self.otherContentView setHidden:NO];
        
        if ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count > 1) {
            self.otherContentHeight.constant += ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count - 1) * 30;
        }
        __weak typeof(self) weakSelf = self;
        
        [[IPCCustomsizedItem sharedItem].rightEye.otherArray enumerateObjectsUsingBlock:^(IPCCustomsizedOther * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            IPCCustomsizedOtherView * otherView = [[IPCCustomsizedOtherView alloc]initWithFrame:CGRectMake(0, idx *30, strongSelf.otherContentView.jk_width, 30)];
            [strongSelf.otherContentView addSubview:otherView];
        }];
    }else{
        [self.otherContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.otherContentHeight.constant = 30;
    }
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

@end
