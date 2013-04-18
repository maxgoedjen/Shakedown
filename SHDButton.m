//
//  SHDButton.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDButton.h"
#import "SHDConstants.h"
#import <QuartzCore/QuartzCore.h>

@implementation SHDButton

+ (SHDButton *)buttonWithSHDType:(SHDButtonType)buttonType {
    SHDButton *button = [SHDButton buttonWithType:UIButtonTypeCustom];
    
    switch (buttonType) {
        case SHDButtonTypeSolid:
            button.backgroundColor = kSHDTextHighlightColor;
            button.layer.cornerRadius = 15.0;
            [button setTitleColor:kSHDBackgroundColor forState:UIControlStateNormal];
            break;
        case SHDButtonTypeOutline:
            button.backgroundColor = [UIColor clearColor];
            button.layer.borderColor = [kSHDTextHighlightColor CGColor];
            button.layer.borderWidth = 2.0;
            button.layer.cornerRadius = 15.0;
            [button setTitleColor:kSHDTextHighlightColor forState:UIControlStateNormal];
            break;
        default:
            [button setTitleColor:kSHDTextNormalColor forState:UIControlStateNormal];
            break;
    }
    
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    button.titleEdgeInsets = UIEdgeInsetsMake(4, 10, 4, 10);

    return button;
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGSize original = [super sizeThatFits:size];
    original.height = 30;
    original.width += 30;
    return original;
}

@end
