//
//  SHDShakedown+Private.h
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedown.h"

@class SHDBugReport;

@interface SHDShakedown (Private)

- (void)submitReport:(SHDBugReport *)bugReport;

@end
