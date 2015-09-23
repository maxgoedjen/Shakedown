//
//  ObjCViewController.m
//  ShakedownSample
//
//  Created by Max Goedjen on 3/22/15.
//  Copyright (c) 2015 Max Goedjen. All rights reserved.
//

#import "ObjCViewController.h"
#import "ShakedownSample-Swift.h"

@import Shakedown;

@implementation ObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Shakedown displayFrom:nil];
    [Shakedown logMessage:@"Test"];
    Shakedown.configuration.additionalMetadata = @{@"A" : @"B"};
}

@end
