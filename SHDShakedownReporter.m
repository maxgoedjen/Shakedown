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


#pragma mark - Base 64

// Based on https://github.com/ekscrypto/Base64

- (NSString *)base64StringFromString:(NSString *)string {
    return [self base64StringFromData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)base64StringFromData:(NSData *)data {
    
    NSString *encoding = nil;
    unsigned char *encodingBytes = NULL;
    @try {
        static char encodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        static NSUInteger paddingTable[] = {0,2,1};
        
        NSUInteger dataLength = [data length];
        NSUInteger encodedBlocks = (dataLength * 8) / 24;
        NSUInteger padding = paddingTable[dataLength % 3];
        if( padding > 0 ) encodedBlocks++;
        NSUInteger encodedLength = encodedBlocks * 4;
        
        encodingBytes = malloc(encodedLength);
        if( encodingBytes != NULL ) {
            NSUInteger rawBytesToProcess = dataLength;
            NSUInteger rawBaseIndex = 0;
            NSUInteger encodingBaseIndex = 0;
            unsigned char *rawBytes = (unsigned char *)[data bytes];
            unsigned char rawByte1, rawByte2, rawByte3;
            while( rawBytesToProcess >= 3 ) {
                rawByte1 = rawBytes[rawBaseIndex];
                rawByte2 = rawBytes[rawBaseIndex+1];
                rawByte3 = rawBytes[rawBaseIndex+2];
                encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) | ((rawByte3 >> 6) & 0x03) ];
                encodingBytes[encodingBaseIndex+3] = encodingTable[(rawByte3 & 0x3F)];
                
                rawBaseIndex += 3;
                encodingBaseIndex += 4;
                rawBytesToProcess -= 3;
            }
            rawByte2 = 0;
            switch (dataLength-rawBaseIndex) {
                case 2:
                    rawByte2 = rawBytes[rawBaseIndex+1];
                case 1:
                    rawByte1 = rawBytes[rawBaseIndex];
                    encodingBytes[encodingBaseIndex] = encodingTable[((rawByte1 >> 2) & 0x3F)];
                    encodingBytes[encodingBaseIndex+1] = encodingTable[((rawByte1 << 4) & 0x30) | ((rawByte2 >> 4) & 0x0F) ];
                    encodingBytes[encodingBaseIndex+2] = encodingTable[((rawByte2 << 2) & 0x3C) ];
                    break;
            }
            encodingBaseIndex = encodedLength - padding;
            while( padding-- > 0 ) {
                encodingBytes[encodingBaseIndex++] = '=';
            }
            encoding = [[NSString alloc] initWithBytes:encodingBytes length:encodedLength encoding:NSASCIIStringEncoding];
        }
    }
    @catch (NSException *exception) {
        encoding = nil;
        NSLog(@"WARNING: error occured while tring to encode base 32 data: %@", exception);
    }
    @finally {
        if( encodingBytes != NULL ) {
            free( encodingBytes );
        }
    }
    return encoding;
}

#pragma mark - HTTP multipart encoding

- (NSData *)httpBodyDataForDictionary:(NSDictionary *)dictionary attachments:(NSDictionary *)attachments boundary:(NSString *)boundary {
    
    NSMutableData *body = [NSMutableData data];
    
    NSData *initialBoundary = [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encapsulationBoundary = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
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
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.txt\"\r\n", @"file", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: text/plain\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
        } else if ([value isKindOfClass:[UIImage class]]) {
            [body appendData:initialBoundary ?: encapsulationBoundary];
            initialBoundary = nil;
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n", @"file", key] dataUsingEncoding:NSUTF8StringEncoding]];
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
