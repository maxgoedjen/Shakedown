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

@interface SHDMultipleSelectionCell () <SHDMultipleSelectorDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) SHDButton *displayButton;

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
    self.displayButton = [SHDButton buttonWithSHDType:SHDButtonTypeOutline];
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

- (NSString *)text {
    return self.displayButton.titleLabel.text;
}

- (void)setOptions:(NSArray *)options {
    _options = options;
    [self.displayButton setTitle:[self.options objectAtIndex:0] forState:UIControlStateNormal];
    [self.displayButton sizeToFit];
}

- (void)_showOptions {
    UIView *superView = self.superview;
    [superView endEditing:YES];
    SHDMultipleSelectionOptionsView *view = [[SHDMultipleSelectionOptionsView alloc] initWithFrame:superView.bounds sourceButton:self.displayButton options:self.options];
    view.delegate = self;
    [superView addSubview:view];
}

- (void)selectedItemAtIndex:(NSInteger)index {
    [self.displayButton setTitle:[self.options objectAtIndex:index] forState:UIControlStateNormal];
    [self.displayButton sizeToFit];
}

@end

@interface SHDMultipleSelectionOptionsView ()

@property (nonatomic, strong) UIButton *sourceButton;
@property (nonatomic) CGRect sourceFrame;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *optionButtons;

@end

@implementation SHDMultipleSelectionOptionsView


- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton options:(NSArray *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _sourceButton = sourceButton;
        _options = options;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)didMoveToSuperview {
    self.alpha = 0;
    self.backgroundColor = kSHDOverlayBackgroundColor;
    
    self.sourceFrame = [self convertRect:self.sourceButton.frame fromView:self.sourceButton.superview];
    
    __block CGFloat runningOffset = 20;
    
    NSMutableArray *optionButtons = [NSMutableArray array];
    
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        int count = 0;
        for (NSString *option in self.options) {
            
            SHDButton *outline = [SHDButton buttonWithSHDType:SHDButtonTypeOutline];
            outline.tag = count;
            [outline addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
            outline.frame = self.sourceFrame;
            [self addSubview:outline];
            [optionButtons addObject:outline];
            [outline setTitle:option forState:UIControlStateNormal];
            [outline sizeToFit];
            CGRect centered = outline.frame;
            centered.origin.x -= (centered.size.width - self.sourceFrame.size.width) / 2;
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
    self.optionButtons = optionButtons;
}

- (void)selectedButton:(UIButton *)sender {
    [UIView animateWithDuration:.2 animations:^{
        for (UIButton *button in self.optionButtons) {
            button.frame = self.sourceFrame;
            button.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        [self.delegate selectedItemAtIndex:sender.tag];
        [UIView animateWithDuration:.5 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

@end
