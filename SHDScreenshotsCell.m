//
//  SHDScreenshotsCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/17/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDScreenshotsCell.h"

@interface SHDScreenshotsCell ()

@property (nonatomic, strong) NSArray *screenshotViews;

@end

@implementation SHDScreenshotsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.bounds, 0, 10)];
        _scrollView.contentInset = UIEdgeInsetsMake(-3, (self.frame.size.width/2) - 20, 0, 0);
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)setScreenshots:(NSArray *)screenshots {
    for (UIView *view in self.screenshotViews) {
        [view removeFromSuperview];
    }
    NSMutableArray *tmpViews = [NSMutableArray arrayWithCapacity:[screenshots count]];
    CGFloat height = self.scrollView.frame.size.height;
    CGFloat width = 0;
    if ([screenshots count]) {
        UIImage *img = [screenshots objectAtIndex:0];
        width = height * (img.size.width / img.size.height);
    }
    for (UIImage *img in screenshots) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image = img;
        [self.scrollView addSubview:imageView];
        [tmpViews addObject:imageView];
    }
    self.screenshotViews = tmpViews;
}

@end
