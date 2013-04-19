//
//  SHDListCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDListCell.h"
#import "SHDConstants.h"

@interface SHDListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation SHDListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kSHDBackgroundAlternateColor;
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 30, 30)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textColor = kSHDTextFadedColor;
        _numberLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _numberLabel.textAlignment = UITextAlignmentRight;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 9, 260, 30)];
        _textField.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_textField];
        
        [self addSubview:_numberLabel];
    }
    return self;
}

@end

@interface SHDListCell () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *internalItems;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SHDListCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kSHDBackgroundAlternateColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = kSHDTextFadedColor;
        _internalItems = [NSMutableArray array];
        [self setItems:@[@"adsf", @"jkl;"]];
    }
    return self;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    SHDListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHDListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.numberLabel.text = [NSString stringWithFormat:@"%i", indexPath.row + 1];
    if (indexPath.row < [self.items count]) {
        cell.textField.text = [self.items objectAtIndex:indexPath.row];
    } else {
        cell.textField.text = @"";
    }
    cell.textField.tag = indexPath.row;
    cell.textField.delegate = self;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""] == YES) {
        if ([self.tableView numberOfRowsInSection:0] > textField.tag + 1) {
            [self.internalItems removeObjectAtIndex:textField.tag];
            [self.tableView reloadData];
        }
    } else {
        if ([self.tableView numberOfRowsInSection:0] > textField.tag + 1) {
            [self.internalItems replaceObjectAtIndex:textField.tag withObject:textField.text];
        } else {
            [self.internalItems addObject:textField.text];
        }
        [self.tableView reloadData];
        NSIndexPath *next = [NSIndexPath indexPathForRow:textField.tag + 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:next atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        SHDListTableViewCell *cell = (SHDListTableViewCell *)[self.tableView cellForRowAtIndexPath:next];
        [cell.textField becomeFirstResponder];
    }
}

#pragma mark - Items

- (NSArray *)items {
    return [NSArray arrayWithArray:self.internalItems];
}

- (void)setItems:(NSArray *)items {
    [self.internalItems removeAllObjects];
    [self.internalItems addObjectsFromArray:items];
}

@end
