//
//  SHDShakedown+Private.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedown+Private.h"
#import "SHDBugReport.h"
#import "SHDShakedownReporter.h"
#import "SHDShakedownEmailReporter.h"

@implementation SHDShakedown (Private)

- (void)submitReport:(SHDBugReport *)bugReport {
    if (self.reporter == nil) {
        self.reporter = [[SHDShakedownEmailReporter alloc] init];
        NSLog(@"SHAKEDOWN WARNING: NO REPORTER SPECIFIED, FALLING BACK TO EMAIL");
    }
    self.reporter.delegate = self;
    [self.reporter reportBug:bugReport];
}

- (void)failedToUploadBug {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to submit bug." message:@"There was an error submitting this bug." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)uploadedBugSuccessfullyWithLink:(NSURL *)url {
    [self.reportViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
