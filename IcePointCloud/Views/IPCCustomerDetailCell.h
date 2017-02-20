//
//  UserDetailInfoCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDetailInfoCellDelegate;

@interface IPCCustomerDetailCell : UITableViewCell<IPCDataPickerViewDataSource,IPCDataPickerViewDelegate,IPCDatePickViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextFiled;
@property (weak, nonatomic) IBOutlet IQTextView *memoTextView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (assign, nonatomic) id<UserDetailInfoCellDelegate>delegate;
@property (copy, nonatomic) IPCDetailCustomer * currentCustomer;

- (void)clear;
- (void)setAllSubViewIsEnable;

@end

@protocol UserDetailInfoCellDelegate <NSObject>
@optional
- (void)reloadCustomer:(IPCDetailCustomer *)customer;

@end
