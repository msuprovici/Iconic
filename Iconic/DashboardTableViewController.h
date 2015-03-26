//
//  DashboardTableViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 3/26/15.
//  Copyright (c) 2015 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

#import "PNChart.h"

#import <CoreMotion/CoreMotion.h>
#import "UICountingLabel.h"


@interface DashboardTableViewController : UITableViewController

//My Steps - Today

//step counter
@property (nonatomic, strong) CMStepCounter *stepCounter;

@property (strong, nonatomic) IBOutlet UIView *myStatsView;

@property (strong, nonatomic) IBOutlet UICountingLabel *xpValue;

@property (strong, nonatomic) IBOutlet UILabel *streak;

@property (strong, nonatomic) IBOutlet UICountingLabel *pointsValue;

@property (strong, nonatomic) IBOutlet DACircularProgressView *xpProgressDial;



//My steps - 7 days

@property (strong, nonatomic) IBOutlet UILabel *highValue;

@property (strong, nonatomic) IBOutlet UILabel *mediumValue;

@property (strong, nonatomic) IBOutlet UILabel *sevenDaysAgoDay;

@property (strong, nonatomic) IBOutlet UILabel *todayDay;

@property (strong, nonatomic) IBOutlet PNBarChart *stepsBarChart;

//Animated steps
@property (strong, nonatomic) IBOutlet UILabel *deltaPoints;


@end
