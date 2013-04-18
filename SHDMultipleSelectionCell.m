//
//  SHDMultipleSelectionCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDMultipleSelectionCell.h"
#import "SHDConstants.h"
#import "SHDButton.h"
#import <QuartzCore/QuartzCore.h>

@interface SHDMultipleSelectionCell ()

@property (nonatomic) UILabel *label;
@property (nonatomic) SHDButton *displayButton;

@end

@implementation SHDMultipleSelectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 18, 16)];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = kSHDTextNormalColor;
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    self.displayButton = [SHDButton buttonWithSHDType:SHDButtonTypeSolid];
    self.displayButton.frame = CGRectZero;
    [self.displayButton addTarget:self action:@selector(_showOptions) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.displayButton];
}

- (void)setText:(NSString *)text {
    self.label.text = text;
    [self.label sizeToFit];
    CGRect labelFrame = self.label.frame;
    self.displayButton.frame = CGRectMake(labelFrame.size.width + labelFrame.origin.x + 10, 10, 140, 30);
    [self.displayButton sizeToFit];
}

- (void)setOptions:(NSArray *)options {
    _options = options;
    [self.displayButton setTitle:[self.options objectAtIndex:0] forState:UIControlStateNormal];
    [self.displayButton sizeToFit];
}

- (void)_showOptions {
    UIView *superView = self.superview;
    SHDMultipleSelectionOptionsView *view = [[SHDMultipleSelectionOptionsView alloc] initWithFrame:superView.bounds sourceButton:self.displayButton options:self.options];
    [superView addSubview:view];
}

@end

@interface SHDMultipleSelectionOptionsView ()

@property (nonatomic) UIButton *sourceButton;
@property (nonatomic) NSArray *options;

@end

@implementation SHDMultipleSelectionOptionsView

typedef CGFloat (^EasingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);

static EasingFunction easeOutElastic = ^CGFloat(CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat amplitude = 5;
    CGFloat period = 0.3;
    CGFloat s = 0;
    if (t == 0) {
        return b;
    }
    else if ((t /= d) == 1) {
        return b + c;
    }
    
    if (!period) {
        period = d * .3;
    }
    
    if (amplitude < abs(c)) {
        amplitude = c;
        s = period / 4;
    }
    else {
        s = period / (2 * M_PI) * sin(c / amplitude);
    }
    
    return (amplitude * pow(2, -10 * t) * sin((t * d - s) * (2 * M_PI) / period) + c + b);
};

- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton options:(NSArray *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _sourceButton = sourceButton;
        _options = options;
    }
    return self;
}

- (void)didMoveToSuperview {
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    
    CGRect sourceFrame = [self convertRect:self.sourceButton.frame fromView:self.sourceButton.superview];
    
    __block CGFloat runningOffset = 20;
    
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        int count = 0;
        for (NSString *option in self.options) {
            
            SHDButton *outline = [SHDButton buttonWithSHDType:SHDButtonTypeOutline];
            outline.frame = sourceFrame;
            [self addSubview:outline];
            [outline setTitle:option forState:UIControlStateNormal];
            [outline sizeToFit];
            CGRect centered = outline.frame;
            centered.origin.x -= (centered.size.width - sourceFrame.size.width) / 2;
            outline.frame = centered;
            
            __block CGRect dest = outline.frame;
            CGFloat offset = runningOffset;
            count++;

            int sign = (offset <  outline.frame.origin.y ? 1 : -1);
            [UIView animateWithDuration:.2 animations:^{
                [UIView animateWithDuration:.2 animations:^{
                    dest.origin.y = offset - (sign * 4);
                    outline.frame = dest;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 animations:^{
                        dest.origin.y = offset + (sign * 1);
                        outline.frame = dest;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.1 animations:^{
                            dest.origin.y = offset + (sign * -1);
                            outline.frame = dest;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:.2 animations:^{
                                dest.origin.y = offset;
                                outline.frame = dest;
                            }];
                        }];
                    }];
                }];
                
            }];
            
            
            
            runningOffset += outline.frame.size.height + 20;
            
        }
        
    }];
}

@end
