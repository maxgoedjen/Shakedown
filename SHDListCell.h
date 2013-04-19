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

@protocol SHDListCellEditorDelegate <NSObject>

- (void)editorModifiedItems:(NSArray *)items;

@end

@interface SHDListCellEditor : UIView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *sourceButton;
@property (nonatomic, weak) id <SHDListCellEditorDelegate> delegate;

- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton items:(NSArray *)items;

@end
