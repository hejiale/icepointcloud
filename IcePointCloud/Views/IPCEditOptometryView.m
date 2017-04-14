//
//  IPCCustomEditOptometryView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditOptometryView.h"
#import "IPCOptometryView.h"

typedef  void(^CompleteBlock)();
typedef  void(^DismissBlock)();

@interface IPCEditOptometryView()

@property (copy,  nonatomic) NSString * customerID;
@property (copy,  nonatomic) CompleteBlock  completeBlock;
@property (copy,  nonatomic) DismissBlock   dismissBlock;

@property (weak, nonatomic) IBOutlet UIView *opometryBgView;
@property (weak, nonatomic) IBOutlet UIView *optometryContentView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong,  nonatomic) IPCOptometryView * optometryView;


@end

@implementation IPCEditOptometryView

- (instancetype)initWithFrame:(CGRect)frame CustomerID:(NSString *)customerID Complete:(void(^)())complete Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.completeBlock = complete;
        self.dismissBlock = dismiss;
        self.customerID = customerID;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCEditOptometryView" owner:self];
        [self addSubview:view];
        
        self.opometryBgView.layer.cornerRadius = 5;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self createOptometryView];
}

#pragma mark //Set UI
- (void)createOptometryView
{
    CGFloat originY = (self.optometryContentView.jk_height - 145)/2;
    
    self.optometryView = [[IPCOptometryView alloc]initWithFrame:CGRectMake(0, originY, self.optometryContentView.jk_width, 145) Update:^{
        
    }];
    [self.optometryContentView addSubview:self.optometryView];
}

#pragma mark //Request Method
- (void)saveNewOpometryRequest{
    [IPCCustomerRequestManager storeUserOptometryInfoWithCustomID:self.customerID
                                                          SphLeft:self.optometryView.insertOptometry.sphLeft
                                                         SphRight:self.optometryView.insertOptometry.sphRight
                                                          CylLeft:self.optometryView.insertOptometry.cylLeft
                                                         CylRight:self.optometryView.insertOptometry.cylRight
                                                         AxisLeft:self.optometryView.insertOptometry.axisLeft
                                                        AxisRight:self.optometryView.insertOptometry.axisRight
                                                          AddLeft:self.optometryView.insertOptometry.addLeft
                                                         AddRight:self.optometryView.insertOptometry.addRight
                                              CorrectedVisionLeft:self.optometryView.insertOptometry.correctedVisionLeft
                                             CorrectedVisionRight:self.optometryView.insertOptometry.correctedVisionRight
                                                     DistanceLeft:self.optometryView.insertOptometry.distanceLeft
                                                    DistanceRight:self.optometryView.insertOptometry.distanceRight
                                                          Purpose:self.optometryView.insertOptometry.purpose
                                                       EmployeeId:self.optometryView.insertOptometry.employeeId
                                                     EmployeeName:self.optometryView.insertOptometry.employeeName
                                                     SuccessBlock:^(id responseValue) {
                                                         if (self.completeBlock) {
                                                             self.completeBlock();
                                                         }
                                                         [IPCCustomUI showSuccess:@"新建验光单成功!"];
                                                     } FailureBlock:^(NSError *error) {
                                                         [IPCCustomUI showError:error.domain];
                                                     }];
}



#pragma mark //Clicked Event
- (IBAction)completeAction:(id)sender {
    [self endEditing:YES];
    [self saveNewOpometryRequest];
}


- (IBAction)backAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
