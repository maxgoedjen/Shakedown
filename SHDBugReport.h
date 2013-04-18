//
//  SHDBugReport.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDBugReport : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *generalDescription;
@property (nonatomic) NSString *reproducability;
@property (nonatomic) NSMutableArray *screenshots;
@property (nonatomic, readonly) UIDevice *device;

@end
