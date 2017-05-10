//
//  IPCCustomsizedLensView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedLensView.h"
#import "IPCCustomsizedOtherView.h"

@interface IPCCustomsizedLensView()<IPCParameterTableViewDataSource,IPCParameterTableViewDelegate,UITextFieldDelegate>

@property (copy, nonatomic) void(^UpdateBlock)();

@end

@implementation IPCCustomsizedLensView

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.UpdateBlock = update;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomsizedLensView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //定制镜片商品
    [self.addLayerTextField setLeftSpace:10];
    [self.dyeingTextField setLeftSpace:10];
    [self.addTextField setLeftSpace:10];
    [self.channalTextField setLeftSpace:10];
    [self.remarkTextView addBorder:3 Width:0.5];
    [self.sphTextField setRightButton:self Action:@selector(onGetSphAction) OnView:self];
    [self.cylTextField setRightButton:self Action:@selector(onGetCylAction) OnView:self];
    [self.sphTextField setLeftText:@"球镜/SPH"];
    [self.cylTextField setLeftText:@"柱镜/CYL"];
    [self.axisTextField setLeftText:@" 轴位/AXIS"];
    if (self.isRight) {
        [self.distanceTextField setLeftText:@"右眼瞳距/PD(R)"];
    }else{
        [self.distanceTextField setLeftText:@"左眼瞳距/PD(L)"];
    }
    
    
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

- (IBAction)reduceAction:(id)sender {
    
}

- (IBAction)addAction:(id)sender {
    
}

- (void)onGetSphAction{
    [self showParameterTabelView:self.sphTextField];
}


- (void)onGetCylAction{
    [self showParameterTabelView:self.cylTextField];
}

- (void)showParameterTabelView:(UITextField *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCParameterTableViewController * pickerVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate = self;
    [pickerVC showWithPosition:CGPointMake(sender.jk_width/2, sender.jk_height) Size:CGSizeMake(sender.jk_width, 150) Owner:sender Direction:UIPopoverArrowDirectionUp];
}

#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    return [IPCBatchDegreeObject batchSphs];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}



@end
