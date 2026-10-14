//
//  ContactViewController.h
//  sos
//
//  Created by Eastern on 10/14/15.
//  Copyright © 2015 Nguyen Hoang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THContactPickerView.h"
#import <AddressBook/AddressBook.h> 

@interface ContactViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) THContactPickerView *contactPickerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, readonly) NSArray *selectedContacts;
@property (nonatomic) NSInteger selectedCount;
@property (nonatomic, readonly) NSArray *filteredContacts;

- (NSPredicate *)newFilteringPredicateWithText:(NSString *) text;
- (void) didChangeSelectedItems;
- (NSString *) titleForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
