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

@property (nonatomic, strong) PFObject *league;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *createTeam;



- (IBAction)createTeamPressed:(id)sender;

-(void)initWithLeague:(PFObject*)aLeague;

@end
