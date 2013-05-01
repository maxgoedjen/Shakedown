//
//  SHDShakedownJIRAReporter.m
//  Shakedown
//
//  Created by Max Goedjen on 4/27/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedownJIRAReporter.h"

@implementation SHDShakedownJIRAReporter

- (id)init {
    self = [super init];
    if (self) {
        _login = @"";
        _password = @"";
    }
    return self;
}

- (void)reportBug:(SHDBugReport *)bugReport {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/issue", self.apiURL]];
    NSMutableURLRequest *create = [NSMutableURLRequest requestWithURL:url];
    NSString *authString = [NSString stringWithFormat:@"%@:%@", self.login, self.password];
    NSString *basic = [NSString stringWithFormat:@"Basic %@", [self base64StringFromString:authString]];
    [create setValue:basic forHTTPHeaderField:@"Authorization"];
    [create setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [create setHTTPMethod:@"POST"];
    
    NSDictionary *issueDict = @{
                                @"fields": @{
                                    @"project": @{@"key": self.project},
                                    @"summary": [NSString stringWithFormat:@"%@", bugReport.title],
                                    @"description": bugReport.formattedReport,
                                    @"assignee": @{@"name": self.login},
                                    @"issuetype": @{@"name": @"Bug"},
                                    @"reporter": @{@"name": self.login}
                                }
                                };
    
    [create setHTTPBody:[NSJSONSerialization dataWithJSONObject:issueDict options:0 error:nil]];
    NSLog(@"%@", [[NSString alloc] initWithData:create.HTTPBody encoding:NSUTF8StringEncoding]);

    [NSURLConnection sendAsynchronousRequest:create queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self.delegate shakedownFailedToFileBug:@"Unable to log in"];
            return;
        }
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSError *parseError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
        if (parseError != nil) {
            [self.delegate shakedownFailedToFileBug:@"Unable to log in"];
        } else {
            NSLog(@"%@", jsonResponse);
        }
    }];
}

@end
