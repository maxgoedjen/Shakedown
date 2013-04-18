//
//  SHDMultipleSelectionCell.h
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHDMultipleSelectionCell : UIView

@property (nonatomic) NSString *text;
@property (nonatomic) NSArray *options;

@end

@interface SHDMultipleSelectionOptionsView : UIView

- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton options:(NSArray *)options;

@end