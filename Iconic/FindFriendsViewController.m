//
//  FindFriendsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/29/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "FindFriendsViewController.h"
#import "Parse/Parse.h"
//#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "AppDelegate.h"
#import "Cache.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "PlayerProfileViewController.h"
#import "Amplitude.h"


typedef enum {
    FindFriendsFollowingNone = 0,    // User isn't following anybody in Friends list
    FindFriendsFollowingAll,         // User is following all Friends
    FindFriendsFollowingSome         // User is following some of their Friends
} FindFriendsFollowStatus;

@interface FindFriendsViewController ()



@property (nonatomic, strong) NSString *selectedEmailAddress;
@property (nonatomic, strong) NSMutableDictionary *outstandingFollowQueries;
@property (nonatomic, strong) NSMutableDictionary *outstandingCountQueries;
@property (nonatomic, assign) FindFriendsFollowStatus followStatus;
@end

static NSUInteger const kCellFollowTag = 2;
static NSUInteger const kCellNameLabelTag = 3;
static NSUInteger const kCellAvatarTag = 4;
static NSUInteger const kCellActivityNumLabelTag = 5;


@implementation FindFriendsViewController

@synthesize followStatus;
@synthesize selectedEmailAddress;
@synthesize outstandingFollowQueries;
@synthesize outstandingCountQueries;



-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // Custom the table
        
        self.outstandingFollowQueries = [NSMutableDictionary dictionary];
        self.outstandingCountQueries = [NSMutableDictionary dictionary];
        
        self.selectedEmailAddress = @"";
        
        // The className to query on
        //self.parseClassName = @"Foo";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 15;
        
        // Used to determine Follow/Unfollow All button status
        self.followStatus = FindFriendsFollowingSome;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    BOOL linkedWithFacebook = [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
    
    if(linkedWithFacebook)
    {
//        NSLog(@"Linked with Facebook");
        self.facebookLogIn.hidden = YES;
        self.inviteFacebookFriends.hidden = NO;
       
    }
    else
    {
//         NSLog(@"Not linked with Facebook");
        self.facebookLogIn.hidden = NO;
        self.inviteFacebookFriends.hidden = YES;
    }
    
//    ACAccountStore *accountStore;
//    ACAccountType *accountTypeFB;
//    if ((accountStore = [[ACAccountStore alloc] init]) &&
//        (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
//        
//        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
//        id account;
//        if (fbAccounts && [fbAccounts count] > 0 &&
//            (account = [fbAccounts objectAtIndex:0])){
//            
//            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
//                //we don't actually need to inspect renewResult or error.
//                if (error){
//                    
//                }
//            }];
//        }
//    }
    
   
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [FindFriendsCell heightForCell];
    } else {
        return 44.0f;
    }
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}




 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     
    
     // Use cached facebook friend ids
     NSArray *facebookFriends = [[Cache sharedCache] facebookFriends];
     
     // Query for all friends you have on facebook and who are using the app
     PFQuery *friendsQuery = [PFUser query];
//     [friendsQuery whereKey:kUserFacebookIDKey containedIn:facebookFriends];
     
     // Query for all auto-follow accounts
     NSMutableArray *autoFollowAccountFacebookIds = [[NSMutableArray alloc] initWithArray:kAutoFollowAccountFacebookIds];
     [autoFollowAccountFacebookIds removeObject:[[PFUser currentUser] objectForKey:kUserFacebookIDKey]];
     PFQuery *autoFollowedUsersQuery = [PFUser query];
     [autoFollowedUsersQuery whereKey:kUserFacebookIDKey containedIn:autoFollowAccountFacebookIds];
     
     // Query for all users to test follow
     PFQuery *allusers = [PFUser query];
     
     [allusers whereKeyExists:kUsername];
     
     
     PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:friendsQuery, autoFollowedUsersQuery,allusers, nil]];
     query.cachePolicy = kPFCachePolicyNetworkOnly;
     
     if (self.objects.count == 0) {
         query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
     
     //[query orderByAscending:kUserDisplayNameKey];
     
     //sort by the time created so that we can test new accounts
     [query orderByDescending:@"createdAt"];
 
     // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
         query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
 
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
         query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }


     return query;
    }

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    PFQuery *isFollowingQuery = [PFQuery queryWithClassName:kPlayerActionClassKey];
    [isFollowingQuery whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
    [isFollowingQuery whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeFollow];
    [isFollowingQuery whereKey:kPlayerActionToUserKey containedIn:self.objects];
    [isFollowingQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
    
    [isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (number == self.objects.count) {
                self.followStatus = FindFriendsFollowingAll;
                //[self configureUnfollowAllButton];
                for (PFUser *user in self.objects) {
                    [[Cache sharedCache] setFollowStatus:YES user:user];
                }
            } else if (number == 0) {
                self.followStatus = FindFriendsFollowingNone;
                //[self configureFollowAllButton];
                for (PFUser *user in self.objects) {
                    [[Cache sharedCache] setFollowStatus:NO user:user];
                }
            } else {
                self.followStatus = FindFriendsFollowingSome;
                //[self configureFollowAllButton];
            }
        }
        
        if (self.objects.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }];
    
    if (self.objects.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }

    
}

 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *FriendCellIdentifier = @"FriendCell";
 
 FindFriendsCell *cell = (FindFriendsCell *)[tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
 if (cell == nil) {
 cell = [[FindFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellIdentifier];
 }
 
 // Configure the cell
 
     
     [cell setUser:(PFUser*)object];
     
     //[cell.activityLabel setText:@"0 activities"];


     
     NSDictionary *attributes = [[Cache sharedCache] attributesForUser:(PFUser *)object];
     
     if (attributes) {
         // set them now
         NSString *pluralizedActivity;
         NSNumber *number = [[Cache sharedCache] activityCountForUser:(PFUser *)object];
         if ([number intValue] == 1) {
             pluralizedActivity = @"activity";
         } else {
             pluralizedActivity = @"activities";
         }
         [cell.activityLabel setText:[NSString stringWithFormat:@"%@ %@", number, pluralizedActivity]];
     } else {
         @synchronized(self) {
             NSNumber *outstandingCountQueryStatus = [self.outstandingCountQueries objectForKey:indexPath];
             if (!outstandingCountQueryStatus) {
                 [self.outstandingCountQueries setObject:[NSNumber numberWithBool:YES] forKey:indexPath];
                 PFQuery *activityNumQuery = [PFQuery queryWithClassName:kPlayerActionClassKey];
                 [activityNumQuery whereKey:kActivityUserKey equalTo:object];
                 [activityNumQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
                 [activityNumQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                     @synchronized(self) {
                         [[Cache sharedCache] setActivityCount:[NSNumber numberWithInt:number] user:(PFUser *)object];
                         [self.outstandingCountQueries removeObjectForKey:indexPath];
                     }
                     FindFriendsCell *actualCell = (FindFriendsCell*)[tableView cellForRowAtIndexPath:indexPath];
                     NSString *pluralizedActivity;
                     if (number == 1) {
                         pluralizedActivity = @"activity";
                     } else {
                         pluralizedActivity = @"activities";
                     }
                     [actualCell.activityLabel setText:[NSString stringWithFormat:@"%d %@", number, pluralizedActivity]];
                     
                 }];
             };
         }
     }

     
     cell.followButton.selected = NO;
     cell.tag = indexPath.row;

     
     
     if (self.followStatus == FindFriendsFollowingSome) {
         if (attributes) {
             [cell.followButton setSelected:[[Cache sharedCache] followStatusForUser:(PFUser *)object]];
         } else {
             @synchronized(self) {
                 NSNumber *outstandingQuery = [self.outstandingFollowQueries objectForKey:indexPath];
                 if (!outstandingQuery) {
                     [self.outstandingFollowQueries setObject:[NSNumber numberWithBool:YES] forKey:indexPath];
                     PFQuery *isFollowingQuery = [PFQuery queryWithClassName:kPlayerActionClassKey];
                     [isFollowingQuery whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
                     [isFollowingQuery whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeFollow];
                     [isFollowingQuery whereKey:kPlayerActionToUserKey equalTo:object];
                     [isFollowingQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
                     
                     [isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                         @synchronized(self) {
                             [self.outstandingFollowQueries removeObjectForKey:indexPath];
                             [[Cache sharedCache] setFollowStatus:(!error && number > 0) user:(PFUser *)object];
                         }
                         if (cell.tag == indexPath.row) {
                             [cell.followButton setSelected:(!error && number > 0)];
                         }
                     }];
                 }
             }
         }
     } else {
         [cell.followButton setSelected:(self.followStatus == FindFriendsFollowingAll)];
     }

     
 
 return cell;
 }

#pragma mark - PAPFindFriendsCellDelegate

//- (void)cell:(FindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser {
//    // Push account view controller
//    AccountViewController *accountViewController = [[AccountViewController alloc] initWithStyle:UITableViewStylePlain];
//    [accountViewController setUser:aUser];
//    [self.navigationController pushViewController:accountViewController animated:YES];
//}
//


- (IBAction)followButtonTapped:(UIButton *)sender {
    
    //Find the row the button was selected from
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    

    
   FindFriendsCell * tappedcell = (FindFriendsCell *)[(UITableView *)self.view cellForRowAtIndexPath:hitIndex];
    
    //[self shouldToggleFollowFriendForCell:tappedcell];
    PFUser *cellUser = tappedcell.user;
   [self cell:tappedcell didTapFollowButton:cellUser];
    
    //[self cell:tappedcell didTapFollowButton:[PFUser currentUser]];
    
   

}


- (void)cell:(FindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser {
    NSLog(@"did tap follow button");
    [self shouldToggleFollowFriendForCell:cellView];
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/* Called when the user cancels the address book view controller. We simply dismiss it. */
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
//    [self dismissModalViewControllerAnimated:YES ];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Called when a member of the address book is selected, we return YES to display the member's details. */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return NO;
}

//Method necessary for iOS 8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}

/* Called when the user selects a property of a person in their address book (ex. phone, email, location,...)
 This method will allow them to send a text or email inviting them to Iconic.  */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    if (property == kABPersonEmailProperty) {
        
        ABMultiValueRef emailProperty = ABRecordCopyValue(person,property);
        NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emailProperty,identifier);
        self.selectedEmailAddress = email;
        
        if ([MFMailComposeViewController canSendMail] && [MFMessageComposeViewController canSendText]) {
            // ask user
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Invite %@",@""] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"iMessage", nil];
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        } else if ([MFMailComposeViewController canSendMail]) {
            // go directly to mail
            [self presentMailComposeViewController:email];
        } else if ([MFMessageComposeViewController canSendText]) {
            // go directly to iMessage
            [self presentMessageComposeViewController:email];
        }
        
    } else if (property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
        NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneProperty,identifier);
        
        if ([MFMessageComposeViewController canSendText]) {
            [self presentMessageComposeViewController:phone];
        }
    }
    
    return NO;
}

#pragma mark - MFMailComposeDelegate

/* Simply dismiss the MFMailComposeViewController when the user sends an email or cancels */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MFMessageComposeDelegate

/* Simply dismiss the MFMessageComposeViewController when the user sends a text or cancels */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (buttonIndex == 0) {
        [self presentMailComposeViewController:self.selectedEmailAddress];
    } else if (buttonIndex == 1) {
        [self presentMessageComposeViewController:self.selectedEmailAddress];
    }
}

#pragma mark - ()

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inviteFriendsButtonAction:(id)sender {
    ABPeoplePickerNavigationController *addressBook = [[ABPeoplePickerNavigationController alloc] init];
    addressBook.peoplePickerDelegate = self;
    
    if ([MFMailComposeViewController canSendMail] && [MFMessageComposeViewController canSendText]) {
        addressBook.displayedProperties = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonEmailProperty], [NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    } else if ([MFMailComposeViewController canSendMail]) {
        addressBook.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
    } else if ([MFMessageComposeViewController canSendText]) {
        addressBook.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    }
    
    [self presentViewController:addressBook animated:YES completion:^{
        
    }];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
//    [self presentModalViewController:addressBook animated:YES];
}

- (void)followAllFriendsButtonAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    self.followStatus = FindFriendsFollowingAll;
    [self configureUnfollowAllButton];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Unfollow All" style:UIBarButtonItemStyleBordered target:self action:@selector(unfollowAllFriendsButtonAction:)];
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.objects.count];
        for (int r = 0; r < self.objects.count; r++) {
            PFObject *user = [self.objects objectAtIndex:r];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:0];
            FindFriendsCell *cell = (FindFriendsCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath object:user];
            cell.followButton.selected = YES;
            [indexPaths addObject:indexPath];
        }
        
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(followUsersTimerFired:) userInfo:nil repeats:NO];
        [Utility followUsersEventually:self.objects block:^(BOOL succeeded, NSError *error) {
            // note -- this block is called once for every user that is followed successfully. We use a timer to only execute the completion block once no more saveEventually blocks have been called in 2 seconds
            [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0f]];
        }];
        
    });
}

- (void)unfollowAllFriendsButtonAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    self.followStatus = FindFriendsFollowingNone;
    [self configureFollowAllButton];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Follow All" style:UIBarButtonItemStyleBordered target:self action:@selector(followAllFriendsButtonAction:)];
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.objects.count];
        for (int r = 0; r < self.objects.count; r++) {
            PFObject *user = [self.objects objectAtIndex:r];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:0];
            FindFriendsCell *cell = (FindFriendsCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath object:user];
            cell.followButton.selected = NO;
            [indexPaths addObject:indexPath];
        }
        
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        [Utility unfollowUsersEventually:self.objects];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UtilityUserFollowingChangedNotification object:nil];
    });
    
}

- (void)shouldToggleFollowFriendForCell:(FindFriendsCell*)cell {
    PFUser *cellUser = cell.user;
    if ([cell.followButton isSelected]) {
        
        [Amplitude logEvent:@"Find Friends: Un-Followed User Pressed"];
        // Unfollow
        //NSLog(@"unfollow user");
        cell.followButton.selected = NO;
        [Utility unfollowUserEventually:cellUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:UtilityUserFollowingChangedNotification object:nil];
    } else {
        // Follow
       // NSLog(@"follow user");
        [Amplitude logEvent:@"Find Friends: Followed User Pressed"];
        cell.followButton.selected = YES;
        [Utility followUserEventually:cellUser block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UtilityUserFollowingChangedNotification object:nil];
            } else {
                cell.followButton.selected = NO;
            }
        }];
    }
}

- (void)configureUnfollowAllButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Unfollow All" style:UIBarButtonItemStyleBordered target:self action:@selector(unfollowAllFriendsButtonAction:)];
}

- (void)configureFollowAllButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Follow All" style:UIBarButtonItemStyleBordered target:self action:@selector(followAllFriendsButtonAction:)];
}

- (void)presentMailComposeViewController:(NSString *)recipient {
    // Create the compose email view controller
    MFMailComposeViewController *composeEmailViewController = [[MFMailComposeViewController alloc] init];
    
    // Set the recipient to the selected email and a default text
    [composeEmailViewController setMailComposeDelegate:self];
    [composeEmailViewController setSubject:@"Join me on Iconic"];
    [composeEmailViewController setToRecipients:[NSArray arrayWithObjects:recipient, nil]];
    [composeEmailViewController setMessageBody:@"Come join my team" isHTML:NO];
   // [composeEmailViewController setMessageBody:@"<h2>Share your activity, share your story.</h2><p><a href=\"http://imiconic.com\">Iconic</a> is is a fun way to team with your friends and compete in walking leagues. Get the app and get healthy together.</p><p><a href=\"http://imiconic.com\">Anypic</a> is fully powered by <a href=\"http://parse.com\">Parse</a>.</p>" isHTML:YES];
    
    // Dismiss the current modal view controller and display the compose email one.
    // Note that we do not animate them. Doing so would require us to present the compose
    // mail one only *after* the address book is dismissed.
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:composeEmailViewController animated:NO];
}

- (void)presentMessageComposeViewController:(NSString *)recipient {
    // Create the compose text message view controller
    MFMessageComposeViewController *composeTextViewController = [[MFMessageComposeViewController alloc] init];
    
    // Send the destination phone number and a default text
    [composeTextViewController setMessageComposeDelegate:self];
    [composeTextViewController setRecipients:[NSArray arrayWithObjects:recipient, nil]];
    [composeTextViewController setBody:@"Check out Iconic! http://iconic.co"];
    
    // Dismiss the current modal view controller and display the compose text one.
    // See previous use for reason why these are not animated.
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:composeTextViewController animated:NO];
}

- (void)followUsersTimerFired:(NSTimer *)timer {
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:UtilityUserFollowingChangedNotification object:nil];
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
}



- (IBAction)exitFindFriendsView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectUserFromFindFriendsViewController"]) {
        
        //Find the row the button was selected from
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        
        
        FindFriendsCell * tappedcell = (FindFriendsCell *)[(UITableView *)self.view cellForRowAtIndexPath:hitIndex];
        
        //[self shouldToggleFollowFriendForCell:tappedcell];
        PFUser *cellUser = tappedcell.user;
        
        UINavigationController *navController = [segue destinationViewController];
        PlayerProfileViewController *destinationViewController = (PlayerProfileViewController *)( [navController topViewController]);
        [destinationViewController initWithPlayer:cellUser];
        
//        [segue.destinationViewController initWithPlayer:cellUser];
        
        [Amplitude logEvent:@"Find Friends: Selected User"];
        
    }

    
  }


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Invite Contacts Button Pressed

- (IBAction)inviteFriendsPressed:(id)sender {
    
    [Amplitude logEvent:@"Find Friends: Invite Contacts Pressed"];
    
    
    NSString *alertMessage = [NSString stringWithFormat:@"Check out the new Iconic app @ www.imiconic.com"];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[alertMessage]
                                                                                         applicationActivities:nil];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         //                         NSLog(@"share sheet showed.");
                     }];

    
//    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
//        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
//        //Check if contacts access was denied
////        NSLog(@"Denied");
//        
//        
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Contacts access was previously denied"
//                                              message:@"Go to iOS Settings -> Iconic -> Contacts to allow access"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       
//                                   }];
//
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        
//    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
//        
////        NSLog(@"Authorized");
//        
//        //if contacts access permission was given then show contacts
//        [self inviteFriendsButtonAction:sender];
//        
//
//    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
//        
////        NSLog(@"Not determined");
//        //if contacts access permission is not determined grant access
//        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
//            if (!granted){
//                //4
////                NSLog(@"Just denied");
//                return;
//            }
//            //5
////            NSLog(@"Just authorized");
//           [self inviteFriendsButtonAction:sender];
//
//        });
//    }
    
}

#pragma mark - Invite Facebook Friends

//- (IBAction)inviteFacebookFriendsPressed:(id)sender {
//    
//    [Amplitude logEvent:@"Find Friends: Invite Facebook Friends Pressed"];
//    
//    
//    
//    
//    
//    [FBSDKAppInviteDialog
//     presentRequestsDialogModallyWithSession:nil
//     message:@"Join my Iconic walking team http://imiconic.com"
//     title:nil
//     parameters:nil
//     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//         if (error) {
//             // Error launching the dialog or sending the request.
//             NSLog(@"Error sending request.");
//         } else {
//        
//             
//             if (result == FBWebDialogResultDialogNotCompleted) {
//                 // User clicked the "x" icon
//                 NSLog(@"FBWebDialogResultDialogNotCompleted");
//             } else {
//                 // Handle the send request callback
//                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                 if (![urlParams valueForKey:@"request"]) {
//                     // User clicked the Cancel button
//                     NSLog(@"no FB urlParms");
//                     
//                     //if user's tokens have expired make the user login again
//                     if (self.facebookLogIn.hidden == YES) {
//                         self.facebookLogIn.hidden = NO;
//                         self.inviteFacebookFriends.hidden = YES;
//                     }
//                     
//                     
//                     
//                 } else {
//                     // User clicked the Send button
//                     NSString *requestID = [urlParams valueForKey:@"request"];
//                     NSLog(@"Request ID: %@", requestID);
//                 }
//             }
//         }
//     }];
//    
//    
//}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


//connect Facebook if the user has not created an account yet
- (IBAction)facebookLogInAction:(id)sender {
    
    [Amplitude logEvent:@"Find Friends: Connect Facebook Pressed"];
    
    //link user with their facebook account
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"email" ];
    
    
    [PFFacebookUtils linkUserInBackground:[PFUser currentUser] withPublishPermissions:permissionsArray block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //            NSLog(@"Woohoo, user logged in with Facebook!");
            self.facebookLogIn.hidden = YES;
            self.inviteFacebookFriends.hidden = NO;
            
        }
        else
        {
            //            NSLog(@"Could not log in user: %@", error);
        }
        
    }];
    
  
    
  
    }


- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end