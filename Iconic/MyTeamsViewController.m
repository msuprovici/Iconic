//
//  MyTeamsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 6/24/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "MyTeamsViewController.h"
#import "Constants.h"
#import "PNChart.h"
#import "PNColor.h"
#import "SimpleHomeViewController.h"
#import "VSTableViewController.h"
#import "CalculatePoints.h"
@interface MyTeamsViewController ()

@end

@implementation MyTeamsViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self updateTeamChart:self.index];
    


    
}




-(void)updateTeamChart:(NSInteger)index
{
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    NSArray *homeTeamScores = [RetrievedTeams objectForKey:kArrayOfHomeTeamScores];
    NSArray *awayTeamScores = [RetrievedTeams objectForKey:kArrayOfAwayTeamScores];
    
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
    
    NSArray *arrayOfLeagueNames = [RetrievedTeams objectForKey:kArrayOfLeagueNames];
    
//    
//    int myStepsGainedDelta = (int)[RetrievedTeams integerForKey:@"myStepsDelta"];
//    NSLog(@"myStepsDelta: %d",  myStepsDelta);
    self.myNewTeamObject = [homeTeamNames objectAtIndex:index];
    self.matchupsIndex = index;
    
    
    
    //    NSLog(@"matchupsIndex %d", self.matchupsIndex);
    //    NSLog(@"homeTeamNames retrieved: %@", homeTeamNames);
    //
    //    NSLog(@"awayTeamNames retrieved: %@", awayTeamNames);
    
    //set team names
    NSString * homeTeamName = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:index]];
    //    self.MyTeamName.text = homeTeamName;
    
    NSString * awayTeamName = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:index]];
    //    self.vsTeamName.text = awayTeamName;
    
    
    //set league names
    NSString * leagueName = [NSString stringWithFormat:@"%@",[arrayOfLeagueNames objectAtIndex:index]];
    
    //set score
    NSString * homeTeamScore = [NSString stringWithFormat:@"%@",[homeTeamScores objectAtIndex:index]];
    //    self.MyTeamScore.text = homeTeamScore;
    int  homeTeamPoints = (int)[homeTeamScore integerValue];
    
    
    NSString * awayTeamScore = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:index]];
    //    self.VSTeamScore.text = awayTeamScore;
    int  awayTeamPoints = (int)[awayTeamScore integerValue];
    
    
    //set colors
    self.MyTeamName.textColor = PNWeiboColor;
    self.MyTeamScore.textColor = PNWeiboColor;
    
    
    self.vsTeamName.textColor = PNDarkBlue;
    self.VSTeamScore.textColor = PNDarkBlue;
    
    self.myLeagueName.textColor = PNBlue;
    
    
    
    
    //find out what team the player is on and set that as a property so that we can send it to VS view controller
    NSArray *myTeamsNames = [RetrievedTeams objectForKey:kArrayOfMyTeamsNames];
    
    //    NSLog(@"# of teams I'm on: %lu",  (unsigned long)myTeamsNames.count);
    //     for (int i = 0; i < myTeamsNames.count; i++) {
    //        NSLog(@"myTeamsNames[index] %@",  myTeamsNames[index]);
    //        NSLog(@"homeTeamName %@",  homeTeamName);
    //        NSLog(@"awayTeamName %@",  awayTeamName);
    
    
    
    //initialize couting label
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterNoStyle;
    self.MyTeamScore.formatBlock = ^NSString* (float value)
    {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"%@",formatted];
    };
    
    
    
    self.stepCounter = [[CMStepCounter alloc] init];
    NSDate *now = [NSDate date];
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    NSDate *from = [calculatePointsClass beginningOfDay];
    
    
    //    NSLog(@"time now: %@",now);
    //    NSLog(@"time from: %@",from);
    
    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        
        
        
        NSUserDefaults *myRetrievedSteps = [NSUserDefaults standardUserDefaults];
        
        int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyMostRecentStepsAddToTeamBeforeSaving];
        
//        NSLog(@"My stored steps in MyTeamsViewController: %d", myStoredSteps);
        
        int myStepsGainedDelta = (int)numberOfSteps - myStoredSteps;
//        NSLog(@"myStepsGainedDelta: %d", myStepsGainedDelta);
    
    for (int i = 0; i < myTeamsNames.count; i++) {
        {
            //            NSLog(@"myTeamsNames[i] %@",  myTeamsNames[i]);
            
            
            
            //ensure that my team is always on the left hand side of the chart
            //if the object in my teams arrays is equal to the home team set it
            
            self.myLeagueName.text = leagueName;
            
            if([myTeamsNames[i] isEqualToString: homeTeamName])
            {
                
                self.nameOfMyTeamString = homeTeamName;
                //             NSLog(@"my Home Team Name: %@",  self.nameOfMyTeamString);
                
                
                //set the right order for homeTeamScore
                self.teamPoints = @[homeTeamScore, awayTeamScore];
                
                self.MyTeamName.text = homeTeamName;
                self.vsTeamName.text = awayTeamName;
                
                self.VSTeamScore.text = awayTeamScore;
                
                if (myStepsGainedDelta > 0)
                {
                    
                int pointsBeforePlayerScored = homeTeamPoints - myStepsGainedDelta;
                    
                //                NSLog(@"pointsBeforePlayerScored: %d",  pointsBeforePlayerScored);
                //                NSLog(@"awayTeamPoints: %d",  homeTeamPoints);
                
                [self.MyTeamScore  countFrom:pointsBeforePlayerScored to:homeTeamPoints withDuration:1.5];
                    
                }
                else
                {
                    self.MyTeamScore.text = [NSString stringWithFormat:@"%d",homeTeamPoints];
                }
                
            }
            //if the object in my teams arrays is equal to the away team set it
            
            else if ([myTeamsNames[i] isEqualToString: awayTeamName])
            {
                self.nameOfMyTeamString = awayTeamName;
                //                NSLog(@"my Away Team Name: %@",  self.nameOfMyTeamString);
                
                //ensure that my team is always on the left hand side of the chart - so in this case the away team is on the right
                //reverse order for bargraph
                self.teamPoints = @[awayTeamScore, homeTeamScore];
                
                //reverse the values of the labels
                self.MyTeamName.text = awayTeamName;
                self.vsTeamName.text = homeTeamName;
                
                self.VSTeamScore.text = homeTeamScore;
                
             
                int pointsBeforePlayerScored = awayTeamPoints - myStepsGainedDelta;
//                NSLog(@"awayTeamPoints: %d",  awayTeamPoints);
//                
//                 NSLog(@"pointsBeforePlayerScored1: %d",  pointsBeforePlayerScored);
                
                if (myStepsGainedDelta > 0) {
                [self.MyTeamScore  countFrom:pointsBeforePlayerScored to:awayTeamPoints withDuration:1.5];
                }
                else{
                    self.MyTeamScore.text = [NSString stringWithFormat:@"%d",awayTeamPoints];
                }
                
                
            }
        }
    
        
        
        
        
        //create bar chart to display days
        PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
        
       
        
        [barChart setYValues:self.teamPoints];
        
        
        [barChart setStrokeColors:@[PNWeiboColor, PNDarkBlue]];
        [barChart setBarBackgroundColor:[UIColor clearColor]];
        //    [barChart setStrokeColor:PNLightBlue];
        [barChart strokeChart];
        
        [self.teamBarChart addSubview:barChart];
        
        
    }
        
        //save most recent step count to a different key because kMyMostRecentPointsBeforeSaving gets updated too fast in SimpleViewController
        [myRetrievedSteps setInteger:numberOfSteps forKey:kMyMostRecentStepsAddToTeamBeforeSaving];
        [myRetrievedSteps synchronize];

        }];
    
}

#pragma mark - Navigation

//pass the team to the teammates view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    VSTableViewController *transferViewController = segue.destinationViewController;
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
    
    if ([segue.identifier isEqualToString:@"vs"]) {
        
        
          //we use this index to pass the correct data to the vs view controller
          int myRetreivedIndex = (int)self.index ;
//        NSLog(@"myRetreivedIndex: %d", myRetreivedIndex);
        
        
        [segue.destinationViewController initWithReceivedTeam:myRetreivedIndex];
        
        transferViewController.homeTeam = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:myRetreivedIndex]];
        transferViewController.awayTeam = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:myRetreivedIndex]];
        transferViewController.matchupsIndex = myRetreivedIndex;
        
        //send my team name to vs view controller
        transferViewController.myTeamReceived = [NSString stringWithFormat:@"%@",self.nameOfMyTeamString];
        
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
