//
//  SHDShakedownReporter.h
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHDBugReport.h"

@protocol  SHDShakedownReporterDelegate <NSObject>

- (void)uploadedBugSuccessfullyWithLink:(NSURL *)url;
- (void)failedToUploadBug;

@end

@interface SHDShakedownReporter : NSObject

@property (nonatomic, weak) id <SHDShakedownReporterDelegate> delegate;
@property (nonatomic, readonly) UIViewController *topViewController;

- (void)reportBug:(SHDBugReport *)bugReport;

@end
