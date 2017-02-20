//
//  CustomPickViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCDataPickViewController.h"

@interface IPCDataPickViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *customPickView;
@property (strong, nonatomic) UIPopoverController * popoverController;

@end

@implementation IPCDataPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark //Click Events
- (void)showWithPosition:(CGPoint)position Size:(CGSize)size Owner:(UIView *)owner
{
    self.popoverController = [[UIPopoverController alloc]initWithContentViewController:self];
    self.popoverController.popoverContentSize = size;
    [self.popoverController presentPopoverFromRect:CGRectMake(position.x, position.y, 1, 1) inView:owner permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveAction:(id)sender {
    NSInteger row = [self.customPickView selectedRowInComponent:0];
    
    if ([self.delegate respondsToSelector:@selector(didSelectContent: titleForRow:)])
        [self.delegate didSelectContent:[self.dataSource pickerViewTitleForRow:row] titleForRow:row];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark //UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.dataSource numberOfComponentsInPickerView];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataSource pickerViewNumberOfRowsInComponent:component];
}

#pragma mark //UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.dataSource pickerViewTitleForRow:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel * pickLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.jk_width, 40)];
    [pickLabel setTextColor:[UIColor darkGrayColor]];
    [pickLabel setBackgroundColor:[UIColor clearColor]];
    [pickLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightThin]];
    [pickLabel setTextAlignment:NSTextAlignmentCenter];
    [pickLabel setText:[self.dataSource pickerViewTitleForRow:row]];
    return pickLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
