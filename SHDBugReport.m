//
//  SHDBugReport.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDBugReport.h"
#import <QuartzCore/QuartzCore.h>

@interface SHDBugReport ()

@property (nonatomic) NSMutableArray *internalScreenshots;

@end

@implementation SHDBugReport

- (id)init {
    self = [super init];
    if (self) {
        _device = [UIDevice currentDevice];
        _internalScreenshots = [NSMutableArray arrayWithObject:[self _screenshot]];
    }
    return self;
}

#pragma mark - Screenshots

- (NSArray *)screenshots {
    return [NSArray arrayWithArray:self.internalScreenshots];
}

- (UIImage *)_screenshot {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    return [[UIImage alloc] initWithData:data];
}

@end
