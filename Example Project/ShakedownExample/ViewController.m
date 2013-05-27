//
//  ViewController.m
//  ShakedownExample
//
//  Created by Max Goedjen on 5/27/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "ViewController.h"
#import "SHDShakedown.h"
#import "SHDShakedownEmailReporter.h"

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    SHDShakedownEmailReporter *emailReporter = [[SHDShakedownEmailReporter alloc] init];
    emailReporter.recipient = @"hello@test.com";
    [[SHDShakedown sharedShakedown] setReporter:emailReporter];
}

@end
