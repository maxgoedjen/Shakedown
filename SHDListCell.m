//
//  SHDListCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDListCell.h"
#import "SHDConstants.h"
#import "SHDButton.h"

@interface SHDListCell ()

@property (nonatomic, strong) NSMutableArray *internalItems;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) SHDButton *displayButton;

@end

@implementation SHDListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _internalItems = [NSMutableArray array];
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
    self.displayButton.frame = CGRectMake(10, 10, 0, 0);
    [self.displayButton addTarget:self action:@selector(_showList) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.displayButton];
    [self setItems:@[]];
}

- (void)_updateLabels {
    self.label.text = @"to reproduce";
    if ([self.internalItems count]) {
        [self.displayButton setTitle:[NSString stringWithFormat:@"%i steps", [self.internalItems count]] forState:UIControlStateNormal];
    } else {
        [self.displayButton setTitle:@"No documented steps" forState:UIControlStateNormal];
    }
    [self.displayButton sizeToFit];
    CGRect displayFrame = self.displayButton.frame;
    [self.label sizeToFit];
    CGRect labelFrame = displayFrame;
    labelFrame.origin.x = displayFrame.size.width + displayFrame.origin.x + 10;
    labelFrame.size.width = self.frame.size.width - (CGRectGetMaxX(displayFrame) + 20);
    self.label.frame = labelFrame;
}

- (void)_showList {
    UIView *superView = self.superview;
    [superView endEditing:YES];
    SHDListCellEditor *view = [[SHDListCellEditor alloc] initWithFrame:superView.bounds sourceButton:self.displayButton items:self.internalItems];
    [superView addSubview:view];
}

#pragma mark - Items

- (NSArray *)items {
    return [NSArray arrayWithArray:self.items];
}

- (void)setItems:(NSArray *)items {
    [self.internalItems removeAllObjects];
    [self.internalItems addObjectsFromArray:items];
    [self _updateLabels];
}

@end

@interface SHDListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation SHDListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 30, 30)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textColor = kSHDTextHighlightColor;
        _numberLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _numberLabel.textAlignment = UITextAlignmentRight;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(40, 9, 260, 30)];
        _textField.font = [UIFont systemFontOfSize:14.0];
        _textField.textColor = kSHDTextHighlightColor;
        [self addSubview:_textField];
        
        [self addSubview:_numberLabel];
    }
    return self;
}

@end

@implementation SHDListCellEditor

- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton items:(NSMutableArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kSHDOverlayBackgroundColor;

        _sourceButton = sourceButton;
        _items = items;
        CGRect tableRect = self.bounds;
        tableRect.size.height -= 216;
        _tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = kSHDTextHighlightColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)didMoveToSuperview {
    SHDListTableViewCell *cell = (SHDListTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.textField becomeFirstResponder];
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
            [self.items removeObjectAtIndex:textField.tag];
            [self.tableView reloadData];
        }
    } else {
        if ([self.tableView numberOfRowsInSection:0] > textField.tag + 1) {
            [self.items replaceObjectAtIndex:textField.tag withObject:textField.text];
        } else {
            [self.items addObject:textField.text];
        }
        [self.tableView reloadData];
        NSIndexPath *next = [NSIndexPath indexPathForRow:textField.tag + 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:next atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        SHDListTableViewCell *cell = (SHDListTableViewCell *)[self.tableView cellForRowAtIndexPath:next];
        [cell.textField becomeFirstResponder];
    }
}
@end
