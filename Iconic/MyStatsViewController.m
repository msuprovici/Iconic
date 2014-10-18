//
//  MyStatsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "MyStatsViewController.h"
#import  <Parse/Parse.h>
#import "Constants.h"
#import "Cache.h"
#import "SimpleHomeViewController.h"
#import "CalculatePoints.h"

#import "UIImage+RoundedCornerAdditions.h"
#import "UIImage+ResizeAdditions.h"
#import <CoreMotion/CoreMotion.h>

@interface MyStatsViewController ()
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

@implementation MyStatsViewController



@synthesize timer = _timer;
@synthesize myProgress = _myProgress;
@synthesize xpProgressDial = _xpProgressDial;
//@synthesize simpleHomeViewController = _simpleHomeViewController;

//-(id)init
//{
//    _simpleHomeViewController = [[SimpleHomeViewController alloc]init];
//    return self;
//}

- (id)initWithPointsLabelNumber:(NSUInteger)pointslabel
{
    
    if (self = [super initWithNibName:@"MyStatsViewController" bundle:nil])
    {
        pointslabelNumber = (int) pointslabel;
        _didInitialize = NO;
        
        
    }
   
    return self;
}


- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
  
    
    
    [self getPlayerSteps];
    
    self.pointsOrSteps = YES;
   
    
    //Cycle through label string
    for (int i = 0; i <= pointslabelNumber; i++) {
       
        

        
        if (i == 0) {
            if (pointslabelNumber == 0) {
               
                
                
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
                self.xpProgressDial.hidden = false;
                [self progressDialChange];
                
                self.xpProgressDial.trackTintColor = PNLightGrey;
                self.xpProgressDial.progressTintColor = PNWeiboColor;
                
                self.xpProgressDial.thicknessRatio = .15f;
                self.xpProgressDial.roundedCorners = NO;
                
                //PNCircleChart
//                self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 40, 40) andTotal:[NSNumber numberWithInt:myTotalPointsToNextLevel] andCurrent:[NSNumber numberWithInt:myLevelProgress]];
//                
//                
//                
//                self.circleChart.backgroundColor = [UIColor clearColor];
//                self.circleChart.labelColor = [UIColor clearColor];
//                
//                [self.circleChart setStrokeColor:PNWeiboColor];
//                [self.circleChart setLineWidth:[NSNumber numberWithInt:6.8]];
//                [self.circleChart strokeChart];
//                
//                [self.xpProgressDial addSubview:self.circleChart];
                
                
                
                
                
//                NSLog(@"myRatio: %f", myProgressPercent);
               
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
                
    
                
                
//        NSInteger numberOfSteps = [[NSUserDefaults standardUserDefaults] integerForKey:STEPS_KEY];
//        self.stepsCountingLabel.text = [NSString stringWithFormat:@"%li", (long)numberOfSteps];
//        self.stepsCountingLabel.hidden = NO;
               
        //hide step count mini label as per new design
        self.stepsValue.hidden = true;
        self.stepsSubTitle.hidden = true;
                
                
        self.viewTitle.hidden = YES;
        self.statsImage.hidden = YES;
        self.xpLabel.text = @"XP";
        self.pointsLabel.text = @"Today's Steps";
                
        //barchart
        self.segmentedControl.hidden = YES;
        self.highValue.hidden = YES;
        self.mediumValue.hidden = YES;
        self.sevenDaysAgoDay.hidden = YES;
        self.todayDay.hidden = YES;
           
                
        //hide level as per new design
//                self.xpValue.hidden = true;
//                self.xpProgressDial.hidden = true;
//                self.xpLabel.hidden = true;
                
                
        //hide 7 day steps label
                self.sevenDaySteps.hidden = true;
                self.todaysSteps.hidden = false;
                self.todaysSteps.text = @"Today's Steps";
                
            //self.timeActiveLabel.hidden = YES;
                
           

//                self.xpProgressDial.hidden = true;
                
          
            
                
//            [self startAnimation];
                
                //show # days in a row with steps above average
                NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
                NSInteger streak = [defaults integerForKey:@"streak"];
                
                if (streak > 1) {
                    self.streak.text = [NSString stringWithFormat:@"%ld day streak",streak];
                }
                else
                {
                    self.streak.hidden = true;
                }
                

            }
        }
        
        if (i == 1)
        {
            
            if (pointslabelNumber == 1) {
            
            self.pointsImage.hidden = YES;
            self.stepsImage.hidden = YES;
                
                
//            self.timeActiveLabel.hidden = NO;
//            NSInteger numberOfSteps = [[NSUserDefaults standardUserDefaults] integerForKey:STEPS_KEY];
//            self.timeActiveLabel.text = [NSString stringWithFormat:@"%li", (long)numberOfSteps];
                
            self.streak.hidden = true;
            self.pointsLabel.hidden = true;
            self.xpLabel.hidden = true;
            self.pointsValue.hidden = true;
            self.xpValue.hidden = true;
            self.playerName.hidden = true;
            self.playerPhoto.hidden = true;
            self.stepsSubTitle.hidden = true;
            self.stepsCountingLabel.hidden = YES;

            self.pointsValue.hidden = true;
                self.stepsValue.hidden = true;
            
            self.xpValue.hidden = true;
            self.xpProgressDial.hidden = true;
            
                
                //hide today's steps label
                self.sevenDaySteps.hidden = false;
                self.todaysSteps.hidden = true;
                self.sevenDaySteps.text = @"7 Day Steps";
    
                
             //Bar chart
            self.segmentedControl.hidden = NO;
          
            self.mediumValue.hidden = NO;
            self.sevenDaysAgoDay.hidden = NO;
            self.todayDay.hidden = NO;
    
            
            //change font and size
            NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:20],NSFontAttributeName,  nil];
            [self.segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
                
            
                
            }
            
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
        
       

            
        
    }
    }



//- (void)progressDialChange:(float)ratio
- (void)progressDialChange
{
    
    NSArray *progressViews = @[self.xpProgressDial];
    for (DACircularProgressView *progressView in progressViews) {
        
        [progressView setProgress:self.myProgress animated:YES];
        
        
        
    }
}


//-(void)startAnimation
//{
////    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(progressDialChange:) userInfo:nil repeats:NO];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progressDialChange) userInfo:nil repeats:NO];
//    NSLog(@"startAnimation");
//}

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
//            self.pointsValue.text = [NSString stringWithFormat:@"%d",0] ;
            self.stepsValue.text = [@(numberOfSteps) stringValue];
            
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

//            NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
//            int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyMostRecentPointsBeforeSaving];
////            NSLog(@"kMyMostRecentPointsBeforeSaving in myStats: %d", myStoredPoints);
//            
//            int myPointsGainedDelta = [self.myPoints intValue] - myStoredPoints;
////            NSLog(@"Delta in mystats: %d", myPointsGainedDelta);
//            [myRetrievedPoints setInteger:myPointsGainedDelta forKey:@"myPointsDelta"];
//            [myRetrievedPoints synchronize];
            
            
            NSUserDefaults *myRetrievedSteps = [NSUserDefaults standardUserDefaults];
            
            int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyFetchedStepsToday];
            
//            int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyMostRecentStepsBeforeSaving];
            //            NSLog(@"kMyMostRecentPointsBeforeSaving in myStats: %d", myStoredPoints);
            
            
            self.stepsValue.formatBlock = ^NSString* (float value)
            {
                NSString* formatted = [formatter stringFromNumber:@((int)value)];
                return [NSString stringWithFormat:@"%@",formatted];
            };
            
            
            
            //check if app crashed or was terminated by the user
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//            BOOL  appWasTerminated = [defaults boolForKey:kAppWasTerminated];
            
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
                [self.pointsValue  countFrom:myStoredSteps to:numberOfSteps withDuration:1.5];
                
            }
            else
            {
                myStepsGainedDelta = (int)numberOfSteps;
                [self.pointsValue  countFrom:0 to:numberOfSteps withDuration:1.5];
                
                
            }

            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
            
            [sharedDefaults setInteger:numberOfSteps forKey:@"totalNumberStepsToday"];
            [sharedDefaults synchronize];

            
            
            
            
            //            NSLog(@"Delta in mystats: %d", myPointsGainedDelta);
            [myRetrievedSteps setInteger:myStepsGainedDelta forKey:kMyStepsDelta];
            [myRetrievedSteps synchronize];

            
//            [self.pointsValue  countFrom:myStoredPoints to:[self.myPoints intValue] withDuration:1.5];
            
            //            int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyMostRecentStepsBeforeSaving];
//            [self.stepsValue  countFrom:myStoredSteps to:numberOfSteps withDuration:1.5];
//            [self.pointsValue  countFrom:myStoredSteps to:numberOfSteps withDuration:1.5];
            

            
            
            
        }
        
        
        
        
    }];
    
    
 
}






//#pragma mark 7 Day points & steps
//
//- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
//    switch (sender.selectedSegmentIndex) {
//            //Points
//        case 0:
//
//        {
//            //points chart
//            
//            
//            //find max value in the array and insert it into the high value on for the y-axis
//            self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyPointsArray valueForKeyPath:@"@max.self"]];
//            
//            NSNumber *max = [self.myWeekleyPointsArray valueForKeyPath:@"@max.self"];
//            int midValue = [max intValue];
//            
//            //find mid value in the array and insert it into the high value on for the y-axis
//            self.mediumValue.text = [NSString stringWithFormat:@"%d",midValue/2];
//            
//            
//            [self.barChart setYValues:self.myWeekleyPointsArray];
//            [self.barChart strokeChart];
////            NSLog(@"segmented control points pressed");
//            
//            break;
//        }
//        case 1:
//        {
//            //steps chart
//            
//            //find max value in the array and insert it into the high value on for the y-axis
//            self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyStepsArray valueForKeyPath:@"@max.self"]];
//            
//            NSNumber *maxSteps = [self.myWeekleyStepsArray valueForKeyPath:@"@max.self"];
//            int midStepsValue = [maxSteps intValue];
//            
//            
//            //find mid value in the array and insert it into the high value on for the y-axis
//            self.mediumValue.text = [NSString stringWithFormat:@"%d",midStepsValue/2];
//            
//            
//            [self.barChart setYValues:self.myWeekleyStepsArray];
//            [self.barChart strokeChart];
////            NSLog(@"segmented control steps pressed");
//            
//            break;
//        }
//        default:
//            break;
//    }
//    
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
