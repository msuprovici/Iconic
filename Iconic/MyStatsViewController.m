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
@property NSMutableArray *myWeekleyPointsArray;
@property NSMutableArray *myWeekleyStepsArray;
@property NSNumber *maxValueInArray;

@end

@implementation MyStatsViewController


@synthesize xpProgressView = _xpProgressView;
@synthesize xpProgressDial = _xpProgressDial;
@synthesize timer = _timer;
@synthesize myProgress = _myProgress;
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

//- (id) init {
//    self = [super init];
//    //Basic empty init...
//    _simpleHomeViewController = [[SimpleHomeViewController alloc]init];
//    return self;
//}


//+ (void)initialize {
//    
//    if(self)
//    {
//    _simpleHomeViewController = [[SimpleHomeViewController alloc]init];
//    }
//
//    
//}

//static dispatch_once_t once;
//dispatch_once(&once, ^ {
//    // Code to run once
//});

- (void)viewDidLoad
{
    
    //    [self retrievePlayerStats];
    

    
    
    [super viewDidLoad];
    
    
    
    [self getPlayerSteps];
    
    self.pointsOrSteps = YES;
   
    
    //Cycle through label string
    for (int i = 0; i <= pointslabelNumber; i++) {
       
        

        
        if (i == 0) {
            if (pointslabelNumber == 0) {
               
                
                
                NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
                
                //find my curent level
                int myLifetimePoints = (int)[myRetrievedPoints integerForKey:kMyPointsTotal];
//                NSLog(@"myLifetimePoints: %d", myLifetimePoints);
//                NSLog(@"myLevel: %@", myLevel);
                
                NSNumber *myLevel = [self calculateLevel:myLifetimePoints];
                

                
                float myLevelValue = [myLevel floatValue];
//                NSLog(@"myLevelValue: %f", myLevelValue);
                
                //calculate total points to reach next level
                NSNumber *totalPointsForNextLevel = [self calculatePointsToReachNextLevel:myLevelValue];
                int myTotalPointsForNextLevelValue = [totalPointsForNextLevel intValue];
                
//                NSLog(@"myTotalPointsForNextLevelValue: %d", myTotalPointsForNextLevelValue);
                
                //calculate total points to reach current level
                NSNumber *totalPointsForCurrentLevel = [self calculatePointsToReachCurrentLevel:myLevelValue];
                
                int myTotalPointsForCurrentLevelValue = [totalPointsForCurrentLevel intValue];
                
//                NSLog(@"myTotalPointsForCurrentLevelValue: %d", myTotalPointsForCurrentLevelValue);
                
                
                //calculate % progress
                
                
                float myLevelProgress = (myLifetimePoints - myTotalPointsForCurrentLevelValue);
//                NSLog(@"myLevelProgress: %f", myLevelProgress);
                
                float myTotalPointsToNextLevel = (myTotalPointsForNextLevelValue - myTotalPointsForCurrentLevelValue);
//                NSLog(@"myTotalPointsToNextLevel: %f", myTotalPointsToNextLevel);
                
                
                float myProgressPercent = myLevelProgress/myTotalPointsToNextLevel;
                self.myProgress = myProgressPercent;
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
                //use previously stored value to determine the previous level
                int myPreviousLifetimePoints = (int)[myRetrievedPoints integerForKey:kMyMostRecentTotalPointsBeforeSaving];
                
                NSNumber *myPreviousLevel = [self calculateLevel:myPreviousLifetimePoints];
                //count up the level number
                [self.xpValue  countFrom:[myPreviousLevel intValue] to:[myLevel intValue] withDuration:2];
                
                
        [self progressDialChange];
                
                
//        NSInteger numberOfSteps = [[NSUserDefaults standardUserDefaults] integerForKey:STEPS_KEY];
//        self.stepsCountingLabel.text = [NSString stringWithFormat:@"%li", (long)numberOfSteps];
//        self.stepsCountingLabel.hidden = NO;
                
                
        self.viewTitle.hidden = YES;
        self.statsImage.hidden = YES;
        self.xpLabel.text = @"Level";
        self.pointsLabel.text = @"Points";
                
        //barchart
        self.segmentedControl.hidden = YES;
        self.highValue.hidden = YES;
        self.mediumValue.hidden = YES;
        self.sevenDaysAgoDay.hidden = YES;
        self.todayDay.hidden = YES;
                
            //self.timeActiveLabel.hidden = YES;
                
            self.stepsProgressDial.hidden = true;

            
            self.xpProgressDial.trackTintColor = PNLightGrey;
            self.xpProgressDial.progressTintColor = PNWeiboColor;
            
                
//            [self startAnimation];
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
            self.stepsProgressDial.hidden = true;
            self.xpProgressDial.hidden = true;
             
                
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
            
            [self.barChart setYValues:self.myWeekleyPointsArray];
            [self.barChart strokeChart];
            
            [self.barChart setStrokeColor:PNWeiboColor];
            [self.barChart setBarBackgroundColor:PNWhite];
            [self.barChart strokeChart];
            
            [self.stepsBarChart addSubview:self.barChart];
            
            
            //set Y labels for chart
            self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyPointsArray valueForKeyPath:@"@max.self"]];
            
            NSNumber *max = [self.myWeekleyPointsArray valueForKeyPath:@"@max.self"];
            int midValue = [max intValue];
            
            self.mediumValue.text = [NSString stringWithFormat:@"%d",midValue/2];
            
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
        
        self.xpProgressDial.thicknessRatio = .25f;
        self.xpProgressDial.roundedCorners = NO;

            
        
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


//calculate a player's steps
-(void)getPlayerSteps
{
    self.stepCounter = [[CMStepCounter alloc] init];
    NSDate *now = [NSDate date];
//    NSDate *from = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:now];
    
    
    
    
    //find today's date
    NSDate* sourceDate = [NSDate date];
    
    //convert to my local time zone
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* myTimeZone = [NSTimeZone localTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger myGMTOffset = [myTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = myGMTOffset - sourceGMTOffset;
    
    NSDate* myDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate]init];
    
    
    
    //NSDate *from = [self beginningOfDay:[NSDate date]];
//    NSDate *now = myDate;
    NSDate *from = [self beginningOfDay];
    
    
//    NSLog(@"time now: %@",now);
//    NSLog(@"time from: %@",from);

    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        
//        NSLog(@"numberOfSteps: %ld",(long)numberOfSteps);

        
//        self.stepsCountingLabel.text = [@(numberOfSteps) stringValue];
        
        //prevent NAN values
        if (numberOfSteps == 0) {
            self.myPoints = 0;
            self.pointsValue.text = [NSString stringWithFormat:@"%d",0] ;
            self.stepsValue.text = [@(numberOfSteps) stringValue];
            
        }
        else
        {
        self.myPoints = [self calculatePoints:numberOfSteps];
//        self.pointsValue.text = [NSString stringWithFormat:@"%@",self.myPoints] ;
//        [self.pointsValue countFrom:0 to:[self.myPoints intValue]];
//        [self.pointsValue countFrom:0 to:100];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = kCFNumberFormatterNoStyle;
            self.pointsValue.formatBlock = ^NSString* (float value)
            {
                NSString* formatted = [formatter stringFromNumber:@((int)value)];
                return [NSString stringWithFormat:@"%@",formatted];
            };

            NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
            int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyMostRecentPointsBeforeSaving];
            
            [self.pointsValue  countFrom:myStoredPoints to:[self.myPoints intValue] withDuration:2];
            
            
            self.stepsValue.formatBlock = ^NSString* (float value)
            {
                NSString* formatted = [formatter stringFromNumber:@((int)value)];
                return [NSString stringWithFormat:@"%@",formatted];
            };
            
            int myStoredSteps = (int)[myRetrievedPoints integerForKey:kMyMostRecentStepsBeforeSaving];
            [self.stepsValue  countFrom:myStoredSteps to:numberOfSteps withDuration:2];
            
            
        }
        
        
        
        
    }];
    
    
    //use this to calculate how long the person spent driving, walking, running, stationary
//    CMMotionActivityManager *motionActivityManagerQuery = [[CMMotionActivityManager alloc] init];
//    
//    
//    [motionActivityManagerQuery queryActivityStartingFromDate:from toDate:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray *activities, NSError *error) {
//        
//        
//        for(CMMotionActivity *motionActivity in activities){
//            
//            if(motionActivity.walking)
//            {
//           // NSTimeInterval walking = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval walking = [motionActivity.startDate timeIntervalSinceDate:from];
//                
//                NSLog(@"walking %f", walking/60);
//            }
//            
//            if(motionActivity.stationary)
//            {
//                //NSTimeInterval stationary = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval stationary = [motionActivity.startDate timeIntervalSinceDate:from];
//                
//                NSLog(@"stationary %f", stationary/60);
//            }
//            
//            if(motionActivity.running)
//            {
////                NSTimeInterval running = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval running = [motionActivity.startDate timeIntervalSinceDate:from];
//                
//                NSLog(@"running %f", running/60);
//            }
//            
//            
//            if(motionActivity.unknown)
//            {
//                //                NSTimeInterval running = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval unknown = [motionActivity.startDate timeIntervalSinceDate:from];
//                
//                NSLog(@"unknown %f", unknown/60);
//            }
//            
//            if(motionActivity.automotive)
//            {
//                //                NSTimeInterval running = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval automotive = [motionActivity.startDate timeIntervalSinceDate:from];
//                
//                NSLog(@"automotive %f", automotive/60);
//            }
//
//
//
//
////            
////            NSLog(@"--------------------");
////            
////            // startDate
////            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
////            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////            NSString *startDateString = [dateFormatter stringFromDate:motionActivity.startDate];
////            NSLog(@"startDate = %@", startDateString);
////            
////            // stationary
////            NSLog(@"motionActivity.stationary = %@", motionActivity.stationary?@"YES":@"NO");
////            
////            // walking
////            NSLog(@"motionActivity.walking = %@", motionActivity.walking?@"YES":@"NO");
////            
////            // running ．
////            NSLog(@"motionActivity.running = %@", motionActivity.running?@"YES":@"NO");
////            
////            // automotive ．
////            NSLog(@"motionActivity.automobile = %@", motionActivity.automotive?@"YES":@"NO");
////            
////            // unknown
////            NSLog(@"motionActivity.unknown = %@", motionActivity.unknown?@"YES":@"NO");
////            
////            // confidence
////            NSString *confidenceString = @"";
////            switch (motionActivity.confidence) {
////                case CMMotionActivityConfidenceLow:
////                    confidenceString = @"CMMotionActivityConfidenceLow";
////                    break;
////                case CMMotionActivityConfidenceMedium:
////                    confidenceString = @"CMMotionActivityConfidenceMedium";
////                    break;
////                case CMMotionActivityConfidenceHigh:
////                    confidenceString = @"CMMotionActivityConfidenceHigh";
////                    break;
////                default:
////                    confidenceString = @"???";
////                    break;
////            }
////            NSLog(@"confidence = %@", confidenceString);
//            
//        }
//    
//     
//        
//    }];

}



//find the beginning of the day
-(NSDate *)beginningOfDay
{

    //find the beginning of the day
    //nsdate always returns GMT
    NSDate *now = [NSDate date];
//    NSLog(@"now date: %@",now);
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    
    //NSLog(@"Local Time Zone %@",[[NSTimeZone localTimeZone] name]);
    
//     NSLog(@"Calendar date: %@",[cal dateFromComponents:components]);
    
    //convert GMT to my local time
//    NSDate* sourceDate = [cal dateFromComponents:components];
//    
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone* myTimeZone = [NSTimeZone localTimeZone];
//    
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
//    NSInteger myGMTOffset = [myTimeZone secondsFromGMTForDate:sourceDate];
//    NSTimeInterval interval = myGMTOffset - sourceGMTOffset;
//    
//    NSDate* myDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate]init];
    
    
//    NSLog(@"Converted date: %@",myDate);
//    NSLog(@"Source date: %@",myDate);
   
    return [cal dateFromComponents:components];
    //return myDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)savePoints
//{
//    
//    //test points value here
//    //will need points
//    NSNumber *newPoints = [self calculatePoints:108];
//    
//    
//    // Save points to ativity class
//    
//    PFObject *activity = [PFObject objectWithClassName:kActivityClassKey];
//    [activity setObject:[PFUser currentUser] forKey:kActivityUserKey];
//    [activity setObject:newPoints forKey:kActivityKey];
//    
//    // Activity is public, but may only be modified by the user
//    PFACL *activityACL = [PFACL ACLWithUser:[PFUser currentUser]];
//    [activityACL setPublicReadAccess:YES];
//    activity.ACL = activityACL;
//    
//    
//    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            //  NSLog(@"Points uploaded");
//            [[Cache sharedCache] setAttributesForActivity:activity likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
//            
//        }
//        
//        else {
//            NSLog(@"Points failed to save: %@", error);
//        }
//        
//    }];
//    
//    //increment the player's points
//    PFObject *playerPoints = [PFUser currentUser];
//    
//    //increment the player's TOTAL lifetime points
//    [playerPoints incrementKey:kPlayerPoints byAmount:newPoints];
//    
//    //increment the player's today's points
//    [playerPoints incrementKey:kPlayerPointsToday byAmount:newPoints];
//    
//    [playerPoints saveInBackground];
//    
//    
//    //increment team's points by
//    
//    //Query Team Class
//    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
//    
//    //Query Teamates Class
//    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
//    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    
//    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
//    
//    
//    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        
//        
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu objects", (unsigned long)objects.count);
//            for (PFObject *object in objects)
//                
//            {
//                NSLog(@"%@", object.objectId);
//                
//                
//                if (!error) {
//                    
//                    //increment the team's TOTAL points
//                    [object incrementKey:kScore byAmount:newPoints];
//                    
//                    //increment the team's points for today
//                    [object incrementKey:kScoreToday byAmount:newPoints];
//                    
//                    [object saveInBackground];
//                }
//                else
//                {
//                    NSLog(@"error in inner query");
//                }
//            }
//            
//        }
//        else
//        {
//            NSLog(@"error");
//        }
//        
//        
//        
//        
//    }];
//}



//subclass these methods to eliminate redundancy...


-(NSNumber*)calculatePoints:(float)steps
{
    
    //alogrithm for generating points from steps: yourPoints = ((0.85^( ln(steps) /ln (2)))/time)*steps*constantValue
    //Converting float to NSNumber
    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50)];//rounded up to the largest following integer using ceiling function
    
    
    return points;
}

-(NSNumber*)calculateLevel:(float)points
{
    
    //scale = 1
    //hardcoded for now - will need to send this number down from the server
    //had to add 1.0 to increment the level number so that the level is never 0
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * level = [NSNumber numberWithFloat: floor((pow((points/1000), (1/1)))+1.0)];
    
       return level;
}

-(NSNumber*)calculatePointsToReachNextLevel:(float)level
{
    
    //scale = 1
    //hardcoded for now - will need to send this number down from the server
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level, 1)*1000))+1];
    
    return points;
}

-(NSNumber*)calculatePointsToReachCurrentLevel:(float)level
{
    
    //scale = 1
    //hardcoded for now - will need to send this number down from the server
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level-1, 1)*1000))+1];
    
    return points;
}



- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
            //Points
        case 0:

        {
            //points chart
            
            //find max value in the array and insert it into the high value on for the y-axis
            self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyPointsArray valueForKeyPath:@"@max.self"]];
            
            NSNumber *max = [self.myWeekleyPointsArray valueForKeyPath:@"@max.self"];
            int midValue = [max intValue];
            
            //find mid value in the array and insert it into the high value on for the y-axis
            self.mediumValue.text = [NSString stringWithFormat:@"%d",midValue/2];
            
            
            [self.barChart setYValues:self.myWeekleyPointsArray];
            [self.barChart strokeChart];
//            NSLog(@"segmented control points pressed");
            
            break;
        }
        case 1:
        {
            //steps chart
            
            //find max value in the array and insert it into the high value on for the y-axis
            self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyStepsArray valueForKeyPath:@"@max.self"]];
            
            NSNumber *maxSteps = [self.myWeekleyStepsArray valueForKeyPath:@"@max.self"];
            int midStepsValue = [maxSteps intValue];
            
            
            //find mid value in the array and insert it into the high value on for the y-axis
            self.mediumValue.text = [NSString stringWithFormat:@"%d",midStepsValue/2];
            
            
            [self.barChart setYValues:self.myWeekleyStepsArray];
            [self.barChart strokeChart];
//            NSLog(@"segmented control steps pressed");
            
            break;
        }
        default:
            break;
    }
    
}
@end
