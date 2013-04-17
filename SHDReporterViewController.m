//
//  SHDReporterViewController.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDReporterViewController.h"
#import "SHDReporterView.h"
#import "SHDScreenshotsCell.h"
#import "SHDBugReport.h"

@interface SHDReporterViewController ()

@property (nonatomic) SHDBugReport *bugReport;

@end

@implementation SHDReporterViewController

- (id)initWithBugReport:(SHDBugReport *)bugReport {
    self = [super init];
    if (self) {
        _bugReport = bugReport;
    }
    return self;
}

- (void)loadView {
    self.view = [[SHDReporterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidAppear:(BOOL)animated {
    SHDReporterView *view = (SHDReporterView *)self.view;
    view.screenshotsCell.screenshots = self.bugReport.screenshots;
}
@end
