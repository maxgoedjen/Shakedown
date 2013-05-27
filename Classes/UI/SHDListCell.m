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

@interface SHDListCell () <SHDListCellEditorDelegate>

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
        [self.displayButton setTitle:[NSString stringWithFormat:@"%i step%@", [self.internalItems count], ([self.internalItems count] == 1 ? @"" : @"s")] forState:UIControlStateNormal];
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
    view.delegate = self;
    [superView addSubview:view];
}

- (void)editorModifiedItems:(NSArray *)items {
    self.items = items;
}

#pragma mark - Items

- (NSArray *)items {
    return [NSArray arrayWithArray:self.internalItems];
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

@interface SHDListCellEditor ()

@property (nonatomic, strong) UIView *doneBar;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation SHDListCellEditor

- (id)initWithFrame:(CGRect)frame sourceButton:(UIButton *)sourceButton items:(NSArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kSHDOverlayBackgroundColor;

        _sourceButton = sourceButton;
        _items = [NSMutableArray arrayWithArray:items];
        CGRect tableRect = self.bounds;
        tableRect.size.height -= 266;
        _tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = kSHDTextHighlightColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)didMoveToSuperview {
    self.alpha = 0;
    self.backgroundColor = kSHDOverlayBackgroundColor;
    [self.tableView reloadData];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidHideNotification object:nil];

    CGFloat originalY = self.tableView.frame.origin.y;
    __block CGRect dest = self.tableView.frame;
    dest.origin.y = self.frame.size.height;
    self.tableView.frame = dest;
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            [UIView animateWithDuration:.2 animations:^{
                dest.origin.y = originalY - 4;
                self.tableView.frame = dest;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 animations:^{
                    dest.origin.y = originalY + 1;
                    self.tableView.frame = dest;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.1 animations:^{
                        dest.origin.y = originalY - 1;
                        self.tableView.frame = dest;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 animations:^{
                            dest.origin.y = originalY;
                            self.tableView.frame = dest;
                        }];
                        NSIndexPath *last = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
                        [self.tableView scrollToRowAtIndexPath:last atScrollPosition:UITableViewScrollPositionNone animated:YES];
                        SHDListTableViewCell *cell = (SHDListTableViewCell *)[self.tableView cellForRowAtIndexPath:last];
                        [cell.textField becomeFirstResponder];
                        
                        __block CGRect doneFrame = self.bounds;
                        doneFrame.size.height = 50;
                        doneFrame.origin.y = self.bounds.size.height;
                        self.doneBar = [[UIView alloc] initWithFrame:doneFrame];
                        UIButton *doneButton = [SHDButton buttonWithSHDType:SHDButtonTypeOutline];
                        [doneButton addTarget:self action:@selector(_done:) forControlEvents:UIControlEventTouchUpInside];
                        [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
                        [self.doneBar addSubview:doneButton];
                        doneButton.frame = CGRectMake(10, 10, 0, 0);
                        [doneButton sizeToFit];
                        self.doneBar.backgroundColor = kSHDOverlayBackgroundColor;
                        [self addSubview:self.doneBar];

                    }];
                }];
            }];
            
        }];

    }];
    
}

- (void)_done:(id)sender {
    [self endEditing:YES];
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = self.tableView.frame;
        frame.origin.y = self.frame.size.height;
        CGRect doneFrame = self.doneBar.frame;
        doneFrame.origin.y = self.frame.size.height;
        [UIView animateWithDuration:.2 animations:^{
            self.doneBar.frame = doneFrame;
            self.tableView.frame = frame;
            self.tableView.alpha = 0;
        }];
    } completion:^(BOOL finished) {
        [self.delegate editorModifiedItems:self.items];
        [UIView animateWithDuration:.5 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void)keyboardFrameChanged:(NSNotification *)note {
    CGRect keyboardFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect translated = [self convertRect:keyboardFrame fromView:self.window];
    CGRect doneFrame = self.doneBar.frame;
    doneFrame.origin.y = translated.origin.y - doneFrame.size.height;
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = 0;
    tableFrame.size.height = self.frame.size.height - (doneFrame.size.height + (self.frame.size.height - translated.origin.y));
    [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
        self.doneBar.frame = doneFrame;
        self.tableView.frame = tableFrame;
    } completion:nil];
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
        if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
            CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height + 40);
            [self.tableView setContentOffset:offset animated:YES];
        }
        SHDListTableViewCell *cell = (SHDListTableViewCell *)[self.tableView cellForRowAtIndexPath:next];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        [cell.textField becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidHideNotification object:nil];

    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
