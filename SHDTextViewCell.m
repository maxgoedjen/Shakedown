//
//  SHDTextViewCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDTextViewCell.h"

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
        _textView.contentInset = UIEdgeInsetsMake(10, 0, 7, 0);
        [self addSubview:_textView];
    }
    return self;
}

@end
