//
//  SHDTextFieldCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDTextFieldCell.h"
#import "SHDConstants.h"

@interface SHDTextFieldCell () <UITextFieldDelegate>

@end

@implementation SHDTextFieldCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectInset(self.bounds, 18, 16)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = kSHDTextNormalColor;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyNext;
        [self addSubview:_textField];
    }
    return self;
}

@end
