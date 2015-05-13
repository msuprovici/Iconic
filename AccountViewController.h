//
//  AccountViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/31/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface AccountViewController : PFQueryTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet PFImageView *myProfilePhoto;

@property (strong, nonatomic) IBOutlet UILabel *myUserName;

@property (strong, nonatomic) IBOutlet UILabel *myAvgSteps;

@property (strong, nonatomic) IBOutlet UILabel *streak;

@property (strong, nonatomic) IBOutlet UILabel *streakLong;

@property (strong, nonatomic) IBOutlet UILabel *myXPLevel;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UILabel *myTeamsLabel;

- (IBAction)selectPhoto:(UIButton *)sender;


@end
