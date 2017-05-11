//
//  IPCCustomsizedContactLensView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedContactLensView.h"

@interface IPCCustomsizedContactLensView()<IPCParameterTableViewDataSource,IPCParameterTableViewDelegate>

@property (copy, nonatomic) void(^UpdateBlock)();

@end

@implementation IPCCustomsizedContactLensView

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update{
    self = [super initWithFrame:frame];
    if (self) {
        self.UpdateBlock = update;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomsizedContactLensView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.priceTextField addBorder:3 Width:0.5];
    [self.contactSphTextField setRightButton:self Action:@selector(onGetSphAction) OnView:self];
    [self.contactCylTextField setRightButton:self Action:@selector(onGetCylAction) OnView:self];
    [self.contactSphTextField setLeftText:@"球镜/SPH"];
    [self.contactCylTextField setLeftText:@"柱镜/CYL"];
    [self.contactAxisTextField setLeftText:@" 轴位/AXIS"];
    
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBorder:3 Width:0.5];
        }
    }];
    [self reloadUI];
}

- (void)reloadUI
{
    [self.otherContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray * otherArray = nil;
    if (self.isRight) {
        otherArray = [IPCCustomsizedItem sharedItem].rightEye.otherArray;
    }
    else{
        otherArray = [IPCCustomsizedItem sharedItem].leftEye.otherArray;
    }
    
    if (otherArray.count)
    {
        [self.otherContentView setHidden:NO];
        
        if (otherArray.count > 1) {
            self.otherContentHeight.constant += (otherArray.count - 1) * 50;
            CGRect frame = self.mainView.frame;
            frame.size.height += (otherArray.count - 1)*50;
            self.mainView.frame = frame;
            
            frame = self.frame;
            frame.size.height += (otherArray.count - 1)*50;
            self.frame = frame;
        }
        
        __weak typeof(self) weakSelf = self;
        CGFloat width = self.otherContentView.jk_width;
        
        [otherArray enumerateObjectsUsingBlock:^(IPCCustomsizedOther * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            IPCCustomsizedOtherView * otherView = [[IPCCustomsizedOtherView alloc]initWithFrame:CGRectMake(0, idx *50, width, 30)];
            [strongSelf.otherContentView addSubview:otherView];
            
            [[otherView rac_signalForSelector:@selector(deleteAction:)] subscribeNext:^(id x) {
                if (strongSelf.isRight) {
                    [[IPCCustomsizedItem sharedItem].rightEye.otherArray removeObject:obj];
                }else{
                    [[IPCCustomsizedItem sharedItem].leftEye.otherArray removeObject:obj];
                }
                if (strongSelf.UpdateBlock) {
                    strongSelf.UpdateBlock();
                }
                
            }];
        }];
    }else{
        self.otherContentHeight.constant = 30;
    }
}


#pragma mark //Clicked Events
- (IBAction)addOtherAction:(id)sender {
}

- (IBAction)addAction:(id)sender {
}

- (IBAction)reduceAction:(id)sender {
}

@end
