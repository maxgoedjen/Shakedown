//
//  SHDShakedownReporter.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedownReporter.h"

@implementation SHDShakedownReporter

- (void)reportBug:(SHDBugReport *)bugReport {
    
}

- (UIViewController *)topViewController {
    UIViewController *root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    UIViewController *presented = root;
    while (presented.presentedViewController) {
        presented = presented.presentedViewController;
    }
    return presented;
}

- (NSData *)httpBodyDataForDictionary:(NSDictionary *)dictionary attachments:(NSDictionary *)attachments boundary:(NSString *)boundary {
    
    NSMutableData *body = [NSMutableData data];
    
    NSData *initialBoundary = [NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encapsulationBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    for (NSString *key in dictionary) {
        id value = dictionary[key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *stringValue = (NSString *)value;
            [body appendData:initialBoundary ?: encapsulationBoundary];
            initialBoundary = nil;
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
        } else {
            NSLog(@"SHDShakedownRepoter: cannot post type %@ (value for key %@", [value class], key);
        }
    }
    
    for (NSString *key in attachments) {
        id value = attachments[key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *stringValue = (NSString *)value;
            [body appendData:initialBoundary ?: encapsulationBoundary];
            initialBoundary = nil;
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.txt\"\r\n", key, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: text/plain\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
        } else if ([value isKindOfClass:[UIImage class]]) {
            [body appendData:initialBoundary ?: encapsulationBoundary];
            initialBoundary = nil;
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n", key, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:UIImagePNGRepresentation(value)];
        } else {
            NSLog(@"SHDShakedownRepoter: cannot post attachment type %@ (value for key %@", [value class], key);
        }
    }
    
    // Final boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;

}

@end
