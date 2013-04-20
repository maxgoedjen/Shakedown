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
#import "SHDConstants.h"
#import <QuartzCore/QuartzCore.h>

@interface SHDLoadingView : UIView

@end

@implementation SHDLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kSHDOverlayBackgroundColor;
        UIView *iPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 72, 149)];
        iPhone.backgroundColor = [UIColor whiteColor];
        iPhone.layer.cornerRadius = 6.0;
        [self addSubview:iPhone];
        iPhone.center = self.center;
        UIView *screen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 112)];
        [iPhone addSubview:screen];
        screen.backgroundColor = kSHDTextHighlightColor;
        screen.center = [iPhone convertPoint:iPhone.center fromView:self];
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(60);
            [iPhone.layer setAffineTransform:rotateTransform];
            rotateTransform = CGAffineTransformMakeRotation(-60);
            [iPhone.layer setAffineTransform:rotateTransform];
        } completion:nil];
        
    }
    return self;
}

@end

@implementation SHDShakedown (Private)

- (void)submitReport:(SHDBugReport *)bugReport {
    UIView *view = self.reportViewController.view;
    SHDLoadingView *loadingView = [[SHDLoadingView alloc] initWithFrame:view.bounds];
    [view addSubview:loadingView];
    self.reportViewController.navigationController.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.reporter == nil) {
        self.reporter = [[SHDShakedownEmailReporter alloc] init];
        NSLog(@"SHAKEDOWN WARNING: NO REPORTER SPECIFIED, FALLING BACK TO EMAIL");
    }
    self.reporter.delegate = self;
    [self.reporter reportBug:bugReport];
}

- (void)failedToUploadBug {
    [self.reportViewController dismissViewControllerAnimated:YES completion:nil];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to submit bug." message:@"There was an error submitting this bug." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)uploadedBugSuccessfullyWithLink:(NSURL *)url {
    [self.reportViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
