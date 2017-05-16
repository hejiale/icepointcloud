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
    [self.priceTextField addBorder:3 Width:0.5];
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
}

- (void)reloadUI
{
    if (self.isRight) {
        [self.sphTextField setText:[IPCCustomsizedItem sharedItem].rightEye.sph];
        [self.cylTextField setText:[IPCCustomsizedItem sharedItem].rightEye.cyl];
        [self.axisTextField setText:[IPCCustomsizedItem sharedItem].rightEye.axis];
        [self.distanceTextField setText:[IPCCustomsizedItem sharedItem].rightEye.distance];
        [self.addTextField setText:[IPCCustomsizedItem sharedItem].rightEye.add];
        [self.channalTextField setText:[IPCCustomsizedItem sharedItem].rightEye.channel];
        [self.dyeingTextField setText:[IPCCustomsizedItem sharedItem].rightEye.dyeing];
        [self.addLayerTextField setText:[IPCCustomsizedItem sharedItem].rightEye.membrane];
        if ([IPCCustomsizedItem sharedItem].rightEye.customsizedPrice <= 0) {
            [IPCCustomsizedItem sharedItem].rightEye.customsizedPrice = [IPCCustomsizedItem sharedItem].customsizedProduct.suggestPrice;
        }
        [self.priceTextField setText:[NSString stringWithFormat:@"%.2f",[IPCCustomsizedItem sharedItem].rightEye.customsizedPrice]];
        [self.countLabel setText:[NSString stringWithFormat:@"%d",[IPCCustomsizedItem sharedItem].rightEye.customsizedCount]];
    }else{
        [self.sphTextField setText:[IPCCustomsizedItem sharedItem].leftEye.sph];
        [self.cylTextField setText:[IPCCustomsizedItem sharedItem].leftEye.cyl];
        [self.axisTextField setText:[IPCCustomsizedItem sharedItem].leftEye.axis];
        [self.distanceTextField setText:[IPCCustomsizedItem sharedItem].leftEye.distance];
        [self.addTextField setText:[IPCCustomsizedItem sharedItem].leftEye.add];
        [self.channalTextField setText:[IPCCustomsizedItem sharedItem].leftEye.channel];
        [self.dyeingTextField setText:[IPCCustomsizedItem sharedItem].leftEye.dyeing];
        [self.addLayerTextField setText:[IPCCustomsizedItem sharedItem].leftEye.membrane];
        if ([IPCCustomsizedItem sharedItem].leftEye.customsizedPrice <= 0) {
            [IPCCustomsizedItem sharedItem].leftEye.customsizedPrice = [IPCCustomsizedItem sharedItem].customsizedProduct.suggestPrice;
        }
        [self.priceTextField setText:[NSString stringWithFormat:@"%.2f",[IPCCustomsizedItem sharedItem].leftEye.customsizedPrice]];
        [self.countLabel setText:[NSString stringWithFormat:@"%d",[IPCCustomsizedItem sharedItem].leftEye.customsizedCount]];
    }
    
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
            IPCCustomsizedOtherView * otherView = [[IPCCustomsizedOtherView alloc]initWithFrame:CGRectMake(0, idx *50, width, 30) Insert:^(NSString *str,OtherType otherType)
            {
                if (otherType == OtherTypeParameter) {
                    obj.otherParameter = str;
                }else{
                    obj.otherParameterRemark = str;
                }
                if (strongSelf.UpdateBlock) {
                    strongSelf.UpdateBlock();
                }
            }];
            [strongSelf.otherContentView addSubview:otherView];
            [otherView.otherParameterTextField setText:obj.otherParameter];
            [otherView.otherDescription setText:obj.otherParameterRemark];
            
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
    NSInteger count = [self.countLabel.text integerValue];
    count--;
    if (count <= 1)count = 1;
    
    if (self.isRight) {
        [IPCCustomsizedItem sharedItem].rightEye.customsizedCount = count;
    }else{
        [IPCCustomsizedItem sharedItem].leftEye.customsizedCount = count;
    }
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}

- (IBAction)addAction:(id)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count++;
    
    if (self.isRight) {
        [IPCCustomsizedItem sharedItem].rightEye.customsizedCount = count;
    }else{
        [IPCCustomsizedItem sharedItem].leftEye.customsizedCount = count;
    }
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
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
    pickerVC.view.tag = sender.tag;
    [pickerVC showWithPosition:CGPointMake(sender.jk_width/2, sender.jk_height) Size:CGSizeMake(sender.jk_width, 150) Owner:sender Direction:UIPopoverArrowDirectionUp];
}

#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    return [IPCBatchDegreeObject batchSphs];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    if (tableView.view.tag == 0) {
        if (self.isRight) {
            [IPCCustomsizedItem sharedItem].rightEye.sph = parameter;
        }else{
            [IPCCustomsizedItem sharedItem].leftEye.sph = parameter;
        }
    }else{
        if (self.isRight) {
            [IPCCustomsizedItem sharedItem].rightEye.cyl = parameter;
        }else{
            [IPCCustomsizedItem sharedItem].leftEye.cyl = parameter;
        }
    }
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    if (str.length) {
        if (textField.tag == 2) {
            if (self.isRight) {
                [IPCCustomsizedItem sharedItem].rightEye.axis = str;
            }else{
                [IPCCustomsizedItem sharedItem].leftEye.axis = str;
            }
        }else if (textField.tag == 3){
            if (self.isRight) {
                [IPCCustomsizedItem sharedItem].rightEye.distance = str;
            }else{
                [IPCCustomsizedItem sharedItem].leftEye.distance = str;
            }
        }else if (textField.tag == 4){
            if (self.isRight) {
                [IPCCustomsizedItem sharedItem].rightEye.add = str;
            }else{
                [IPCCustomsizedItem sharedItem].leftEye.add = str;
            }
        }else if (textField.tag == 5){
            if (self.isRight) {
                [IPCCustomsizedItem sharedItem].rightEye.channel = str;
            }else{
                [IPCCustomsizedItem sharedItem].leftEye.channel = str;
            }
        }else if (textField.tag == 6){
            if (self.isRight) {
                [IPCCustomsizedItem sharedItem].rightEye.membrane = str;
            }else{
                [IPCCustomsizedItem sharedItem].leftEye.membrane = str;
            }
        }else if (textField.tag == 7){
            if (self.isRight) {
                [IPCCustomsizedItem sharedItem].rightEye.dyeing = str;
            }else{
                [IPCCustomsizedItem sharedItem].leftEye.dyeing = str;
            }
        }else if (textField.tag == 8){
            if (self.isRight) {
                [IPCCustomsizedItem sharedItem].rightEye.customsizedPrice = [str doubleValue];
            }else{
                [IPCCustomsizedItem sharedItem].leftEye.customsizedPrice = [str doubleValue];
            }
        }
        if (self.UpdateBlock) {
            self.UpdateBlock();
        }
    }
}


@end
