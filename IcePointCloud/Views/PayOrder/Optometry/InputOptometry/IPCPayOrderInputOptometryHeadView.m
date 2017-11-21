//
//  IPCPayOrderInputOptometryHeadView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderInputOptometryHeadView.h"
#import "IPCEmployeListView.h"

@interface IPCPayOrderInputOptometryHeadView()

@property (weak, nonatomic) IBOutlet UITextField *employeeTextField;
@property (weak, nonatomic) IBOutlet UIButton *farButton;
@property (weak, nonatomic) IBOutlet UIButton *nearButton;

@end

@implementation IPCPayOrderInputOptometryHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderInputOptometryHeadView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.employeeTextField addBottomLine];
        [self.employeeTextField setRightButton:self Action:@selector(selectEmployeeAction) OnView:view];
    }
    return self;
}

#pragma mark //Clicked Events
- (IBAction)farUseAction:(id)sender {
    [self.farButton setSelected:YES];
    [self.nearButton setSelected:NO];
    [IPCPayOrderManager sharedManager].insertOptometry.purpose = @"FAR";
}


- (IBAction)nearUseAction:(id)sender {
    [self.farButton setSelected:NO];
    [self.nearButton setSelected:YES];
    [IPCPayOrderManager sharedManager].insertOptometry.purpose = @"NEAR";
}

- (void)updateInsertOptometryInfo
{
    [self.employeeTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.employeeName];
    
    if ([[IPCPayOrderManager sharedManager].insertOptometry.purpose isEqualToString:@"FAR"]) {
        [self.farButton setSelected:YES];
    }else if([[IPCPayOrderManager sharedManager].insertOptometry.purpose isEqualToString:@"NEAR"]){
        [self.nearButton setSelected:YES];
    }else{
        [self.farButton setSelected:NO];
        [self.nearButton setSelected:NO];
    }
}

- (void)selectEmployeeAction
{
    IPCEmployeListView * listView = [[IPCEmployeListView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds
                                                                DismissBlock:^(IPCEmployee *employee)
                                     {
                                         [IPCPayOrderManager sharedManager].insertOptometry.employeeId = employee.jobID;
                                         [IPCPayOrderManager sharedManager].insertOptometry.employeeName = employee.name;
                                         [self.employeeTextField setText:employee.name];
                                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:listView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:listView];
}

@end
