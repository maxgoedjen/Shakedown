//
//  SHDShakedownPivotalTrackerReporter.h
//  Shakedown
//
//  Created by Jean Regisser on 4/26/13.
//  Copyright (c) 2013 Jean Regisser. All rights reserved.
//

#import "SHDShakedownReporter.h"

@interface SHDShakedownPivotalTrackerReporter : SHDShakedownReporter

@property (nonatomic, copy) NSString *apiURL;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *projectID;
@property (nonatomic, copy) NSString *labels;

@end
