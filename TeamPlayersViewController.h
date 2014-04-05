//
//  TeamPlayersViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Team.h"

@class TeamPlayersViewController;
@protocol TeamPlayersViewControllerDelegate<NSObject>
@optional;

-(void) didSelectJoinTeam:(TeamPlayersViewController *)controller team:(Team *)team;

@end



@interface TeamPlayersViewController : PFQueryTableViewController

@property (nonatomic, assign) id <TeamPlayersViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *joinTeam;

@property (nonatomic, strong) PFObject *team;

@property (nonatomic, strong) PFObject *league;

@property BOOL addTeam;

-(void)initWithTeam:(PFObject*)aTeam;

-(void)initWithLeague:(PFObject *)aLeague;



@end
