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
#if defined(DEBUG) || defined(ADHOC)
        _screenshots = [NSMutableArray arrayWithObject:[UIImage imageWithCGImage:UIGetScreenImage()]];
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
