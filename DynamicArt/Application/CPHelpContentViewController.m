//
//  CPHelpContentViewController.m
//  DynamicArt
//
//  Created by wangyw on 9/16/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPHelpContentViewController.h"

@interface CPHelpContentViewController ()

@property (strong, nonatomic) NSArray *sectionTitles;

@property (strong, nonatomic) NSArray *sectionHtmls;

@property (strong, nonatomic) NSArray *bookmarkTitles;

@property (strong, nonatomic) NSArray *bookmarks;

@end

@implementation CPHelpContentViewController

#pragma mark - property methods

- (NSArray *)sectionTitles {
    if (!_sectionTitles) {
        _sectionTitles = [[NSArray alloc] initWithObjects:@"Introduction", @"My First Program", @"Turtle Spire", @"List of Blocks", @"Examples", nil];
    }
    return _sectionTitles;
}

- (NSArray *)sectionHtmls {
    if (!_sectionHtmls) {
        _sectionHtmls = [[NSArray alloc] initWithObjects:@"help[index].html", @"help[first].html", @"help[spire].html", @"help[blocks].html", @"help[examples].html", nil];
    }
    return _sectionHtmls;
}

- (NSArray *)bookmarkTitles {
    if (!_bookmarkTitles) {
        NSArray *introductionBookmarkTitles = [[NSArray alloc] initWithObjects:@"Introduction", @"Features", @"Example", nil];
        NSArray *firstBookmarkTitles = [[NSArray alloc] initWithObjects:@"Create My First Board", @"Compose My First Program", @"Run It!", @"Use Variables", nil];
        NSArray *spireBookmarkTitles = [[NSArray alloc] initWithObjects:@"My Second Program", @"Run It!", @"Color and Width", @"Gradient Color", @"Quiz", nil];
        NSArray *blocksBookmarkTitles = [[NSArray alloc] initWithObjects:@"Control", @"Interaction", @"Turtle", @"Paint", @"Utility", @"Expression", @"Variable", nil];
        NSArray *examplesBookmarkTitles = [[NSArray alloc] initWithObjects:@"Examples", nil];
        _bookmarkTitles = [[NSArray alloc] initWithObjects:introductionBookmarkTitles, firstBookmarkTitles, spireBookmarkTitles, blocksBookmarkTitles, examplesBookmarkTitles, nil];
    }
    return _bookmarkTitles;
}

- (NSArray *)bookmarks {
    if (!_bookmarks) {
        NSArray *introductionBookmarks = [[NSArray alloc] initWithObjects:@"", @"features", @"example", nil];
        NSArray *firstBookmarks = [[NSArray alloc] initWithObjects:@"", @"compose", @"run", @"variables", nil];
        NSArray *spireBookmarks = [[NSArray alloc] initWithObjects:@"", @"run", @"color", @"gradient", @"quiz", nil];
        NSArray *blocksBookmarks = [[NSArray alloc] initWithObjects:@"", @"interaction", @"turtle", @"paint", @"utility", @"expression", @"variable", nil];
        NSArray *examplesBookmarks = [[NSArray alloc] initWithObjects:@"", nil];
        _bookmarks = [[NSArray alloc] initWithObjects:introductionBookmarks, firstBookmarks, spireBookmarks, blocksBookmarks, examplesBookmarks, nil];
    }
    return _bookmarks;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *bookmarkTitlesOfThisSection = [self.bookmarkTitles objectAtIndex:section];
    return bookmarkTitlesOfThisSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CPHelpContentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *bookmarkTitlesOfThisSection = [self.bookmarkTitles objectAtIndex:indexPath.section];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%d. %@", (int)indexPath.row + 1, [bookmarkTitlesOfThisSection objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *bookmarksOfThisSection = [self.bookmarks objectAtIndex:indexPath.section];
    NSString *htmlPath = [[NSString alloc] initWithFormat:@"%@#%@", [self.sectionHtmls objectAtIndex:indexPath.section], [bookmarksOfThisSection objectAtIndex:indexPath.row]];
    [self.delegate helpContentViewController:self sectionTitle:[self.sectionTitles objectAtIndex:indexPath.section] selectedHtml:htmlPath];
    [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
}

@end
