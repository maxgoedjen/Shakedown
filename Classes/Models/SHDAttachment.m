//
//  SHDAttachment.m
//  Shakedown
//
//  Created by Jean Regisser on 5/7/13.
//  Copyright (c) 2013 Jean Regisser. All rights reserved.
//

#import "SHDAttachment.h"

@implementation SHDAttachment

+ (SHDAttachment *)attachmentWithName:(NSString *)name fileName:(NSString *)fileName
                            mimeType:(NSString *)mimeType data:(NSData *)data {
    SHDAttachment *attachment = [[self alloc] init];
    attachment.name = name;
    attachment.fileName = fileName;
    attachment.mimeType = mimeType;
    attachment.data = data;
    return attachment;
}

@end
