//
//  SHDListCell.h
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDListCell : UIView

@property (nonatomic, strong) NSArray *items;

@end

@interface SHDListCellEditor : UIView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sourceButton;

- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton items:(NSMutableArray *)items;

@end
