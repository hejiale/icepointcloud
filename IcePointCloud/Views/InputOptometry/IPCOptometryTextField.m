//
//  IPCOptometryTextField.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/19.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCOptometryTextField.h"

@interface IPCOptometryTextField()

@property (nonatomic, strong) UILabel * placeHolderLabel;
@property (nonatomic, strong) UILabel * textLabel;


@end

@implementation IPCOptometryTextField

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.placeHolderLabel];
    [self addSubview:self.textLabel];
}

#pragma mark //Set UI
- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc]initWithFrame:self.bounds];
        [_placeHolderLabel setTextColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.7]];
        [_placeHolderLabel setFont:[UIFont systemFontOfSize:14]];
        [_placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _placeHolderLabel;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.bounds.size.width-5, self.bounds.size.height)];
        [_textLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _textLabel;
}

- (void)setPlaceHolderText:(NSString *)placeHolderText
{
    _placeHolderText = placeHolderText;
    
    if (_placeHolderText.length) {
        [self.placeHolderLabel setText:_placeHolderText];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    if (_text.length) {
        [self.placeHolderLabel setHidden:YES];
        [self.textLabel setHidden:NO];
        [self.textLabel setText:_text];
    }else{
        [self.placeHolderLabel setHidden:NO];
        [self.textLabel setHidden:YES];
        [self.textLabel setText:@""];
    }
}

@end
