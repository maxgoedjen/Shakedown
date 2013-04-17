//
//  SHDReporterView.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDReporterView.h"
#import "SHDConstants.h"
#import "SHDTextViewCell.h"
#import "SHDTextFieldCell.h"

@implementation SHDReporterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = kSHDBackgroundColor;
    CGFloat width = self.frame.size.width;
    CGFloat offset = 0;
    
    SHDTextFieldCell *titleCell = [[SHDTextFieldCell alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    [self addSubview:titleCell];
    titleCell.textField.placeholder = @"General description";
    
    offset += titleCell.frame.size.height;

    SHDTextViewCell *descriptionCell = [[SHDTextViewCell alloc] initWithFrame:CGRectMake(0, offset, width, 50)];
    [self addSubview:descriptionCell];
    descriptionCell.textView.text = @"General description";
    descriptionCell.backgroundColor = kSHDBackgroundAlternateColor;
}

@end
