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

@property (nonatomic) UIButton *reportButton;
@property (nonatomic) NSDictionary *userInfo;

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

#pragma mark - User info

- (void)attachUserInformation:(NSDictionary *)info {
    self.userInfo = info;
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
    newBug.userInformation = @{@"Username" : @"Test"};
    SHDReporterViewController *viewController = [[SHDReporterViewController alloc] initWithNibName:nil bundle:nil bugReport:newBug];
    UIViewController *root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [root presentViewController:navController animated:YES completion:nil];
}


@end
