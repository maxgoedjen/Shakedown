//
//  SHDButton.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SHDButtonTypeSolid,
    SHDButtonTypeOutline,
    SHDButtonTypeTextOnly,
    SHDButtonTypeStatusBar
} SHDButtonType;

@interface SHDButton : UIButton

+ (SHDButton *)buttonWithSHDType:(SHDButtonType)buttonType;

@end
