//
//  SHDShakedownYouTrackReporter.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedownYouTrackReporter.h"

@implementation SHDShakedownYouTrackReporter

- (id)init {
    self = [super init];
    if (self) {
        self.login = @"";
        self.password = @"";
    }
    return self;
}

- (void)reportBug:(SHDBugReport *)bugReport {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/login", self.apiURL]];
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *body = [NSString stringWithFormat:@"login=%@&password=%@", self.login, self.password];
    [loginRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [loginRequest setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:loginRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString *strung = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", strung);
    }];
}

@end
