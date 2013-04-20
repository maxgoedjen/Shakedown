//
//  SHDShakedownEmailReporter.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDShakedownEmailReporter.h"
#import <MessageUI/MessageUI.h>

@interface SHDShakedownEmailReporter () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) MFMailComposeViewController *composer;

@end

@implementation SHDShakedownEmailReporter

- (void)reportBug:(SHDBugReport *)bugReport {
    self.composer = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    [self.composer setSubject:bugReport.title];
    for (UIImage *screenshot in bugReport.screenshots) {
        [self.composer addAttachmentData:UIImagePNGRepresentation(screenshot) mimeType:@"img/png" fileName:@"screenshot.png"];
    }
    [self.composer setMessageBody:bugReport.formattedReport isHTML:NO];
    if (self.recipient) {
        [self.composer setToRecipients:@[self.recipient]];
    }
    self.composer.mailComposeDelegate = self;
    [self.topViewController presentViewController:self.composer animated:YES completion:nil];
}

#pragma mark - Mail Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0) {
    [self.composer dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            [self.delegate shakedownFiledBugSuccessfullyWithLink:nil];
        } else if (result == MFMailComposeResultCancelled || MFMailComposeResultSaved) {
            [self.delegate shakedownCancelledReportingBug];
        } else {
            [self.delegate shakedownFailedToFileBug:@"Unable to send message"];
        }
    }];
    
}

@end
