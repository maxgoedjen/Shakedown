//
//  SHDShakedownReporter.h
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHDBugReport.h"

@protocol  SHDShakedownReporterDelegate <NSObject>

- (void)shakedownFailedToFileBug:(NSString *)message;
- (void)shakedownCancelledReportingBug;
- (void)shakedownFiledBugSuccessfullyWithLink:(NSURL *)url;

@end

@class SHDAttachment;

@interface SHDShakedownReporter : NSObject

@property (nonatomic, weak) id <SHDShakedownReporterDelegate> delegate;
@property (nonatomic, readonly) UIViewController *topViewController;

- (void)reportBug:(SHDBugReport *)bugReport;

- (NSArray *)attachmentsForScreenshots:(NSArray *)screenshots; /** Create array of SHDAttachment with PNG data from the array of UIImage */
- (SHDAttachment *)attachmentForLog:(NSString *)log; /** Create a SHDAttachment from the log */
- (NSArray *)allAttachmentsForBugReport:(SHDBugReport*)bugReport; /** Create an array of SHDAttachment from the screenshot, log and attachment for the SHDBugReport */

- (NSString *)base64StringFromString:(NSString *)string;
- (NSString *)base64StringFromData:(NSData *)data;

- (NSData *)httpBodyDataForDictionary:(NSDictionary *)dictionary attachments:(NSArray *)attachments boundary:(NSString *)boundary;

@end
