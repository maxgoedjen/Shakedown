//
//  SHDTextViewCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDTextViewCell.h"
#import "SHDConstants.h"

@interface SHDTextViewCell () <UITextViewDelegate>

@end

@implementation SHDTextViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectInset(self.bounds, 10, 0);
        rect.size.width += 10;
        _textView = [[UITextView alloc] initWithFrame:rect];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        _textView.delegate = self;
        [self addSubview:_textView];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self _checkPlaceholder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self _checkPlaceholder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self _checkPlaceholder];
}

- (void)_checkPlaceholder {
    if ([self.textView hasText] == NO) {
        self.textView.textColor = kSHDTextFadedColor;
        self.textView.text = self.placeholder;
    } else if ([self.textView.text isEqualToString:self.placeholder]) {
        self.textView.textColor = kSHDTextNormalColor;
        self.textView.text = @"";
    }
}

@end
