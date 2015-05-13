//
//  SimpleHomeViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/10/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChart.h"
#import <CoreMotion/CoreMotion.h>
#import "UICountingLabel.h"

@interface SimpleHomeViewController : UIViewController  <UIScrollViewDelegate, UIPageViewControllerDataSource>

{
    
    NSArray *teamScores;
    
    
    
}




@property (nonatomic, strong) NSArray *contentList;



//step counter
@property (nonatomic, strong) CMStepCounter *stepCounter;



@property (strong, nonatomic) IBOutlet UILabel *playerName;


//My Teams View

@property (strong, nonatomic) IBOutlet UIView *MyTeamsView;

//Team Bar Chart

@property (strong, nonatomic) IBOutlet PNBarChart *teamBarChart;
 


@property (strong, nonatomic) IBOutlet UILabel *myLeagueName;


@property (strong, nonatomic) IBOutlet UILabel *MyTeamName;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamName;


@property (strong, nonatomic) IBOutlet UICountingLabel *MyTeamScore;


@property (weak, nonatomic) IBOutlet UILabel *VSTeamScore;


@property (strong, nonatomic) IBOutlet UILabel *xChartLabel;


@property (strong, nonatomic) IBOutlet UIButton *scrollTeamsRight;

@property (strong, nonatomic) IBOutlet UIButton *scrollTeamsLeft;



@property (strong, nonatomic) IBOutlet UIButton *joinTeamButton;


@property (strong, nonatomic)NSMutableArray *teamMatchups;

@property (strong, nonatomic) IBOutlet UILabel *deltaPoints;

@property (nonatomic, assign) NSUInteger myTeamsIndex;

//My Teams Page Controller

@property (strong, nonatomic) UIPageViewController *myTeamsPageController;

- (IBAction)joinTeam:(id)sender;


@property BOOL joinedTeamButtonPressed;


//methods
-(void)refreshHomeView;
-(void)updateTeamChart:(int)index;





@end
