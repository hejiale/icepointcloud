//
//  UserBaseInfoCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserBaseInfoCellDelegate;

@interface IPCCustomerBaseInfoCell : UITableViewCell<IPCDataPickerViewDataSource,IPCDataPickerViewDelegate,IPCDatePickViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (strong, nonatomic)  UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *queryOptometryButton;
@property (weak, nonatomic) IBOutlet UIButton *insertOptometryButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextFiled;
@property (weak, nonatomic) IBOutlet IQTextView *addressTextView;
@property (weak, nonatomic) IBOutlet IQTextView *memoTextView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) id<UserBaseInfoCellDelegate>delegate;

- (void)setAllSubViewDisabled:(BOOL)isDisable;

@end

@protocol UserBaseInfoCellDelegate <NSObject>

@optional
- (void)searchCustomer;

- (void)insertNewCustomer;

- (void)changeCustomerGender;

- (void)inputText:(NSString *)text Tag:(NSInteger)tag InCell:(IPCCustomerBaseInfoCell *)cell;

- (void)updateSureButtonUI:(BOOL)enable;

@end
