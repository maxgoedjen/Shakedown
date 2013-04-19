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
#import "SHDConstants.h"
#import "SHDButton.h"
#import "SHDTextViewCell.h"
#import "SHDTextFieldCell.h"
#import "SHDMultipleSelectionCell.h"
#import "SHDScreenshotsCell.h"
#import "SHDDescriptiveInfoCell.h"
#import "SHDListCell.h"
#import "SHDShakedown.h"
#import "SHDShakedownReporter.h"
#import "SHDShakedown+Private.h"

@interface SHDReporterViewController () <SHDShakedownReporterDelegate>

@property (nonatomic, strong) SHDBugReport *bugReport;

@end

@implementation SHDReporterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bugReport:(SHDBugReport *)bugReport {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bugReport = bugReport;
    }
    return self;
}

- (void)loadView {
    self.view = [[SHDReporterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    SHDButton *cancel = [SHDButton buttonWithSHDType:SHDButtonTypeTextOnly];
    [cancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancel sizeToFit];
    [cancel addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    
    SHDButton *save = [SHDButton buttonWithSHDType:SHDButtonTypeSolid];
    [save setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [save sizeToFit];
    [save addTarget:self action:@selector(_save:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    self.navigationItem.title = @"Report Issue";
    self.navigationController.navigationBar.tintColor = kSHDBackgroundColor;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    UITextAttributeTextColor: kSHDTextNormalColor,
                                                                    UITextAttributeTextShadowColor: [UIColor clearColor]
                                                                    };
    SHDReporterView *view = (SHDReporterView *)self.view;
    
    view.titleCell.textField.placeholder = @"This bug is titled...";
    view.descriptionCell.placeholder = @"I was doing this and then this happened...";
    view.reproducabilityCell.text = @"This happens";
    view.reproducabilityCell.options = @[@"every time", @"sometimes", @"infrequently"];
    view.screenshotsCell.screenshots = self.bugReport.screenshots;
    NSMutableDictionary *device = [NSMutableDictionary dictionaryWithDictionary:self.bugReport.deviceDictionary];
    [device addEntriesFromDictionary:self.bugReport.userInformation];
    view.deviceInfoCell.dictionary = device;
}

#pragma mark - Buttons

- (void)_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_save:(id)sender {
    [[[SHDShakedown sharedShakedown] reporter] setDelegate:self];
    SHDReporterView *view = (SHDReporterView *)self.view;
    [view endEditing:YES];
    self.bugReport.title = view.titleCell.textField.text;
    self.bugReport.generalDescription = view.descriptionCell.textView.text;
    self.bugReport.reproducability = view.reproducabilityCell.text;
    self.bugReport.steps = view.stepsCell.items;
    [[SHDShakedown sharedShakedown] submitReport:self.bugReport];
}

#pragma mark - Reporter Delegate

- (void)failedToUploadBug {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadedBugSuccessfullyWithLink:(NSURL *)url {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
