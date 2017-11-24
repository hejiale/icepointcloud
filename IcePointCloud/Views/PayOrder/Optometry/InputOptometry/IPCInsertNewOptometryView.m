//
//  IPCInsertNewOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCInsertNewOptometryView.h"

@interface IPCInsertNewOptometryView()

@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCInsertNewOptometryView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCInsertNewOptometryView" owner:self];
        
        [self addSubview:view];
        
        [self.editContentView addSubview:self.inputHeadView];
        [self.editContentView addSubview:self.inputInfoView];
        [self.editContentView addSubview:self.inputMemoView];
    }
    return self;
}

- (IPCPayOrderInputOptometryHeadView *)inputHeadView
{
    if (!_inputHeadView) {
        _inputHeadView = [[IPCPayOrderInputOptometryHeadView alloc]initWithFrame:CGRectMake(0, 10, self.editContentView.jk_width-20, 130)];
    }
    return _inputHeadView;
}

- (IPCPayOrderInputOptometryView *)inputInfoView
{
    if (!_inputInfoView) {
        _inputInfoView = [[IPCPayOrderInputOptometryView alloc]initWithFrame:CGRectMake(0, self.inputHeadView.jk_bottom, self.editContentView.jk_width-20, 375)];
    }
    return _inputInfoView;
}

- (IPCPayOrderInputOptometryMemoView *)inputMemoView
{
    if (!_inputMemoView) {
        _inputMemoView = [[IPCPayOrderInputOptometryMemoView alloc]initWithFrame:CGRectMake(0, _inputInfoView.jk_bottom, self.editContentView.jk_width-20, 60)];
    }
    return _inputMemoView;
}

#pragma mark //Request Methods
- (void)saveNewOptometry
{
    IPCOptometryMode * optometry = [IPCPayOrderManager sharedManager].insertOptometry;
    
    [IPCCustomerRequestManager storeUserOptometryInfoWithCustomID:[IPCPayOrderManager sharedManager].currentCustomerId
                                                          SphLeft:optometry.sphLeft
                                                         SphRight:optometry.sphRight
                                                          CylLeft:optometry.cylLeft
                                                         CylRight:optometry.cylRight
                                                         AxisLeft:optometry.axisLeft
                                                        AxisRight:optometry.axisRight
                                                          AddLeft:optometry.addLeft
                                                         AddRight:optometry.addRight
                                              CorrectedVisionLeft:optometry.correctedVisionLeft
                                             CorrectedVisionRight:optometry.correctedVisionRight
                                                     DistanceLeft:optometry.distanceLeft
                                                    DistanceRight:optometry.distanceRight
                                                          Purpose:optometry.purpose
                                                       EmployeeId:optometry.employeeId
                                                     EmployeeName:optometry.employeeName
                                                     SuccessBlock:^(id responseValue)
     {
         [IPCCurrentCustomer sharedManager].currentOpometry = [IPCOptometryMode mj_objectWithKeyValues:responseValue];
         [self removeFromSuperview];
         
         if (self.CompleteBlock) {
             self.CompleteBlock();
         }
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}


- (IBAction)saveAction:(id)sender {
    [self saveNewOptometry];
}


@end
