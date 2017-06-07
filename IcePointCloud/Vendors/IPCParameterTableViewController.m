//
//  IPCParameterTableViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCParameterTableViewController.h"

static NSString * const parameterIdentifier = @"";

@interface IPCParameterTableViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation IPCParameterTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.dataTabelView setTableFooterView:[[UIView alloc]init]];
}

- (void)showWithPosition:(CGPoint)position Size:(CGSize)size Owner:(UIView *)owner Direction:(UIPopoverArrowDirection)direction
{
    self.popoverController = [[UIPopoverController alloc]initWithContentViewController:self];
    self.popoverController.popoverContentSize = size;
    [self.popoverController presentPopoverFromRect:CGRectMake(position.x, position.y, 1, 1) inView:owner permittedArrowDirections:direction animated:YES];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(parameterDataInTableView:)])
        return [self.dataSource parameterDataInTableView:self].count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:parameterIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:parameterIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightThin]];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.dataSource respondsToSelector:@selector(parameterDataInTableView:)]) {
        NSArray * parameterData = [self.dataSource parameterDataInTableView:self];
        [cell.textLabel setText:parameterData[indexPath.row]];
    }
    return cell;
}


#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource respondsToSelector:@selector(parameterDataInTableView:)]) {
        NSArray * parameterData = [self.dataSource parameterDataInTableView:self];
        if ([self.delegate respondsToSelector:@selector(didSelectParameter:InTableView:)]) {
            [self.delegate didSelectParameter:parameterData[indexPath.row] InTableView:self];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
