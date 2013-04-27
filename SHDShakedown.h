//
//  SHDShakedown.h
//  Shakedown
//
//  Created by Max Goedjen on 4/16/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHDShakedownReporter;
@class SHDReporterViewController;

@interface SHDShakedown : NSObject

@property (nonatomic, strong) SHDShakedownReporter *reporter;

+ (SHDShakedown *)sharedShakedown;

- (void)attachUserInformation:(NSDictionary *)info;

- (void)log:(NSString *)log;

- (void)stopListeningForShakes;
- (void)resumeListeningForShakes;

- (void)displayButton;
- (void)hideButton;

- (void)displayReporter;

@end
