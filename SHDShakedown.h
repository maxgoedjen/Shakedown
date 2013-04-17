//
//  SHDShakedown.h
//  Shakedown
//
//  Created by Max Goedjen on 4/16/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDShakedown : NSObject

+ (SHDShakedown *)sharedShakedown;

- (void)stopListeningForShakes;
- (void)resumeListeningForShakes;

- (void)displayButton;
- (void)hideButton;

- (void)displayReporter;

@end
