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
//        NSLog(@"%@", strung);
//        
//        NSString *description = [NSString stringWithFormat:@"%@ \nHappens %@\n Steps to reproduce:\n %@\nDevice Info:\n%@\nCustom Info:\n%@", bugReport.description, bugReport.reproducability, bugReport.steps, bugReport.deviceDictionary, bugReport.userInformation];
//        
//        NSMutableData *body = [NSMutableData data];
//        
//        NSDictionary *arguments = @{
//                                    @"project": self.project,
//                                    @"summary": bugReport.title,
//                                    @"description": description};
//        for (NSString *argument in arguments) {
//            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", argument] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [arguments objectForKey:argument]] dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        
//        // add image data
//        NSData *imageData = UIImagePNGRepresentation(bugReport.screenshots[0]);
//        if (imageData) {
//            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//            [body appendData:[:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
//            [body appendData:imageData];
//            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        
//        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//
    }];
}

@end
