//
//  UIWindow+SHDShakeListener.m
//  Shakedown
//
//  Created by Max Goedjen on 4/16/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "UIWindow+SHDShakeListener.h"
#import "SHDConstants.h"

@implementation UIWindow (SHDShakeListener)

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSHDShakeEvent object:nil];
    }
}


@end
