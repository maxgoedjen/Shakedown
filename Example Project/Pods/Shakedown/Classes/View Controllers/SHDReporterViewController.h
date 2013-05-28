//
//  SHDReporterViewController.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHDBugReport;

@interface SHDReporterViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bugReport:(SHDBugReport *)bugReport;

@end
