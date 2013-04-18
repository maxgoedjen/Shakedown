//
//  SHDReporterView.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHDTextFieldCell;
@class SHDTextViewCell;
@class SHDMultipleSelectionCell;
@class SHDScreenshotsCell;
@class SHDDescriptiveInfoCell;

@interface SHDReporterView : UIView

@property (nonatomic) SHDTextFieldCell *titleCell;
@property (nonatomic) SHDTextViewCell *descriptionCell;
@property (nonatomic) SHDMultipleSelectionCell *reproducabilityCell;
@property (nonatomic) SHDScreenshotsCell *screenshotsCell;
@property (nonatomic) SHDDescriptiveInfoCell *deviceInfoCell;

@end
