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

@property (nonatomic, strong) UIDevice *device;

@end

@implementation SHDBugReport

- (id)init {
    self = [super init];
    if (self) {
        _device = [UIDevice currentDevice];
        _screenshots = [NSMutableArray arrayWithObject:[self _screenshot]];
        _title = @"";
        _generalDescription = @"";
        _reproducability = @"";
        _steps = [NSMutableArray array];
        _userInformation = @{};
    }
    return self;
}

- (NSDictionary *)deviceDictionary {
    NSDictionary *dictionary = @{
                                 @"Name": self.device.name,
                                 @"System Name": self.device.systemName,
                                 @"iOS Version": self.device.systemVersion,
                                 @"model": self.device.model,
                                 @"UI Idiom": self.device.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? @"UIUserInterfaceIdiomPhone" : @"UIUserInterfaceIdiomPad",
                                 @"IDFV": [self.device.identifierForVendor UUIDString]
                                 };
    return dictionary;
}

#pragma mark - Screenshots

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
