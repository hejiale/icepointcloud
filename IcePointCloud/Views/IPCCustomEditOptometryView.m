//
//  IPCCustomEditOptometryView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomEditOptometryView.h"
#import "IPCEditOptometryView.h"

typedef  void(^CompleteBlock)();
typedef  void(^DismissBlock)();

@interface IPCCustomEditOptometryView()

@property (strong, nonatomic) IPCEditOptometryView * optometryView;
@property (copy,  nonatomic) NSString * customerID;
@property (copy,  nonatomic) CompleteBlock  completeBlock;
@property (copy,  nonatomic) DismissBlock   dismissBlock;

@property (weak, nonatomic) IBOutlet UIView *opometryBgView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation IPCCustomEditOptometryView

- (instancetype)initWithFrame:(CGRect)frame CustomerID:(NSString *)customerID Complete:(void(^)())complete Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.completeBlock = complete;
        self.dismissBlock = dismiss;
        self.customerID = customerID;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomEditOptometryView" owner:self];
        [self addSubview:view];
        [self.opometryBgView addSubview:self.optometryView];
        
        [self.saveButton setBackgroundColor:COLOR_RGB_BLUE];
        self.opometryBgView.layer.cornerRadius = 10;
        self.saveButton.layer.cornerRadius = self.saveButton.jk_height/2;
    }
    return self;
}

#pragma mark //Request Method
- (void)saveNewOpometryRequest{
//    [IPCCustomerRequestManager storeUserOptometryInfoWithCustomID:self.customerID
//                                                         Distance:[self.optometryView subString:10]
//                                                          SphLeft:[self.optometryView subString:5]
//                                                         SphRight:[self.optometryView subString:0]
//                                                          CylLeft:[self.optometryView subString:6]
//                                                         CylRight:[self.optometryView subString:1]
//                                                         AxisLeft:[self.optometryView subString:7]
//                                                        AxisRight:[self.optometryView subString:2]
//                                                          AddLeft:[self.optometryView subString:8]
//                                                         AddRight:[self.optometryView subString:3]
//                                              CorrectedVisionLeft:[self.optometryView subString:9]
//                                             CorrectedVisionRight:[self.optometryView subString:4]
//                                                     SuccessBlock:^(id responseValue)
//     {
//         if (self.completeBlock) {
//             self.completeBlock();
//         }
//         [IPCUIKit showSuccess:@"新建验光单成功!"];
//     } FailureBlock:^(NSError *error) {
//         [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
//     }];
}

#pragma mark //Set UI
- (IPCEditOptometryView *)optometryView{
    if (!_optometryView) {
        _optometryView =  [[IPCEditOptometryView alloc]initWithFrame:CGRectMake(35, 45, self.opometryBgView.jk_width-70,125) LensViewHeight:30 ItemWidth:(self.opometryBgView.jk_width - 20*4 - 70 - 58)/5 OrignSpace:15  Spaceing:20 OptometryInfo:nil IsCanEdit:YES];
    }
    return _optometryView;
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
