//
//  CustomPickViewController.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCDataPickerViewDataSource;
@protocol IPCDataPickerViewDelegate;

@interface IPCDataPickViewController : UIViewController

@property (assign, nonatomic) id<IPCDataPickerViewDataSource>dataSource;
@property (assign, nonatomic) id<IPCDataPickerViewDelegate>delegate;

- (void)showWithPosition:(CGPoint)position Size:(CGSize)size Owner:(UIView *)owner;

@end

@protocol IPCDataPickerViewDataSource <NSObject>

- (NSInteger)numberOfComponentsInPickerView;
- (NSInteger)pickerViewNumberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerViewTitleForRow:(NSInteger)row;

@end

@protocol IPCDataPickerViewDelegate <NSObject>
@optional
- (void)didSelectContent:(NSString *)content titleForRow:(NSInteger)row;

@end