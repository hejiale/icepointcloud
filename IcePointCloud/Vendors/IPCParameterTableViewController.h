//
//  IPCParameterTableViewController.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCParameterTableViewDataSource;
@protocol IPCParameterTableViewDelegate;

@interface IPCParameterTableViewController : UIViewController

@property (strong, nonatomic) UIPopoverController *  popoverController;
@property (weak, nonatomic) IBOutlet UITableView *dataTabelView;
@property (assign, nonatomic) id<IPCParameterTableViewDataSource>dataSource;
@property (assign, nonatomic) id<IPCParameterTableViewDelegate>delegate;

- (void)showWithPosition:(CGPoint)position Size:(CGSize)size Owner:(UIView *)owner Direction:(UIPopoverArrowDirection)direction;

@end

@protocol IPCParameterTableViewDataSource <NSObject>

- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView;

@end

@protocol IPCParameterTableViewDelegate <NSObject>

- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView;

@end
