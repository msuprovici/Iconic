//
//  MyTeamsViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 6/24/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PNChart.h"
#import "UICountingLabel.h"
#import <CoreMotion/CoreMotion.h>


@interface MyTeamsViewController : UIViewController

@property (nonatomic, strong) PFObject * myteamObject;
@property (nonatomic, strong) PFObject * myNewTeamObject;
@property (nonatomic, strong) PFObject * myteamObjectatIndex;
@property (nonatomic, assign) NSInteger matchupsIndex;

//step counter
@property (nonatomic, strong) CMStepCounter *stepCounter;


@property (strong, nonatomic) NSMutableArray *myTeamData;
@property (strong, nonatomic) NSMutableArray * arrayOfTeamScores;
@property (strong, nonatomic) NSMutableArray * vsTeamScores;
@property (strong, nonatomic) NSMutableArray * homeTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfhomeTeamScores;
@property (strong, nonatomic) NSMutableArray * awayTeamScores;
@property NSString* nameOfMyTeamString;
@property (strong, nonatomic) NSArray * teamPoints;
@property BOOL deltaPointsLabelIsAnimating;


@property (strong, nonatomic) IBOutlet PNBarChart *teamBarChart;



@property (strong, nonatomic) IBOutlet UILabel *myLeagueName;
@property (strong, nonatomic) IBOutlet UILabel *MyTeamName;
@property (strong, nonatomic) IBOutlet UILabel *vsTeamName;
@property (strong, nonatomic) IBOutlet UICountingLabel *MyTeamScore;
@property (weak, nonatomic) IBOutlet UILabel *VSTeamScore;

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) int myTeamPoints;

@end