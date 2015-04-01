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
#import <Foundation/Foundation.h>
#import "MyFinalScoresTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AchievmentsViewController.h"

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

@property (nonatomic, assign) BOOL receivedNotification;
@property (nonatomic, strong) CMMotionActivityManager *motionActivity;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property BOOL deltaPointsLabelIsAnimating;

//achievments
@property (nonatomic, strong) PFObject * teamAchievmentReceived;



@end

@implementation DashboardTableViewController

@synthesize timer = _timer;
@synthesize myProgress = _myProgress;
@synthesize xpProgressDial = _xpProgressDial;


- (void)dealloc {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"achievmentReceived" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JoinedTeam" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LeftTeam" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DefaultsSync" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self performSegueWithIdentifier:@"MyFinalScores" sender:self];//uncomment to test final scores view controler

    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
    [self setReceivedNotification:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTeamNotificationNow:)
                                                 name:@"JoinedTeam"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTeamNotificationNow:)
                                                 name:@"LeftTeam"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsSyncNotification:)
                                                 name:@"DefaultsSync"
                                               object:nil];
    
    
    //refreshes the app when it enters foreground
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshHomeViewNow)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    //achievment received
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedAchievementNotificationNow:)
                                                 name:@"achievmentReceived"
                                               object:nil];
    
    [self refreshHomeViewNow];
    [self updatedGameClock];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES ];
    
    // If we received joined/leave team notification update team charts
    if (self.receivedNotification == YES) {
       
        [self refreshHomeViewNow];
        self.receivedNotification = NO;
        
       
    }
  
   
}

#pragma mark Refresh Home View

-(void)refreshHomeViewNow
{
    
    //set date the app was last active
    //delaying by 3 seconds so to ensure that we don't reset this value right away.  We are using this value to compare with the last date the app ran.  If we don't delay, the date will always be reset to now.
    [self performSelector:@selector(findWhatDateAppActivated) withObject:self afterDelay:3.0];
    //show MyFinalScoresTableViewController if this is the 1st time a user opens the app this week
    [self firstAppLoadThisWeek];
    
    //we're updating the app data from the server 3 times so that the scores are always up to date.
    //if we don't do it, team scores are often inaccurate unless we close & refresh the app again.
    
    [self performSelector:@selector(updateAppDataFromServerNow) withObject:self afterDelay:2];
    
    [self populateMyStats];
    
    
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    int  numberOfTeams = (int)[RetrievedTeams integerForKey: kNumberOfTeams];
    
    if (numberOfTeams > 0) {
        [self beginDeltaPointsAnimationNow];
        self.myTeamsLabel.hidden = FALSE;
        self.gameClock.hidden = FALSE;
    }
    else
    {
        self.myTeamsLabel.hidden = TRUE;
        self.gameClock.hidden = TRUE;
        self.deltaPoints.hidden = TRUE;
    }
    
//     NSLog(@"referesh home view");
    
    
    
}


-(void)populateMyStats
{
    
    
    
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
//    NSLog(@"self.myProgress: %f", self.myProgress);
    
    //DACircularChart
    
    [self progressDialChange];
    
    self.xpProgressDial.trackTintColor = PNLightGrey;
    self.xpProgressDial.progressTintColor = PNWeiboColor;
    
    self.xpProgressDial.thicknessRatio = .15f;
    self.xpProgressDial.roundedCorners = NO;
    
    
    
    
    
    
    //counting label for my steps text reformating
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
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 300, 140)];
    
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
    
    
    //get today's steps
    [self getPlayerSteps];
    
    //reload the table view
    [self.tableView reloadData];
    

}

-(void)updatedGameClock
{
    //game clock
    
    
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:self.gameClock andTimerType:MZTimerLabelTypeTimer];
    // [timer setCountDownTime:15]; //** Or you can use [timer setCountDownToDate:aDate];
    
    
    //get date & time for parse
    
    PFQuery *query = [PFQuery queryWithClassName:kTimerClass];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query getObjectInBackgroundWithId:@"FZm9YjkgEb" block:^(PFObject *object, NSError *error) {
        
        
        
        if (!error) {
            
            //Get timeStamp from the parse timer object
            //timer object rests itself at 12:00am on Sunday
            
            NSDate * timeStamp = [object updatedAt];
            
            //add 7 days to the time stamp
            int daysToAdd = 7;
            NSDate *newDate = [timeStamp dateByAddingTimeInterval:60*60*24*daysToAdd];
            
            
            //Set timer
            [timer setCountDownToDate:newDate];
            timer.delegate = self;
            [timer start];
        }
        
        else
        {
            
        }
        
    }];

}

//method to show days in timer label

- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    
    int second = (int)time  % 60;
    int minute = ((int)time / 60) % 60;
    int hours = ((int)time / 3600 )% 24;
    int days = (((int)time / 3600) / 24)% 60;
    
    return [NSString stringWithFormat:@"%01d:%02d:%02d:%02d", days,hours,minute,second];
}



//method to show days in timer label
- (void)progressDialChange
{
    
    NSArray *progressViews = @[self.xpProgressDial];
    for (DACircularProgressView *progressView in progressViews) {
        
        [progressView setProgress:self.myProgress animated:YES];
//        NSLog(@"progress Indicator fired");

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




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    int  numberOfTeams = (int)[RetrievedTeams integerForKey: kNumberOfTeams];
    
    if (numberOfTeams == 0) {
        return 1;
    }
    else return numberOfTeams;
}

//dirty way to hide all other cells that do not contain data
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIColor *color = [UIColor whiteColor];
    
    view.backgroundColor = color;
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DashboardTableViewCell *cell = (DashboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myTeamCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DashboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myTeamCell"];
    }
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    int  numberOfTeams = (int)[RetrievedTeams integerForKey: kNumberOfTeams];

    
    if (numberOfTeams == 0) {
        cell.joinTeamButtonImage.hidden = FALSE;
        
        cell.myLeagueName.hidden = TRUE;
        cell.MyTeamName.hidden = TRUE;
        cell.MyTeamScore.hidden = TRUE;
        cell.vsTeamName.hidden = TRUE;
        cell.VSTeamScore.hidden = TRUE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    else
    {
        cell.myLeagueName.hidden = FALSE;
        cell.MyTeamName.hidden = FALSE;
        cell.MyTeamScore.hidden = FALSE;
        cell.vsTeamName.hidden = FALSE;
        cell.VSTeamScore.hidden = FALSE;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.joinTeamButtonImage.hidden = TRUE;
    // Configure the cell...
    [cell updateTeamCell:indexPath.row];
        
    }
    
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
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    int  numberOfTeams = (int)[RetrievedTeams integerForKey: kNumberOfTeams];

    if(numberOfTeams == 0)
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
        [Amplitude logEvent:@"Dashboard: Join Team selected"];
    }
    else
    {
        [self performSegueWithIdentifier:@"vs" sender:indexPath];
    }

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
    
    //show final scores
    if ([[segue identifier] isEqualToString:@"ShowAchievment"])
    {
        
        //        NSLog(@"achievment object: %@", self.teamAchievmentReceived);
        
        
        [segue.destinationViewController initWithAchievment:self.teamAchievmentReceived];
        
        
    }

}


#pragma mark NSNotifications methods

- (void) receiveTeamNotificationNow:(NSNotification *) notification
{
    //reload view if a player has joined a team
    
    if ([[notification name] isEqualToString:@"JoinedTeam"])
    {
        
        
        [self refreshHomeViewNow];
        [self setReceivedNotification:YES];
        //        NSLog(@"Received Joined Team Notification on home screen");
        
        //        if (self.joinedTeamButtonPressed  == YES) {
        
        //        self.joinedTeamButtonPressed  = YES;
        //            NSLog(@"Player joined 1st team in simple");
        
        //            self.joinedTeamButtonPressed = NO;
        //this is where you need to give the bonus and reload the view?
        
        //        }
        
        
        
    }
    if ([[notification name] isEqualToString:@"LeftTeam"])
    {
        
        [self refreshHomeViewNow];
        [self setReceivedNotification:YES];
        
        NSLog(@"Received Leave Team Notification on home screen");
    }
}

-(void)receivedAchievementNotificationNow:(NSNotification *) notification
{
    if([[notification name] isEqualToString:@"achievmentReceived"])
    {
        //        NSLog(@"achievmentReceived notification");
        
        NSDictionary* userInfo = notification.userInfo;
        self.teamAchievmentReceived = userInfo[@"achievment"];
        
        
        
        [self performSegueWithIdentifier:@"ShowAchievment" sender:self];
    }
}

-(void)defaultsSyncNotification:(NSNotification *) notification
{
    if([[notification name] isEqualToString:@"DefaultsSync"])
    {
        [self performSelector:@selector(reoladTableView) withObject:self afterDelay:3.0];
    }
}

-(void)reoladTableView
{
    [self.tableView reloadData];
//    NSLog(@"reoladTableView");
    
}


#pragma mark - Navigation

-(void)firstAppLoadThisWeek
{
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSObject * checkValue = [defaults objectForKey:@"hasRunAppThisWeekKey"];
    if(checkValue != nil)
    {
        
        if ([defaults boolForKey:@"hasRunAppThisWeekKey"] == NO)
        {
            // Show Final Scores
            [self performSegueWithIdentifier:@"MyFinalScores" sender:self];
            
            [defaults setBool:YES forKey:@"hasRunAppThisWeekKey"];
            
        }
        
    }
}



-(void)updateAppDataFromServerNow
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, (unsigned long)NULL), ^(void)
                   {
//                       NSLog(@"updateAppDataFromServerNow");
                       CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
                       [calculatePointsClass retrieveFromParse];
                       //                       [calculatePointsClass incrementPlayerPointsInBackground];//commeted this out because it was incrementing my steps value 2x
                       [calculatePointsClass findPastWeekleySteps];
                       
                       
                       //update core data with most recent league data
                       //        [calculatePointsClass migrateLeaguesToCoreData];
                       
                       //        NSLog(@"Calling this in 10 seconds");
                       
                   });
}


-(void)findWhatDateAppActivated
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:kDateAppLastRan];
    [defaults synchronize];
    [self.tableView reloadData];

}




#pragma mark - Delta Label Animation

-(void)beginDeltaPointsAnimationNow
{
    
    self.deltaPoints.hidden = YES;
    
    //wait untill the countdown is almost finished to begin animation
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(animateDeltaPointsLabelNow) userInfo:nil repeats:NO];
    
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
    
    
    
    //    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    //        [calculatePointsClass retrieveFromParse];
    //        [calculatePointsClass incrementPlayerPointsInBackground];
    
    
    
    
    
    
}

-(void)animateDeltaPointsLabelNow
{
    //show deltaPoints label
    self.deltaPoints.hidden = NO;
    
    //populate the deltaValueLabel
    NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
    
    int myStepsDelta = (int)[myRetrievedPoints integerForKey:kMyStepsDelta];
    //    int  numberOfTeams = (int)[myRetrievedPoints integerForKey: kNumberOfTeams];
    
    
    //    NSLog(@"Delta in simplehomeviewcontroller: %d", myStepsDelta);
    
    
    
    if(myStepsDelta > 0)
    {
        self.deltaPoints.text = [NSString stringWithFormat:@"+%d", myStepsDelta];
        
        //        CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
        //        [calculatePointsClass retrieveFromParse];
        //        [calculatePointsClass incrementPlayerPointsInBackground];
        //        [self performSelector:@selector(refreshHomeView) withObject:self afterDelay:3.0 ];
        
        
        
    }
    else
    {
        
        //comment out this line to test deltaLabel animations
        self.deltaPoints.text = @"";
        
    }
    
    
    //animated label that shows the points the player contributed to his or her team(s)
    self.deltaPoints.center = CGPointMake(140, 115);
    float newX = 150.0f;
    float newY = 265.0f;
    
    //animate the label so that it drops right on top of my team score
    [UIView transitionWithView:self.deltaPoints
                      duration:1.5f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        
                        self.deltaPointsLabelIsAnimating = YES;
                        
                        
                        
                        self.deltaPoints.center = CGPointMake(newX, newY);
                        [self fadeinAnimation];
                    }
                    completion:^(BOOL finished) {
                        // Hide label
                        self.deltaPoints.hidden = YES;
//                        [self.tableView setNeedsDisplay];
                }];
    
}

// fade in delta label
-(void) fadeinAnimation
{
    self.deltaPoints.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //don't forget to add delegate.....
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:0.8];
    self.deltaPoints.alpha = 1;
    
    //also call this before commit animations......
    [UIView setAnimationDidStopSelector:@selector(animationDidStopNow:finished:context:)];
    [UIView commitAnimations];
}



-(void)animationDidStopNow:(NSString *)animationID finished:(NSNumber *)finished    context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.8];
    self.deltaPoints.alpha = 0;
    [UIView commitAnimations];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end