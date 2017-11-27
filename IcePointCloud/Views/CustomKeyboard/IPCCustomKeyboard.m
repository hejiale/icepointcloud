//
//  IPCCustomKeyboard.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomKeyboard.h"

#define PreKeyboardType      101
#define NextKeyboardType    102
#define PointKeboardType     100
#define ClearKeyboardType   103
#define SureKeyboardType    104

NSString * const IPCCustomKeyboardBeginNotification  =  @"IPCCustomKeyboardBeginNotification";
NSString * const IPCCustomKeyboardChangeNotification = @"IPCCustomKeyboardChangeNotification";
NSString * const IPCCustomKeyboardDoneNotification = @"IPCCustomKeyboardDoneNotification";
NSString * const IPCCustomKeyboardClearNotification = @"IPCCustomKeyboardClearNotification";
NSString * const IPCCustomKeyboardPreNotification = @"IPCCustomKeyboardPreNotification";
NSString * const IPCCustomKeyboardNextNotification = @"IPCCustomKeyboardNextNotification";
NSString * const IPCCustomKeyboardValue   =  @"IPCCustomKeyboardValue";


@interface IPCCustomKeyboard()

@property (nonatomic, strong) NSMutableArray<UIButton *> * buttons;
@property (nonatomic, strong) NSMutableString * appendString;


@end

@implementation IPCCustomKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomKeyboard" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [view addLeftLine];
        [view addTopLine];
        
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button = (UIButton *)obj;
                [button addBottomLine];
                [button addRightLine];
                [self.buttons addObject:button];
            }
        }];
        
        self.appendString = [[NSMutableString alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing) name:IPCCustomKeyboardBeginNotification object:nil];
    }
    return self;
}

- (NSMutableArray<UIButton *> *)buttons{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc]init];
    }
    return _buttons;
}

- (void)beginEditing
{
    self.appendString = [[NSMutableString alloc]init];
}

- (IBAction)numberTapAction:(UIButton *)sender {
    if (sender.tag <= PointKeboardType)
    {
        NSInteger suffixLength = 0;
        NSString * suffixString = nil;
        
        if (self.appendString.length && [self.appendString containsString:@"."]) {
            NSRange rang = [self.appendString rangeOfString:@"."];
            suffixString = [self.appendString substringFromIndex:rang.location+1];
            suffixLength = suffixString.length;
            
            if (suffixLength == 2 ) {
                return;
            }
        }
        
        NSString * number = sender.titleLabel.text;
        if (sender.tag == PointKeboardType) {
            if ([self.appendString containsString:@"."] || [self.appendString isEqualToString:@"0"] || self.appendString.length == 0) {
                return;
            }
        }
        if (sender.tag == 0) {
            if ([self.appendString isEqualToString:@"0"] || self.appendString.length == 0 ) {
                return;
            }
        }
        [self.appendString appendString:number];
        [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardChangeNotification object:nil userInfo:@{IPCCustomKeyboardValue : self.appendString}];
    }else if (sender.tag == ClearKeyboardType){
        if (self.appendString.length) {
            [self.appendString deleteCharactersInRange:NSMakeRange(self.appendString.length-1, 1)];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardClearNotification object:nil userInfo:@{IPCCustomKeyboardValue : self.appendString}];
    }else if (sender.tag == PreKeyboardType){
        [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardPreNotification object:nil];
    }else if (sender.tag == NextKeyboardType){
        [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardNextNotification object:nil];
    }else if (sender.tag == SureKeyboardType){
        [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardDoneNotification object:nil userInfo:@{IPCCustomKeyboardValue : self.appendString}];
    }
}



@end
