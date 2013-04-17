//
//  SHDShakedown.m
//  Shakedown
//
//  Created by Max Goedjen on 4/16/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedown.h"
#import "SHDConstants.h"
#import "UIWindow+SHDShakeListener.h"
#import "SHDReporterViewController.h"
#import "SHDBugReport.h"

@interface SHDShakedown ()

@property (nonatomic, strong) UIButton *reportButton;

@end

@implementation SHDShakedown

- (id)init {
    self = [super init];
    if (self) {
        [self resumeListeningForShakes];
        [self displayButton];
    }
    return self;
}

+ (SHDShakedown *)sharedShakedown {
    static dispatch_once_t onceToken;
    static SHDShakedown *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SHDShakedown alloc] init];
    });
    return instance;
}

#pragma mark - Shake

- (void)stopListeningForShakes {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resumeListeningForShakes {
    [[NSNotificationCenter defaultCenter] addObserverForName:kSHDShakeEvent object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self _showReporter];
    }];
}

#pragma mark - Status Bar Button

- (void)displayButton {
}

- (void)hideButton {
}

#pragma mark - Programmatic Reporting

- (void)displayReporter {
    [self _showReporter];
}

#pragma mark - Reporting

- (void)_showReporter {
    SHDBugReport *newBug = [[SHDBugReport alloc] init];
    SHDReporterViewController *viewController = [[SHDReporterViewController alloc] init];
    UIViewController *root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    [root presentViewController:viewController animated:YES completion:nil];
    NSLog(@"%@ %@", newBug, viewController);
}


@end
