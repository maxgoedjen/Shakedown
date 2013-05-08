//
//  SHDAttachment.h
//  Shakedown
//
//  Created by Jean Regisser on 5/7/13.
//  Copyright (c) 2013 Jean Regisser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDAttachment : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSData *data;

+ (SHDAttachment*)attachmentWithName:(NSString *)name fileName:(NSString *)fileName
                            mimeType:(NSString *)mimeType data:(NSData *)data;

@end
