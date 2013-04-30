//
//  SHDShakedownPivotalTrackerReporter.m
//  Shakedown
//
//  Created by Jean Regisser on 4/26/13.
//  Copyright (c) 2013 Jean Regisser. All rights reserved.
//

#import "SHDShakedownPivotalTrackerReporter.h"
#import "SHDXMLReader.h"

static NSString * const kSHDTrackerTokenHeaderField = @"X-TrackerToken";

// This replicates `AFPercentEscapedQueryStringPairMemberFromStringWithEncoding`.
static NSString * SHDPercentEscapedQueryStringFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kSHDCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kSHDCharactersToLeaveUnescaped = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kSHDCharactersToLeaveUnescaped, (__bridge CFStringRef)kSHDCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@implementation SHDShakedownPivotalTrackerReporter

- (id)init {
    self = [super init];
    if (self) {
        self.apiURL = @"https://www.pivotaltracker.com/services/v3";
    }
    return self;
}

- (void)sendAsynchronousXMLRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSDictionary *xmlDictionary, NSError *error))handler {
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError* returnError = error;
        NSDictionary* xmlDictionary = nil;

        NSString *contentType = response.MIMEType;
        if (!returnError && data.length && [[NSSet setWithObjects:@"application/xml", @"text/xml", nil] containsObject:contentType]) {
            xmlDictionary = [SHDXMLReader dictionaryForXMLData:data error:&returnError];
        }

        handler(response, data, xmlDictionary, returnError);
    }];
}

- (void)addAttachment:(id)attachmentData toStoryID:(NSString *)storyID completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSDictionary *xmlDictionary, NSError *error))handler {
    NSDictionary *attachments = @{ @"Filedata": attachmentData };
	
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	
    NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%@/stories/%@/attachments", self.apiURL, self.projectID, storyID]];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL];
    [postRequest setTimeoutInterval:120.0]; // Upload can take some time on slower connections
    NSData* body = [self httpBodyDataForDictionary:nil attachments:attachments boundary:boundary];
    [postRequest setHTTPBody:body];
    [postRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:self.token forHTTPHeaderField:kSHDTrackerTokenHeaderField];
    [self sendAsynchronousXMLRequest:postRequest completionHandler:handler];
}

- (NSInteger)statusCodeForResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        return resp.statusCode;
    }
	
    return NSNotFound;
}

- (void)reportBug:(SHDBugReport *)bugReport {
    NSMutableArray* queryParams = [NSMutableArray array];
    [queryParams addObject:@"story[story_type]=bug"];
    if (bugReport.title.length) {
        [queryParams addObject:[NSString stringWithFormat:@"story[name]=%@",
        SHDPercentEscapedQueryStringFromStringWithEncoding(bugReport.title, NSUTF8StringEncoding)]];
    }
    if (bugReport.formattedReport.length) {
        [queryParams addObject:[NSString stringWithFormat:@"story[description]=%@",
        SHDPercentEscapedQueryStringFromStringWithEncoding(bugReport.formattedReport, NSUTF8StringEncoding)]];
    }
    if (self.labels.length) {
        [queryParams addObject:[NSString stringWithFormat:@"story[labels]=%@",
        SHDPercentEscapedQueryStringFromStringWithEncoding(self.labels, NSUTF8StringEncoding)]];
    }
	
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/projects/%@/stories?%@", self.apiURL, self.projectID, [queryParams componentsJoinedByString:@"&"]]];
    NSMutableURLRequest *addStoryRequest = [NSMutableURLRequest requestWithURL:url];
    [addStoryRequest setHTTPMethod:@"POST"];
    [addStoryRequest setValue:self.token forHTTPHeaderField:kSHDTrackerTokenHeaderField];
	
    __weak SHDShakedownPivotalTrackerReporter *weakSelf = self;
	
    [self sendAsynchronousXMLRequest:addStoryRequest completionHandler:^(NSURLResponse *response, NSData *data, NSDictionary *xmlDictionary, NSError *error) {
        __strong SHDShakedownPivotalTrackerReporter *strongSelf = weakSelf;
        if (!strongSelf) { return; }
    
        if (error) {
            [strongSelf.delegate shakedownFailedToFileBug:[NSString stringWithFormat:@"Could not create bug on Pivotal: %@", error.localizedDescription]];
        } else {
            NSString *storyID = [xmlDictionary valueForKeyPath:@"story.id.text"];
            NSString *storyURL = [xmlDictionary valueForKeyPath:@"story.url.text"];
      
            if ([strongSelf statusCodeForResponse:response] == 200 && storyID.length) {
                [self addAttachment:bugReport.screenshots[0] toStoryID:storyID completionHandler:^(NSURLResponse *response, NSData *data, NSDictionary *xmlDictionary, NSError *error) {
                    __strong SHDShakedownPivotalTrackerReporter *strongSelf = weakSelf;
                    if (!strongSelf) { return; }

                    if (error) {
                        [strongSelf.delegate shakedownFailedToFileBug:[NSString stringWithFormat:@"Could not add attachment on Pivotal: %@", error.localizedDescription]];
                    } else {
                        NSString *attachmentID = [xmlDictionary valueForKeyPath:@"attachment.id.text"];

                        if ([strongSelf statusCodeForResponse:response] == 200 && attachmentID.length) {
                            [strongSelf.delegate shakedownFiledBugSuccessfullyWithLink:[NSURL URLWithString:storyURL]];
                        } else {
                            // Assume data is encoded in UTF8 (even if it might be wrong)
                            [strongSelf.delegate shakedownFailedToFileBug:
                            [NSString stringWithFormat:@"Could not add attachment on Pivotal: invalid response ('%@')",
                            [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
                        }
                    }
                }];
            } else {
                // Assume data is encoded in UTF8 (even if it might be wrong)
                [strongSelf.delegate shakedownFailedToFileBug:
                [NSString stringWithFormat:@"Could not create bug on Pivotal: invalid response ('%@')",
                [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
            }
        }
    }];
}

@end
