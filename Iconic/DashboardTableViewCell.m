//
//  DashboardTableViewCell.m
//  Iconic
//
//  Created by Mike Suprovici on 3/26/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import "DashboardTableViewCell.h"
#import "Constants.h"
#import "PNChart.h"
#import "PNColor.h"
#import "MZTimerLabel.h"
//#import "SimpleHomeViewController.h"
#import "VSTableViewController.h"
#import "CalculatePoints.h"
#import "Amplitude.h"

@implementation DashboardTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier


{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
        
    }
    return self;
}





-(void)updateTeamCell:(NSInteger)index
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
    
    
    
    //        NSLog(@"matchupsIndex %d", self.matchupsIndex);
    //        NSLog(@"homeTeamNames retrieved: %@", homeTeamNames);
    //
    //        NSLog(@"awayTeamNames retrieved: %@", awayTeamNames);
    
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
    //     NSLog(@"homeTeamPoints: %d",  homeTeamPoints);
    
    NSString * awayTeamScore = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:index]];
    //    self.VSTeamScore.text = awayTeamScore;
    int  awayTeamPoints = (int)[awayTeamScore integerValue];
    //     NSLog(@"awayTeamPoints: %d",  awayTeamPoints);
    
    //set colors
    self.MyTeamName.textColor = PNWeiboColor;
    self.MyTeamScore.textColor = PNWeiboColor;
    
    
    self.vsTeamName.textColor = [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:134.0/255.0 alpha:1.0];
    self.VSTeamScore.textColor = [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:134.0/255.0 alpha:1.0];
    
//    self.myLeagueName.textColor = [UIColor colorWithRed:1240.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1.0];
//    
//    self.vsTeamName.textColor = [UIColor colorWithRed:7.0/255.0 green:79.0/255.0 blue:87.0/255.0 alpha:1.0];
//    self.VSTeamScore.textColor = [UIColor colorWithRed:7.0/255.0 green:79.0/255.0 blue:87.0/255.0 alpha:1.0];
    
    self.myLeagueName.textColor = [UIColor colorWithRed:0.0/255.0 green:42.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    
    //find out what team the player is on and set that as a property so that we can send it to VS view controller
    NSArray *myTeamsNames = [RetrievedTeams objectForKey:kArrayOfMyTeamsNames];
    
    //        NSLog(@"# of teams I'm on: %lu",  (unsigned long)myTeamsNames.count);
    //         for (int i = 0; i < myTeamsNames.count; i++) {
    //            NSLog(@"myTeamsNames[index] %@",  myTeamsNames[index]);
    //            NSLog(@"homeTeamName %@",  homeTeamName);
    //            NSLog(@"awayTeamName %@",  awayTeamName);
    //         }
    
    
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
        
        int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyFetchedStepsToday];
        
        //        int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyMostRecentStepsAddToTeamBeforeSaving];
        
        //        NSLog(@"My stored steps in MyTeamsViewController: %d", myStoredSteps);
        
        int myStepsGainedDelta = (int)numberOfSteps - myStoredSteps;
        //        NSLog(@"myStepsGainedDelta: %d", myStepsGainedDelta);
        self.myStepsGained = myStepsGainedDelta;
        
        
        //        if (index == 0) {
        //this is where you need to add method for counting label
        
        
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
                    
                    
                    self.myTeamPoints = homeTeamPoints;
                    //                int pointsBeforePlayerScoredHome = homeTeamPoints - myStepsGainedDelta;
                    //                int pointsAfterPlayerScoredHome = homeTeamPoints + myStepsGainedDelta;
                    
                    //                                NSLog(@"pointsAferPlayerScored: %d",  pointsAfterPlayerScoredHome);
                    //                               NSLog(@"homeTeamPoints: %d",  homeTeamPoints);
                    //                                NSLog(@"homeTeamPointsDelta: %d",  myStepsGainedDelta);
                    
                    if (myStepsGainedDelta > 0)
                    {
                        
                        //show my team's steps before counting up the label bellow
                        self.MyTeamScore.text = [NSString stringWithFormat:@"%d",homeTeamPoints];
                        [self performSelector:@selector(updateTeamLabel) withObject:self afterDelay:2.0];
                        
                        //                    double delayInSeconds = 3.0;
                        //                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        //                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //                        [self updateTeamLabel];
                        //                    });
                        
                        
                        
                        //                    //if this is the 1st team at index, animate and count up my team score
                        //                    if (index == 0)
                        //                    {
                        //
                        //                        //wait for animateDeltaPointsLabel method to finsih in SimpleViewController
                        //                        //count up my team's score
                        //                    [self performSelector:@selector(updateTeamLabel) withObject:self afterDelay:3.0 ];
                        //                    }
                        
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
                    
                    self.myTeamPoints = awayTeamPoints;
                    
                    //                int pointsBeforePlayerScoredAway = awayTeamPoints - myStepsGainedDelta;
                    ////                NSLog(@"awayTeamPoints: %d",  awayTeamPoints);
                    ////
                    //                NSLog(@"pointsBeforePlayerScored1: %d",  pointsBeforePlayerScoredAway);
                    
                    if (myStepsGainedDelta > 0) {
                        
                        self.MyTeamScore.text = [NSString stringWithFormat:@"%d",awayTeamPoints];
                        [self performSelector:@selector(updateTeamLabel) withObject:self afterDelay:2.0];
                        
                        //                    [self performSelector:@selector(finalUpdateMyTeamLabel) withObject:self afterDelay:5.0];
                        
                        //                    [self performSelector:@selector(updateTeamLabel) withObject:self afterDelay:3.0];
                        //                    double delayInSeconds = 3.0;
                        //                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        //                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //                        [self updateTeamLabel];
                        //                    });
                        
                        //if this is the 1st team at index, animate and count up my team score
                        //                    if (index == 0) {
                        //                    //wait for animateDeltaPointsLabel method to finsih in SimpleViewController
                        //                    //count up my team's score
                        //                    [self performSelector:@selector(updateTeamLabel) withObject:self afterDelay:3.0 ];
                        //                    }
                    }
                    else{
                        
                        //                    [self updateTeamLabel];
                        //                    [self performSelector:@selector(updateTeamLabel) withObject:self afterDelay:1.0];
                        self.MyTeamScore.text = [NSString stringWithFormat:@"%d",awayTeamPoints];
                    }
                    
                    
                }
            }
            

            
            
        }
        
        //save most recent step count to a different key because kMyMostRecentPointsBeforeSaving gets updated too fast in SimpleViewController
        //        NSLog(@"numberOfSteps before saving: %ld",  (long)numberOfSteps);
        
        [myRetrievedSteps setInteger:numberOfSteps forKey:kMyMostRecentStepsAddToTeamBeforeSaving];
        [myRetrievedSteps synchronize];
        
    }];
    
}

//add my steps to team's total and animate counting up
-(void)updateTeamLabel
{
    
    //     NSLog(@"self.myTeamPoints in updateTeamLabel: %d",  self.myTeamPoints);
    //     NSLog(@"self.myStepsGained in updateTeamLabel: %d",  self.myStepsGained);
    
    
    int pointsAfterPlayerScored = self.myTeamPoints + self.myStepsGained;

    [self.MyTeamScore  countFrom:self.myTeamPoints to:pointsAfterPlayerScored withDuration:1.5];

    
}



//#pragma mark - Navigation
//
////pass the team to the teammates view controller
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    VSTableViewController *transferViewController = segue.destinationViewController;
//    
//    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
//    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
//    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
//    
//    if ([segue.identifier isEqualToString:@"vs"]) {
//        
//        [Amplitude logEvent:@"Dashboard: Game Details selected"];
//        
//        
//        //we use this index to pass the correct data to the vs view controller
//        int myRetreivedIndex = (int)self.index ;
//        //        NSLog(@"myRetreivedIndex: %d", myRetreivedIndex);
//        
//        
//        [segue.destinationViewController initWithReceivedTeam:myRetreivedIndex];
//        
//        transferViewController.homeTeam = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:myRetreivedIndex]];
//        transferViewController.awayTeam = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:myRetreivedIndex]];
//        transferViewController.matchupsIndex = myRetreivedIndex;
//        
//        //send my team name to vs view controller
//        transferViewController.myTeamReceived = [NSString stringWithFormat:@"%@",self.nameOfMyTeamString];
//        
//        
//        
//    }
//}
//
//
//- (IBAction)unwindToMyTeamsViewController:(UIStoryboardSegue *)unwindSegue
//{
//    NSLog(@"unwind method");
//    
//    //    UIViewController* sourceViewController = unwindSegue.sourceViewController;
//    
//    
//    if ([unwindSegue.identifier isEqualToString:@"backFromVS"]) {
//        
//        NSLog(@"unwind method");
//    }
//    
//    
//}











@end
