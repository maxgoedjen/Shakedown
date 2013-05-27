//
//  SHDBugReport.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDBugReport : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *generalDescription;
@property (nonatomic, strong) NSString *reproducability;
@property (nonatomic, strong) NSArray *steps;
@property (nonatomic, strong) NSMutableArray *screenshots;

@property (nonatomic, strong) NSDictionary *userInformation;
@property (nonatomic, readonly) NSDictionary *deviceDictionary;

@property (nonatomic, strong) NSString *log;

@property (nonatomic, readonly) NSString *formattedReport;

@property (nonatomic, strong) NSMutableArray *attachments; // Array of SHDAttachment

@end
