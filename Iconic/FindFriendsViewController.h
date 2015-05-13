//
//  FindFriendsViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/29/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import "FindFriendsCell.h"

@interface FindFriendsViewController : PFQueryTableViewController <FindFriendsCellDelegate, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>


@property (strong, nonatomic) IBOutlet UIButton *inviteFriends;

- (IBAction)inviteFriendsPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *inviteFacebookFriends;


- (IBAction)inviteFacebookFriendsPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *facebookLogIn;

- (IBAction)facebookLogInAction:(id)sender;

@end
