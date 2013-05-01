//
//  SHDShakedownPivotalTrackerReporter.h
//  Shakedown
//
//  Created by Jean Regisser on 4/26/13.
//  Copyright (c) 2013 Jean Regisser. All rights reserved.
//

#import "SHDShakedownReporter.h"

@interface SHDShakedownPivotalTrackerReporter : SHDShakedownReporter

@property (nonatomic, strong) NSString *apiURL;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *projectID;
@property (nonatomic, strong) NSString *labels;

@end
