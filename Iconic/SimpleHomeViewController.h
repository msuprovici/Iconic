//
//  SimpleHomeViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/10/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChart.h"
#import <CoreMotion/CoreMotion.h>
#import "UICountingLabel.h"

@interface SimpleHomeViewController : UIViewController <UIScrollViewDelegate>

{
    
    NSArray *teamScores;
    
    
    
}



@property (nonatomic, strong) NSArray *contentList;



//step counter
@property (nonatomic, strong) CMStepCounter *stepCounter;



@property (strong, nonatomic) IBOutlet UILabel *playerName;




//Team Bar Chart

@property (strong, nonatomic) IBOutlet PNBarChart *teamBarChart;
 




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

- (IBAction)joinTeam:(id)sender;


@property BOOL joinedTeamButtonPressed;


//methods
-(void)refreshHomeView;
-(void)updateTeamChart:(int)index;



@end
