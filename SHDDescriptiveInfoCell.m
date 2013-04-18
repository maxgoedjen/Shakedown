//
//  SHDDescriptiveInfoCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDDescriptiveInfoCell.h"
#import "SHDConstants.h"

@interface SHDDescriptiveInfoCell ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *valueLabel;

@end

@implementation SHDDescriptiveInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    CGRect insetBounds = CGRectInset(self.bounds, 18, 16);
    CGRect titleBounds = insetBounds;
    titleBounds.size.width = 140;
    self.titleLabel = [[UILabel alloc] initWithFrame:titleBounds];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kSHDTextNormalColor;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = UITextAlignmentRight;
    [self addSubview:self.titleLabel];

    CGRect valueBounds = insetBounds;
    valueBounds.origin.x = 160;
    valueBounds.size.width = 140;
    self.valueLabel = [[UILabel alloc] initWithFrame:titleBounds];
    self.valueLabel.font = [UIFont systemFontOfSize:15];
    self.valueLabel.textColor = kSHDTextNormalColor;
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.numberOfLines = 0;
    [self addSubview:self.valueLabel];
}

- (void)setDictionary:(NSDictionary *)dictionary {
    NSMutableString *titleString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    for (NSString *key in dictionary) {
        [titleString appendFormat:@"%@\n", key];
        [valueString appendFormat:@"%@\n", [dictionary objectForKey:key]];
    }
    self.titleLabel.text = titleString;
    self.valueLabel.text = valueString;
}

@end
