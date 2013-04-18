//
//  SHDReporterView.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDReporterView.h"
#import "SHDBugReport.h"
#import "SHDConstants.h"
#import "SHDTextViewCell.h"
#import "SHDTextFieldCell.h"
#import "SHDMultipleSelectionCell.h"
#import "SHDScreenshotsCell.h"

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
    titleCell.textField.placeholder = @"This bug is titled...";    
    offset += titleCell.frame.size.height;

    SHDTextViewCell *descriptionCell = [[SHDTextViewCell alloc] initWithFrame:CGRectMake(0, offset, width, 120)];
    [self addSubview:descriptionCell];
    descriptionCell.placeholder = @"I was doing this and then something happened...";
    descriptionCell.backgroundColor = kSHDBackgroundAlternateColor;
    offset += descriptionCell.frame.size.height;
    
    SHDMultipleSelectionCell *reproducabilityCell = [[SHDMultipleSelectionCell alloc] initWithFrame:CGRectMake(0, offset, width, 50)];
    [self addSubview:reproducabilityCell];
    reproducabilityCell.text = @"This happens";
    reproducabilityCell.options = @[@"every time", @"sometimes", @"infrequently"];
    offset += reproducabilityCell.frame.size.height;

    self.screenshotsCell = [[SHDScreenshotsCell alloc] initWithFrame:CGRectMake(0, offset, width, 100)];
    [self addSubview:self.screenshotsCell];
    self.screenshotsCell.backgroundColor = kSHDBackgroundAlternateColor;
    offset += self.screenshotsCell.frame.size.height;

}

@end
