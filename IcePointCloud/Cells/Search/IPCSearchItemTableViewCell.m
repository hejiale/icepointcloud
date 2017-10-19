//
//  SearchItemCell.m
//  IcePointCloud
//
//  Created by mac on 8/14/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCSearchItemTableViewCell.h"

@interface IPCSearchItemTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *textLbl;

@end

@implementation IPCSearchItemTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)deleteSearchValueAction:(id)sender {
  
}

@end
