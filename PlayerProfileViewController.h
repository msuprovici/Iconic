//
//  PlayerProfileViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 7/7/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface PlayerProfileViewController  : PFQueryTableViewController

@property (strong, nonatomic) IBOutlet PFImageView *playerProfilePhoto;

@property (strong, nonatomic) IBOutlet UILabel *playerUserName;

@property (strong, nonatomic) IBOutlet UILabel *playerAvgSteps;

@property (strong, nonatomic) IBOutlet UILabel *playerXP;

@property (strong, nonatomic) IBOutlet UIButton *cheerButton;

@property (strong, nonatomic) IBOutlet UILabel *streak;

@property (strong, nonatomic) IBOutlet UILabel *streakLong;

- (IBAction)cheerButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *followUser;

- (IBAction)followUserPressed:(id)sender;

@property (nonatomic, strong) PFObject *player;

@property (nonatomic, strong) PFUser *playerUserObject;

@property (nonatomic, strong) NSString *userName;

-(void)initWithPlayer:(PFObject*)aPlayer;

@end
