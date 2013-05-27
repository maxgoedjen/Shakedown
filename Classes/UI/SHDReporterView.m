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
#import "SHDDescriptiveInfoCell.h"
#import "SHDListCell.h"

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
    BOOL tall = [[UIScreen mainScreen] bounds].size.height == 568;
    CGFloat offset = 0;
        
    self.titleCell = [[SHDTextFieldCell alloc] initWithFrame:CGRectMake(0, offset, width, 50)];
    [self addSubview:self.titleCell];
    offset += self.titleCell.frame.size.height;
    
    self.descriptionCell = [[SHDTextViewCell alloc] initWithFrame:CGRectMake(0, offset, width, (tall ? 120 : 70))];
    [self addSubview:self.descriptionCell];
    self.descriptionCell.backgroundColor = kSHDBackgroundAlternateColor;
    offset += self.descriptionCell.frame.size.height;
    
    self.reproducabilityCell = [[SHDMultipleSelectionCell alloc] initWithFrame:CGRectMake(0, offset, width, 50)];
    [self addSubview:self.reproducabilityCell];
    offset += self.reproducabilityCell.frame.size.height;

    self.stepsCell = [[SHDListCell alloc] initWithFrame:CGRectMake(0, offset, width, 50)];
    [self addSubview:self.stepsCell];
    self.stepsCell.backgroundColor = kSHDBackgroundAlternateColor;
    offset += self.stepsCell.frame.size.height;

    self.screenshotsCell = [[SHDScreenshotsCell alloc] initWithFrame:CGRectMake(0, offset, width, 100)];
    [self addSubview:self.screenshotsCell];
    offset += self.screenshotsCell.frame.size.height;
    
    self.deviceInfoCell = [[SHDDescriptiveInfoCell alloc] initWithFrame:CGRectMake(0, offset, width, self.frame.size.height - offset)];
    self.deviceInfoCell.backgroundColor = kSHDBackgroundAlternateColor;
    [self addSubview:self.deviceInfoCell];

}

@end
