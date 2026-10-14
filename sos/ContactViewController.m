//
//  ContactViewController.m
//  sos
//
//  Created by Eastern on 10/14/15.
//  Copyright © 2015 Nguyen Hoang. All rights reserved.
//

#import "ContactViewController.h"
#import "APAddressBook.h"
#import "APContact.h"

@interface ContactViewController ()<THContactPickerDelegate>
@property (nonatomic, strong) NSMutableArray *privateSelectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;

@end

NSMutableArray *all_contact;
@implementation ContactViewController

static const CGFloat kPickerViewHeight = 150.0;

NSString *THContactPickerContactCellReuseID = @"THContactPickerContactCell";


@synthesize contactPickerView = _contactPickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeBottom|UIRectEdgeLeft|UIRectEdgeRight];
    }
    
    // Initialize and add Contact Picker View
    self.contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kPickerViewHeight)];
    self.contactPickerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    self.contactPickerView.delegate = self;
    [self.contactPickerView setPlaceholderLabelText:@"A chi vuoi inviare l'sms?"];
    [self.contactPickerView setPromptLabelText:@"Per:"];
    //[self.contactPickerView setLimitToOne:YES];
    [self.view addSubview:self.contactPickerView];
    
    CALayer *layer = [self.contactPickerView layer];
    [layer setShadowColor:[[UIColor colorWithRed:225.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1] CGColor]];
    [layer setShadowOffset:CGSizeMake(0, 2)];
    [layer setShadowOpacity:1];
    [layer setShadowRadius:1.0f];
    
    // Fill the rest of the view with the table view
    CGRect tableFrame = CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];
}

- (void)viewDidLayoutSubviews {
    [self adjustTableFrame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"navigation"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    /*Register for keyboard notifications*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self getPersonOutOfAddressBook];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)selectedContacts{
    return [self.privateSelectedContacts copy];
}

#pragma mark - Publick properties

- (NSArray *)filteredContacts {
    if (!_filteredContacts) {
        _filteredContacts = _contacts;
    }
    return _filteredContacts;
}

- (void)adjustTableViewInsetTop:(CGFloat)topInset bottom:(CGFloat)bottomInset {
    self.tableView.contentInset = UIEdgeInsetsMake(topInset,
                                                   self.tableView.contentInset.left,
                                                   bottomInset,
                                                   self.tableView.contentInset.right);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (NSInteger)selectedCount {
    return self.privateSelectedContacts.count;
}

#pragma mark - Private properties

- (NSMutableArray *)privateSelectedContacts {
    if (!_privateSelectedContacts) {
        _privateSelectedContacts = [NSMutableArray array];
    }
    return _privateSelectedContacts;
}

#pragma mark - Private methods

- (void)adjustTableFrame {
    CGFloat yOffset = self.contactPickerView.frame.origin.y + self.contactPickerView.frame.size.height;
    
    CGRect tableFrame = CGRectMake(0, yOffset, self.view.frame.size.width, self.view.frame.size.height - yOffset);
    self.tableView.frame = tableFrame;
}

- (void)adjustTableViewInsetTop:(CGFloat)topInset {
    [self adjustTableViewInsetTop:topInset bottom:self.tableView.contentInset.bottom];
}

- (void)adjustTableViewInsetBottom:(CGFloat)bottomInset {
    [self adjustTableViewInsetTop:self.tableView.contentInset.top bottom:bottomInset];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self titleForRowAtIndexPath:indexPath];
}

- (NSPredicate *)newFilteringPredicateWithText:(NSString *) text {
    return [NSPredicate predicateWithFormat:@"self contains[cd] %@", text];
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.filteredContacts objectAtIndex:indexPath.row];
}

- (void) didChangeSelectedItems {
    
}

#pragma mark - UITableView Delegate and Datasource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THContactPickerContactCellReuseID];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:THContactPickerContactCellReuseID];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    if ([self.privateSelectedContacts containsObject:[self.filteredContacts objectAtIndex:indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    id contact = [self.filteredContacts objectAtIndex:indexPath.row];
    NSString *contactTilte = [self titleForRowAtIndexPath:indexPath];
    
    if ([self.privateSelectedContacts containsObject:contact]){ // contact is already selected so remove it from ContactPickerView
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.privateSelectedContacts removeObject:contact];
        [self.contactPickerView removeContact:contact];
    } else {
        // Contact has not been selected, add it to THContactPickerView
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.privateSelectedContacts addObject:contact];
        [self.contactPickerView addContact:contact withName:contactTilte];
    }
    
    self.filteredContacts = self.contacts;
    [self didChangeSelectedItems];
    [self.tableView reloadData];
}

#pragma mark - THContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    } else {
        NSPredicate *predicate = [self newFilteringPredicateWithText:textViewText];
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
    CGRect frame = self.tableView.frame;
    frame.origin.y = contactPickerView.frame.size.height + contactPickerView.frame.origin.y;
    self.tableView.frame = frame;
}

- (void)contactPickerDidRemoveContact:(id)contact {
    [self.privateSelectedContacts removeObject:contact];
    
    NSInteger index = [self.contacts indexOfObject:contact];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self didChangeSelectedItems];
}

- (BOOL)contactPickerTextFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0){
        NSString *contact = [[NSString alloc] initWithString:textField.text];
        [self.privateSelectedContacts addObject:contact];
        [self.contactPickerView addContact:contact withName:textField.text];
    }
    return YES;
}

#pragma  mark - NSNotificationCenter

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    [self adjustTableViewInsetBottom:self.tableView.frame.origin.y + self.tableView.frame.size.height - kbRect.origin.y];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    [self adjustTableViewInsetBottom:self.tableView.frame.origin.y + self.tableView.frame.size.height - kbRect.origin.y];
}

- (IBAction)close:(id)sender {
    
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    [user setObject:self.privateSelectedContacts forKey:@"CONTACT"];
    [user synchronize];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getPersonOutOfAddressBook
{
    all_contact = [[NSMutableArray alloc] init];

    APAddressBook *addressBook = [[APAddressBook alloc] init];
    // don't forget to show some activity
    [addressBook loadContacts:^(NSArray <APContact *> *contacts, NSError *error)
    {
        // hide activity
        if (!error)
        {
            for (int i = 0; i < [contacts count]; i++) {
                
                APContact *person = contacts[i];
                NSString *name = [NSString stringWithFormat:@"%@ %@", person.name.lastName?:@"", person.name.firstName?:@""];
                name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                if (person.phones.count > 0)
                {
                    for (APPhone *phone in person.phones)
                    {
                        if (phone.number) {
                            NSString *data = [NSString stringWithFormat:@"%@ - %@",name, phone.number];
                            [all_contact addObject:data];
                        }
                    }
                }
            }
            self.contacts = all_contact;
            
            NSUserDefaults *user = [[NSUserDefaults alloc] init];
            NSArray *ucontact = [user arrayForKey:@"CONTACT"];
            
            for(int i = 0; i < [ucontact count] ; i++){
                id contact = ucontact[i];
                [self.privateSelectedContacts addObject:ucontact[i]];
                [self.contactPickerView addContact:ucontact[i] withName:contact];
            }
           
            
            [self.tableView reloadData];
        }
    }];
}

@end
