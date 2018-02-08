//
//  CustomDatePickViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCDatePickViewController.h"

@interface IPCDatePickViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) UIPopoverController * popoverController;

@end

@implementation IPCDatePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


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
    if ([self.delegate respondsToSelector:@selector(completeChooseDate:)]) {
        [self.delegate completeChooseDate:[IPCCommon formatDate:self.datePickerView.date IsTime:NO]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
    }
}


@end
