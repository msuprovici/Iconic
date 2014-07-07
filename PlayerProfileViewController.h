//
//  PlayerProfileViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 7/7/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PlayerProfileViewController  : PFQueryTableViewController

@property (strong, nonatomic) IBOutlet PFImageView *playerProfilePhoto;

@property (strong, nonatomic) IBOutlet UILabel *playerUserName;

@property (strong, nonatomic) IBOutlet UILabel *playerAvgSteps;

@property (strong, nonatomic) IBOutlet UILabel *playerXP;

@property (nonatomic, strong) PFObject *player;

-(void)initWithPlayer:(PFObject*)aPlayer;

@end
