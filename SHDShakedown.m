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
#import "SHDShakedownEmailReporter.h"
#import "SHDButton.h"

@interface SHDShakedown ()

@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSMutableString *internalLog;
@property (nonatomic, strong) UIWindow *buttonWindow;

@end

@implementation SHDShakedown

- (id)init {
    self = [super init];
    if (self) {
        [self resumeListeningForShakes];
        _reporter = [[SHDShakedownEmailReporter alloc] init];
        _internalLog = [[NSMutableString alloc] init];
        _userInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (SHDShakedown *)sharedShakedown {
    static dispatch_once_t onceToken;
    static SHDShakedown *instance = nil;
    dispatch_once(&onceToken, ^{
#if defined(DEBUG) || defined(ADHOC)
        instance = [[SHDShakedown alloc] init];
#endif
    });
    return instance;
}

#pragma mark - User info

- (void)attachUserInformation:(NSDictionary *)info {
    [self.userInfo addEntriesFromDictionary:info];
}

#pragma mark - Log data

- (NSString *)log {
    return [NSString stringWithString:self.internalLog];
}

- (void)log:(NSString *)log {
    [self.internalLog appendFormat:@"%@ - %@\n", [NSDate date], log];
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
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.windowLevel = UIWindowLevelStatusBar;
    SHDButton *button = [SHDButton buttonWithSHDType:SHDButtonTypeStatusBar];
    button.frame = CGRectMake(80, 0, 20, 20);
    [button setTitle:@"!" forState:UIControlStateNormal];
    [window addSubview:button];
    [window makeKeyAndVisible];
    self.buttonWindow = window;
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
    newBug.userInformation = self.userInfo;
    newBug.log = [NSString stringWithString:self.internalLog];
    SHDReporterViewController *viewController = [[SHDReporterViewController alloc] initWithNibName:nil bundle:nil bugReport:newBug];
    UIViewController *root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    UIViewController *presented = root;
    while (presented.presentedViewController) {
        presented = presented.presentedViewController;
    }
    
    if ([presented isMemberOfClass:[SHDReporterViewController class]] == NO) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        [presented presentViewController:navController animated:YES completion:nil];

    }
    
}


@end
