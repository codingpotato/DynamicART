//
//  CPAutoCompleteViewController.m
//  DynamicArt
//
//  Created by wangyw on 4/22/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPAutoCompleteViewController.h"

#import "CPInputField.h"
#import "CPInputFieldManager.h"

@implementation CPAutoCompleteViewController

- (id)init {
    self = [super init];
    if (self) {
        NSAssert([CPInputFieldManager defaultInputFieldManager].currentInputField, @"");
        self.preferredContentSize = [CPInputFieldManager defaultInputFieldManager].currentInputField.contentSizeOfAutoCompleteView;
    }
    return self;
}

- (void)setContentSize {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - UITableViewDataSource implement

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert([CPInputFieldManager defaultInputFieldManager].currentInputField, @"");
    return [CPInputFieldManager defaultInputFieldManager].currentInputField.numberOfRowsForAutoCompleteView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CPAutoCompleteTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.detailTextLabel.text = @"";
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.cornerRadius = 0.0;
    cell.contentView.layer.shadowColor = [[UIColor clearColor] CGColor];
    cell.contentView.layer.shadowOffset = CGSizeZero;
    cell.contentView.layer.shadowOpacity = 0.0;
    
    /*
     * ios5 UITextField setText will call textChanged action, ios6 will not
     * so in some kide of input field, autoCompleteViewDidSelectRowAtIndex: -> textFieldDidChanged: -> reloadData
     * then currentInputField is nil when comes here
     */
    if ([CPInputFieldManager defaultInputFieldManager].currentInputField) {
        [[CPInputFieldManager defaultInputFieldManager].currentInputField prepareAutoCompleteViewCell:cell atIndex:(int)indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate implement

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert([CPInputFieldManager defaultInputFieldManager].currentInputField, @"");
    [[CPInputFieldManager defaultInputFieldManager].currentInputField autoCompleteViewDidSelectRowAtIndex:(int)indexPath.row];
}

@end
