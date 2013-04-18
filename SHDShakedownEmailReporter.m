//
//  SHDShakedownEmailReporter.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedownEmailReporter.h"
#import <MessageUI/MessageUI.h>

@implementation SHDShakedownEmailReporter

- (void)reportBug:(SHDBugReport *)bugReport {
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    [root.presentedViewController presentModalViewController:composer animated:YES];
}

@end
