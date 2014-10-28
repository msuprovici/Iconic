//
//  TeamsViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TeamPlayersViewController.h"


@interface TeamsViewController : PFQueryTableViewController<TeamPlayersViewControllerDelegate>



@property (strong, nonatomic) IBOutlet UIView *scheduleView;
@property (strong, nonatomic) IBOutlet UIButton *scheduleButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *createTeam;

@property (nonatomic, strong) PFObject *league;

- (IBAction)createTeamPressed:(id)sender;

-(void)initWithLeague:(PFObject*)aLeague;

@end
