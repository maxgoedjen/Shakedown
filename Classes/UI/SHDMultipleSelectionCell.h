//
//  SHDMultipleSelectionCell.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHDMultipleSelectionCell : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *options;

@end

@protocol SHDMultipleSelectorDelegate <NSObject>

- (void)selectedItemAtIndex:(NSInteger)index;

@end

@interface SHDMultipleSelectionOptionsView : UIView

@property (nonatomic, weak) id <SHDMultipleSelectorDelegate> delegate;

- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton options:(NSArray *)options;

@end