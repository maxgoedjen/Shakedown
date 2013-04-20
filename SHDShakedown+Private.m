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

@implementation SHDShakedown (Private)

- (void)submitReport:(SHDBugReport *)bugReport {    
    [self.reporter reportBug:bugReport];
}


@end
