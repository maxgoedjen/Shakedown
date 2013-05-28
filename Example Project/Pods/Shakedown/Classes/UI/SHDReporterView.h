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
@class SHDListCell;

@interface SHDReporterView : UIView

@property (nonatomic, strong) SHDTextFieldCell *titleCell;
@property (nonatomic, strong) SHDTextViewCell *descriptionCell;
@property (nonatomic, strong) SHDMultipleSelectionCell *reproducabilityCell;
@property (nonatomic, strong) SHDListCell *stepsCell;
@property (nonatomic, strong) SHDScreenshotsCell *screenshotsCell;
@property (nonatomic, strong) SHDDescriptiveInfoCell *deviceInfoCell;

@end
