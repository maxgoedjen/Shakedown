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
        NSString *cookie = @"";
        int statusCode = 500;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
            cookie = [[resp allHeaderFields] objectForKey:@"Set-Cookie"];
            statusCode = resp.statusCode;
        }
        
        if (statusCode == 200) {
        
            NSMutableString *report = [NSMutableString string];
            
            [report appendFormat:@"%@", bugReport.generalDescription];
            [report appendFormat:@"\n\nReproducability: Happens %@", bugReport.reproducability];
            [report appendFormat:@"\n\nSteps to reproduce: \n"];
            int i = 1;
            for (NSString *step in bugReport.steps) {
                [report appendFormat:@"%i: %@\n", i, step];
                i++;
            }
            [report appendFormat:@"\n\nDevice Information:\n"];
            for (NSString *key in bugReport.deviceDictionary) {
                [report appendFormat:@"%@: %@\n", key, bugReport.deviceDictionary[key]];
            }
            [report appendFormat:@"\n\nUser Information:\n"];
            for (NSString *key in bugReport.userInformation) {
                [report appendFormat:@"%@: %@\n", key, bugReport.userInformation[key]];
            }
            
            NSDictionary *arguments = @{
                                        @"project": self.project,
                                        @"summary": bugReport.title,
                                        @"description": report,
                                        @"attachment": bugReport.screenshots[0]};
            
            NSString *boundary = @"0xKhTmLbOuNdArY";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            
            NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/issue", self.apiURL]];
            NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL];
            [postRequest setHTTPBody:[self httpBodyDataForDictionary:arguments boundary:boundary]];
            [postRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
            [postRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
            [postRequest setHTTPMethod:@"POST"];
            [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
                    if (resp.statusCode == 200) {
                        [self.delegate shakedownFiledBugSuccessfullyWithLink:nil];
                    } else {
                        NSString *errorString = [NSString stringWithFormat:@"%@\n%@", [error localizedDescription], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                        [self.delegate shakedownFailedToFileBug:errorString];
                    }
                }
            }];
            
        } else {
            [self.delegate shakedownFailedToFileBug:[NSString stringWithFormat:@"Failed to log in to YouTrack: %@", [error localizedDescription]]];
        }

    }];
}

@end
