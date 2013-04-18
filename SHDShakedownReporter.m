//
//  SHDShakedownReporter.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedownReporter.h"

@implementation SHDShakedownReporter

- (void)reportBug:(SHDBugReport *)bugReport {
    
}

- (UIViewController *)topViewController {
    UIViewController *root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    UIViewController *presented = root;
    while (presented.presentedViewController) {
        presented = presented.presentedViewController;
    }
    return presented;
}

@end
