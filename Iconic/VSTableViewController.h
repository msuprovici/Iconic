//
//  VSTableViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 2/28/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
#import <Parse/Parse.h>

@interface VSTableViewController : PFQueryTableViewController <MZTimerLabelDelegate>

@property (nonatomic, strong) PFObject *receivedTeam;

-(void)initWithReceivedTeam:(PFObject*)aReceivedTeam;



@property (strong, nonatomic) IBOutlet MZTimerLabel *timerLabel;

@property (strong, nonatomic) IBOutlet UILabel *myTeamName;

@property (strong, nonatomic) IBOutlet UILabel *myTeamScore;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamScore;

@property (strong, nonatomic) IBOutlet UILabel *myTeam;

@property (strong, nonatomic) IBOutlet UILabel *vsTeam;



//My Team Daily Score
@property (strong, nonatomic) IBOutlet UILabel *myTeamMonday;

@property (strong, nonatomic) IBOutlet UILabel *myTeamTuesday;

@property (strong, nonatomic) IBOutlet UILabel *myTeamWednesday;

@property (strong, nonatomic) IBOutlet UILabel *myTeamThursday;

@property (strong, nonatomic) IBOutlet UILabel *myTeamFriday;

@property (strong, nonatomic) IBOutlet UILabel *myTeamSaturday;

@property (strong, nonatomic) IBOutlet UILabel *myTeamSunday;



//Vs Team Daily Score
@property (strong, nonatomic) IBOutlet UILabel *vsTeamMonday;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamTuesday;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamWednesday;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamThursday;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamFriday;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamSaturday;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamSunday;


@end
