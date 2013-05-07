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

#if defined(DEBUG) || defined(ADHOC)
+ (UIImage *)takeScreenshot {
    // Take the interface orientation into account
    UIImageOrientation *imageOrientation = UIImageOrientationUp;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            // yes interface landscape left IS image orientation right!
            imageOrientation = UIImageOrientationRight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            // yes interface landscape right IS image orientation left!
            imageOrientation = UIImageOrientationLeft;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            imageOrientation = UIImageOrientationDown;
            break;
        default:
            break;
    }

    UIImage *image = [UIImage imageWithCGImage:UIGetScreenImage() scale:[UIScreen mainScreen].scale orientation:imageOrientation];
    
    // Now draw this image in a new context so that
    // the correct orientation is kept once the image is displayed on 3rd party services
    // that don't respect the orientation metadata
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}
#endif

- (id)init {
    self = [super init];
    if (self) {
        _device = [UIDevice currentDevice];
        _screenshots = [NSMutableArray array];
#if defined(DEBUG) || defined(ADHOC)
        [_screenshots addObject:[[self class] takeScreenshot]];
#endif
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

- (NSString *)formattedReport {
    NSMutableString *report = [NSMutableString string];
    
    [report appendFormat:@"%@", self.generalDescription];
    [report appendFormat:@"\n\nReproducability: Happens %@", self.reproducability];
    [report appendFormat:@"\n\nSteps to reproduce: \n"];
    int i = 1;
    for (NSString *step in self.steps) {
        [report appendFormat:@"%i: %@\n", i, step];
        i++;
    }
    [report appendFormat:@"\n\nDevice Information:\n"];
    for (NSString *key in self.deviceDictionary) {
        [report appendFormat:@"%@: %@\n", key, self.deviceDictionary[key]];
    }
    [report appendFormat:@"\n\nUser Information:\n"];
    for (NSString *key in self.userInformation) {
        [report appendFormat:@"%@: %@\n", key, self.userInformation[key]];
    }
    
    return report;
}

#if defined(DEBUG) || defined(ADHOC)
CGImageRef UIGetScreenImage(void);
#endif

@end
