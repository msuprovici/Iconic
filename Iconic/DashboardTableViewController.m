//
//  DashboardTableViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 3/26/15.
//  Copyright (c) 2015 Explorence. All rights reserved.
//

#import "DashboardTableViewController.h"
#import  <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import "Constants.h"
#import "Cache.h"
#import "CalculatePoints.h"
#import "DashboardTableViewCell.h"
#import "VSTableViewController.h"
#import "CalculatePoints.h"
#import "Amplitude.h"

#import "UIImage+RoundedCornerAdditions.h"
#import "UIImage+ResizeAdditions.h"
#import <CoreMotion/CoreMotion.h>

@interface DashboardTableViewController ()

{
    int pointslabelNumber;
    
}

@property (strong, nonatomic) NSTimer *timer;
@property  float myProgress;
@property  NSNumber *myPoints;
//@property SimpleHomeViewController * simpleHomeViewController;
@property  BOOL didInitialize;
@property  BOOL pointsOrSteps;
@property PNBarChart * barChart;
@property PNCircleChart * circleChart;
@property NSMutableArray *myWeekleyPointsArray;
@property NSMutableArray *myWeekleyStepsArray;
@property NSNumber *maxValueInArray;


@end

@implementation DashboardTableViewController

@synthesize timer = _timer;
@synthesize myProgress = _myProgress;
@synthesize xpProgressDial = _xpProgressDial;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPlayerSteps];//get today's steps
    
   
    
    NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
    
    //find my curent level
    int myLifetimePoints = (int)[myRetrievedPoints integerForKey:kMyFetchedStepsTotal];
    //                NSLog(@"myLifetimePoints: %d", myLifetimePoints);
    //                NSLog(@"myLevel: %@", myLevel);
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    NSNumber *myLevel = [calculatePointsClass calculateLevel:myLifetimePoints];
    NSUserDefaults *myStats = [NSUserDefaults standardUserDefaults];
    [myStats setObject:myLevel forKey:@"myXP"];
    [myStats synchronize];
    
    
    float myLevelValue = [myLevel floatValue];
    //                NSLog(@"myLevelValue: %f", myLevelValue);
    
    //calculate total points to reach next level
    NSNumber *totalPointsForNextLevel = [calculatePointsClass calculatePointsToReachNextLevel:myLevelValue];
    int myTotalPointsForNextLevelValue = [totalPointsForNextLevel intValue];
    
    //                NSLog(@"myTotalPointsForNextLevelValue: %d", myTotalPointsForNextLevelValue);
    
    //calculate total points to reach current level
    NSNumber *totalPointsForCurrentLevel = [calculatePointsClass calculatePointsToReachCurrentLevel:myLevelValue];
    
    int myTotalPointsForCurrentLevelValue = [totalPointsForCurrentLevel intValue];
    
    //                NSLog(@"myTotalPointsForCurrentLevelValue: %d", myTotalPointsForCurrentLevelValue);
    
    
    //calculate % progress
    
    
    float myLevelProgress = (myLifetimePoints - myTotalPointsForCurrentLevelValue);
    //                NSLog(@"myLevelProgress: %f", myLevelProgress);
    
    float myTotalPointsToNextLevel = (myTotalPointsForNextLevelValue - myTotalPointsForCurrentLevelValue);
    //                NSLog(@"myTotalPointsToNextLevel: %f", myTotalPointsToNextLevel);
    
    
    float myProgressPercent = myLevelProgress/myTotalPointsToNextLevel;
    self.myProgress = myProgressPercent;
    
    
    //DACircularChart
   
    [self progressDialChange];
    
    self.xpProgressDial.trackTintColor = PNLightGrey;
    self.xpProgressDial.progressTintColor = PNWeiboColor;
    
    self.xpProgressDial.thicknessRatio = .15f;
    self.xpProgressDial.roundedCorners = NO;
    
    
    
    //counting label text reformating
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterNoStyle;
    self.xpValue.formatBlock = ^NSString* (float value)
    {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"%@",formatted];
    };
    
    
    //using counting label to increment level
    //get the level the player was at the last time they launched the app
    //                int myPreviousLevel = (int)[myRetrievedPoints integerForKey:kMyLevelOnLastLaunch];
    
    
    //count up the level number
    //                [self.xpValue  countFrom: myPreviousLevel to:[myLevel intValue] withDuration:1];
    self.xpValue.text = [NSString stringWithFormat:@"%d",[myLevel intValue]];
    
   
    //Set up 7 day bar chart
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(28, 0, 300, 170)];
    
    NSUserDefaults *myWeekleyPoints = [NSUserDefaults standardUserDefaults];
    
    self.myWeekleyPointsArray = [myWeekleyPoints objectForKey:kMyPointsWeekArray];
    
    self.myWeekleyStepsArray = [myWeekleyPoints objectForKey:kMyStepsWeekArray];
    //            NSLog(@"my weekley steps %@", self.myWeekleyStepsArray);
    
    
    
    //steps chart
    [self.barChart setYValues:self.myWeekleyStepsArray];
    
    
    [self.barChart setStrokeColor:PNWeiboColor];
    [self.barChart setBarBackgroundColor:PNWhite];
    [self.barChart strokeChart];
    
    [self.stepsBarChart addSubview:self.barChart];
    
    //find max value in the array and insert it into the high value on for the y-axis
    //set Y labels for chart
    self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyStepsArray valueForKeyPath:@"@max.self"]];
    
    NSNumber *maxSteps = [self.myWeekleyStepsArray valueForKeyPath:@"@max.self"];
    int midStepsValue = [maxSteps intValue];
    
    
    //find mid value in the array and insert it into the high value on for the y-axis
    self.mediumValue.text = [NSString stringWithFormat:@"%d",midStepsValue/2];
    
    
    //set X labels for chart
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //use abbreviated date, ie: "Fri"
    [dateFormatter setDateFormat:@"EEE"];
    
    //set label to today's date
    self.todayDay.text = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    
    //find tomorrow (equivalent to end of day 7 days ago)
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init];
    [deltaComps setDay:1];
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    
    //NSLog(@"%@", [dateFormatter stringFromDate:tomorrow]);
    self.sevenDaysAgoDay.text = [dateFormatter stringFromDate:tomorrow];

    
}

- (void)progressDialChange
{
    
    NSArray *progressViews = @[self.xpProgressDial];
    for (DACircularProgressView *progressView in progressViews) {
        
        [progressView setProgress:self.myProgress animated:YES];
        
        
        
    }
}


#pragma mark Today's steps & points

-(void)getPlayerSteps
{
    self.stepCounter = [[CMStepCounter alloc] init];
    NSDate *now = [NSDate date];
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    NSDate *from = [calculatePointsClass beginningOfDay];
    
    
    //    NSLog(@"time now: %@",now);
    //    NSLog(@"time from: %@",from);
    
    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        
        
        
        //prevent NAN values
        if (numberOfSteps == 0) {
            self.myPoints = 0;
            
            self.pointsValue.text = [@(numberOfSteps) stringValue];
            
        }
        else
        {
            
            CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
            self.myPoints = [calculatePointsClass calculatePoints:numberOfSteps];
            
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = kCFNumberFormatterNoStyle;
            self.pointsValue.formatBlock = ^NSString* (float value)
            {
                NSString* formatted = [formatter stringFromNumber:@((int)value)];
                return [NSString stringWithFormat:@"%@",formatted];
            };
            
            
            
            NSUserDefaults *myRetrievedSteps = [NSUserDefaults standardUserDefaults];
            
            int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyFetchedStepsToday];
            
            //            int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyMostRecentStepsBeforeSaving];
            //            NSLog(@"kMyMostRecentPointsBeforeSaving in myStats: %d", myStoredPoints);
            
            
            
            
            //check if app crashed or was terminated by the user
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
           
            
            NSDate *dateAppWasLastRan = [defaults objectForKey:kDateAppLastRan];
            //            NSLog(@"dateAppWasLastLaunched: %@", dateAppWasLastRan);
            
            //            NSDate *dateAppWasTerminated = [defaults objectForKey:@"dateAppWasTerminated"];
            //            NSLog(@"dateAppWasTerminated: %@", dateAppWasTerminated);
            
            NSDate *todaysDate = [NSDate date];
            
            //            NSLog(@"todaysDate: %@", todaysDate);
            
            //find the day of the week string
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            
            NSTimeZone * timezone = [NSTimeZone timeZoneWithName: @"PST"];
            [dateFormatter setTimeZone:timezone];
            
            NSString * todaysDay = [dateFormatter stringFromDate:todaysDate];
            NSString * dayAppWasLastActivated = [dateFormatter stringFromDate:dateAppWasLastRan];
            
            //            NSLog(@"today's day %@", [dateFormatter stringFromDate:todaysDate]);
            //            NSLog(@"day app last launched %@", dayAppWasLastActivated);
            
            int myStepsGainedDelta;
            
            if([todaysDay isEqualToString:dayAppWasLastActivated])
            {
                myStepsGainedDelta = (int)numberOfSteps - myStoredSteps;
                [self.pointsValue  countFrom:myStoredSteps to:numberOfSteps withDuration:1];
                
            }
            else
            {
                myStepsGainedDelta = (int)numberOfSteps;
                [self.pointsValue  countFrom:0 to:numberOfSteps withDuration:1];
                
                
            }
            
            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
            
            [sharedDefaults setInteger:numberOfSteps forKey:@"totalNumberStepsToday"];
            [sharedDefaults synchronize];
            
            
            
            //            NSLog(@"Delta in mystats: %d", myPointsGainedDelta);
            [myRetrievedSteps setInteger:myStepsGainedDelta forKey:kMyStepsDelta];
            [myRetrievedSteps synchronize];
            
  
            
        }
    
        
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
        NSArray *arrayOfLeagueNames = [RetrievedTeams objectForKey:kArrayOfLeagueNames];

    return arrayOfLeagueNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DashboardTableViewCell *cell = (DashboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myTeamCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DashboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myTeamCell"];
    }

    
    // Configure the cell...
    [cell updateTeamCell:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int myRetreivedIndex = (int)indexPath.row ;
    
//    NSLog(@"myRetreivedIndex: %d", myRetreivedIndex);

    
   [self performSegueWithIdentifier:@"vs" sender:indexPath];

}

//pass the team to the teammates view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    VSTableViewController *transferViewController = segue.destinationViewController;
    

    
    if ([segue.identifier isEqualToString:@"vs"]) {
        
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        //we use this index to pass the correct data to the vs view controller
        int myRetreivedIndex = (int)indexPath.row ;
      
        [Amplitude logEvent:@"Dashboard: Game Details selected"];
       
       
//        NSLog(@"myRetreivedIndex in Segue: %d", myRetreivedIndex);
        
        
        [segue.destinationViewController initWithReceivedTeam:myRetreivedIndex];
        
        
        //send my team name to vs view controller
        DashboardTableViewCell *cell = (DashboardTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        transferViewController.myTeamReceived = [NSString stringWithFormat:@"%@",cell.nameOfMyTeamString];
        
        
        
    }
}



@end
