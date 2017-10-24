//
//  IPCShowContentView.m
//  IcePointCloud
//
//  Created by gerry on 2017/10/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCShowContentView.h"
#import "IPCPersonBaseView.h"
#import "IPCUpdatePasswordView.h"
#import "IPCQRCodeView.h"
#import "IPCWarehouseView.h"

@interface IPCShowContentView()

@property (nonatomic, copy) NSArray<IPCPersonContentView *> * viewArray;
@property (nonatomic, assign) NSInteger  selectedIndex;
@property (nonatomic, copy) IPCPersonContentView * selectedView;

@end

@implementation IPCShowContentView

-(void)setViewArray:(NSArray<IPCPersonContentView *> *)viewArray
{
    _viewArray = [viewArray copy];
    
    if (_viewArray.count) {
        [_viewArray enumerateObjectsUsingBlock:^(IPCPersonContentView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:view];
        }];
    }
    
    self.selectedIndex = 0;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if (_selectedIndex != NSNotFound) {
        IPCPersonContentView * personView = (IPCPersonContentView *)[self.viewArray objectAtIndex:_selectedIndex];
        [personView show];
    }
}

- (IPCPersonContentView *)selectedView
{
    return (IPCPersonContentView *)[self.viewArray objectAtIndex:self.selectedIndex];
}

- (void)showContent
{
    IPCPersonBaseView * personBaseView = [[IPCPersonBaseView alloc]initWithFrame:CGRectMake(self.jk_width, 0, self.jk_width, self.jk_height)
                                                                          Logout:^{
                                                                              [[IPCAppManager sharedManager] logout];
                                                                          } UpdateBlock:^{
                                                                              [self setSelectedIndex:3];
                                                                          } QRCodeBlock:^{
                                                                              [self setSelectedIndex:2];
                                                                          } WareHouseBlock:^{
                                                                              [self setSelectedIndex:1];
                                                                          }];
    IPCWarehouseView * houseView = [[IPCWarehouseView alloc]initWithFrame:CGRectMake(self.jk_width, 0, self.jk_width, self.jk_height)];
    IPCQRCodeView * codeView       = [[IPCQRCodeView alloc]initWithFrame:CGRectMake(self.jk_width, 0, self.jk_width, self.jk_height)];
    IPCUpdatePasswordView * updateView = [[IPCUpdatePasswordView alloc]initWithFrame:CGRectMake(self.jk_width, 0, self.jk_width, self.jk_height)];
    
    [self setViewArray:@[personBaseView,houseView,codeView,updateView]];
}

- (void)dismissContent:(void (^)())completeBlock
{
    [self dismiss:^{
        if (completeBlock) {
            completeBlock();
        }
    }];
}

@end
