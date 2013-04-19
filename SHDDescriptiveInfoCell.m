//
//  SHDDescriptiveInfoCell.m
//  Shakedown
//
//  Created by Max Goedjen on 4/18/13.
//  Copyright (c) 2013 Max Goedjen. All rights reserved.
//

#import "SHDDescriptiveInfoCell.h"
#import "SHDConstants.h"

@interface SHDDescriptiveInfoCellTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation SHDDescriptiveInfoCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 15)];
        _keyLabel.font = [UIFont boldSystemFontOfSize:12];
        _keyLabel.textColor = kSHDTextNormalColor;
        _keyLabel.textAlignment = UITextAlignmentRight;
        _keyLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_keyLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 3, 190, 15)];
        _valueLabel.font = [UIFont boldSystemFontOfSize:12];
        _valueLabel.textColor = kSHDTextHighlightColor;
        _valueLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_valueLabel];
        
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

@end

@interface SHDDescriptiveInfoCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SHDDescriptiveInfoCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)dictionary {
    _dictionary = dictionary;
    [self.tableView reloadData];
}


#pragma mark - Table View

- (NSString *)_keyForRow:(NSInteger)row {
    NSArray *keys = [[self.dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 uppercaseString] compare:[obj2 uppercaseString]];
    }];
    
    return [keys objectAtIndex:row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dictionary count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 16.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    SHDDescriptiveInfoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHDDescriptiveInfoCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.keyLabel.text =  [[self _keyForRow:indexPath.row] uppercaseString];
        cell.valueLabel.text = [[self.dictionary objectForKey:[self _keyForRow:indexPath.row]] uppercaseString];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
