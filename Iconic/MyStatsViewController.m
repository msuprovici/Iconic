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
   
    
//     PFQuery* query = [PFUser query];
//        [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
//        //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//        PFUser* currentUser = [PFUser currentUser];
//    //getting historical daily points arary from server
//    NSMutableArray * playerPoints = [currentUser objectForKey:kPlayerPointsWeek];
//    NSLog(@"playerPoints: %@", playerPoints);
    
//    //we add todays most uptodate data to the array
//    [playerPoints addObject:[currentUser objectForKey:kPlayerPointsToday]];
//    NSLog(@"playerPoints2: %@", playerPoints);
//    SimpleHomeViewController * simpleHomeViewController; //=[[SimpleHomeViewController alloc]init];
//    static BOOL didInitialize = NO;
   
    
    //Cycle through label string
    for (int i = 0; i <= pointslabelNumber; i++) {
       
        

        
        if (i == 0) {
            if (pointslabelNumber == 0) {
               
            // This is to generate thumbnail a player's thumbnail, name & title
            
            
//            if (currentUser) {
                NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
                int myLifetimePoints = (int)[myRetrievedPoints integerForKey:kMyPointsTotal];
//                NSLog(@"myLifetimePoints: %d", myLifetimePoints);
                
                NSNumber *myLevel = [self calculateLevel:myLifetimePoints];
//                NSLog(@"myLevel: %@", myLevel);
                
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
               
                
                //set the right level
                self.xpValue.text = [NSString stringWithFormat:@"%@",myLevel];

                
//                [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                    
//                    if(!error)
//                    {
//                    
////                    self.xpValue.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerXP]];
//                    
//                    //Get my lifetime points
//                     NSNumber* myLifetimePoints = [object objectForKey:kPlayerPoints];
//                   NSLog(@"myLifetimePoints: %@", myLifetimePoints);
//                     float myPointsValue = [myLifetimePoints floatValue];
//                    
//                    
//                    float retrievedLevelValue = [myLifetimePoints floatValue];
//                    NSNumber *myLevel = [self calculateLevel:retrievedLevelValue];
//                    float myLevelValue = [myLevel floatValue];
//                    
//                    //calculate total points to reach next level
//                    NSNumber *totalPointsForNextLevel = [self calculatePointsToReachNextLevel:myLevelValue];
//                    int myTotalPointsForNextLevelValue = [totalPointsForNextLevel intValue];
////                    NSLog(@"myTotalPointsForNextLevelValue: %d", myTotalPointsForNextLevelValue);
//                    
//                    //calculate total points to reach current level
//                    NSNumber *totalPointsForCurrentLevel = [self calculatePointsToReachCurrentLevel:myLevelValue];
//                    int myTotalPointsForCurrentLevelValue = [totalPointsForCurrentLevel intValue];
////                    NSLog(@"myTotalPointsForCurrentLevelValue: %d", myTotalPointsForCurrentLevelValue);
//                    
//
//                    //calculate % progress
//                     self.myProgress = (myPointsValue - myTotalPointsForCurrentLevelValue)/(myTotalPointsForNextLevelValue - myTotalPointsForCurrentLevelValue);
////
//                    
//                    //set the right level
//                    self.xpValue.text = [NSString stringWithFormat:@"%@",myLevel];
////                    NSLog(@"myPointsValue: %f", myProgress);
//                    
//                    //animate the progress dial
////                    [self progressDialChange:myProgress];
////                        [self progressDialChange:myProgress];
//                    }
//                    else
//                    {
//                        NSLog(@"e");
//                    }
//                    
//
//                    
//               
//                }];
                
                
//            }
                [self progressDialChange];
        self.stepsImage.hidden = YES;
        self.stepsCountingLabel.hidden = YES;
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
                
                self.viewTitle.hidden = YES;
                 self.stepsCountingLabel.hidden = NO;
                self.xpValue.hidden = YES;

//            self.viewTitle.text = @"Today";
            self.xpLabel.text = @"Steps"; //[NSString stringWithFormat:@"XP", myArray[i]];
            self.pointsLabel.text = @"Active";
        
            //self.xpLabel.hidden = YES;
            //self.pointsLabel.hidden = YES;
                

            
            self.stepsProgressDial.trackTintColor = PNGrey;
            self.stepsProgressDial.progressTintColor = PNDarkBlue;
                
            self.xpProgressDial.hidden = YES;
            
//            self.xpProgressDial.trackTintColor = PNGrey;
//            self.xpProgressDial.progressTintColor = PNMauve;
//            
            self.stepsProgressDial.thicknessRatio = 1.0f;
            
                        
            self.timeActiveLabel.text = @"60%";
           // self.pointsValue.hidden = YES;
            
            
            self.xpValue.text = @"2349";
            self.pointsImage.hidden = YES;
            
                
                //barchart
                self.segmentedControl.hidden = YES;
                self.highValue.hidden = YES;
                self.mediumValue.hidden = YES;
                self.sevenDaysAgoDay.hidden = YES;
                self.todayDay.hidden = YES;
               
            
//            [self startAnimation];
            }

        }
        if (i == 2)
        {
            
            if (pointslabelNumber == 2) {
            
            self.pointsImage.hidden = YES;
            self.stepsImage.hidden = YES;
            self.stepsCountingLabel.hidden = YES;
            self.timeActiveLabel.hidden = YES;
            self.pointsLabel.hidden = true;
            self.xpLabel.hidden = true;
            self.pointsValue.hidden = true;
            self.xpValue.hidden = true;
            self.playerName.hidden = true;
            self.playerPhoto.hidden = true;
            
            //self.viewTitle.hidden = true;
            
            self.pointsValue.hidden = true;
            
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
            
            self.viewTitle.text = @"Points";
            
           
            
            
                
           //getting historical daily points arary from server
//            NSMutableArray * playerPoints = [currentUser objectForKey:kPlayerPointsWeek];
//            
//            //we add todays most uptodate data to the array
//            [playerPoints addObject:[currentUser valueForKey:kPlayerPointsToday]];
            
            
//            int indexValue = [playerPoints indexOfObject:playerPoints.lastObject];
//                
//            
//            [playerPoints replaceObjectAtIndex:indexValue withObject:[currentUser valueForKey:kPlayerPointsToday]];
//            if (_didInitialize == YES)
//            {
//                return;
//            }
//            else{
//                _didInitialize = YES;
//                /* initialize my stuff */
//                
//                _simpleHomeViewController = [[SimpleHomeViewController alloc]init];
//            }

            
            
            
//            //set the labels
//            [barChart setXLabels:daysPlayed];
//            
//            [barChart setYValues:simpleHomeViewController.playerPoints];
//            
//            //sets the maximum value of the label.  so if the player has a goal of say 10k points/day then we would use this.
//            //[barChart setYLabels:@[@500]];
//            
//            
//            [barChart setStrokeColor:PNWeiboColor];
//            [barChart setBarBackgroundColor:PNWhite];
//            [barChart strokeChart];
//            
//            [self.stepsBarChart addSubview:barChart];
            //}];
            
            
            //create bar chart to display days
//            PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
           
             self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(20, 0, 300, 170)];
            
            //list of days of the week
            NSArray * daysArray = @[@"S",@"M",@"T",@"W",@"T", @"F", @"S"];
            
            NSUserDefaults *myWeekleyPoints = [NSUserDefaults standardUserDefaults];
            
            self.myWeekleyPointsArray = [myWeekleyPoints objectForKey:kMyPointsWeekArray];
            
            self.myWeekleyStepsArray = [myWeekleyPoints objectForKey:kMyStepsWeekArray];

            NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, [self.myWeekleyPointsArray count])];

            
            //set the labels
//            [barChart setXLabels:daysPlayed];
            
//            [self.barChart setXLabels:daysPlayed];
//            if(self.pointsOrSteps == YES)
//            {
//                
//                NSLog(@"points pressed");
//            [self.barChart setYValues:self.myWeekleyPointsArray];
////            [self.barChart strokeChart];
//            }
//            else
//            {
//                NSLog(@"steps pressed");
//                [self.barChart setYValues:self.myWeekleyStepsArray];
////                [self.barChart strokeChart];
//            }
            
            //sets the maximum value of the label.  so if the player has a goal of say 10k points/day then we would use this.
            //[barChart setYLabels:@[@500]];
            
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

            
        }
        
        self.xpProgressDial.thicknessRatio = .25f;
        self.xpProgressDial.roundedCorners = NO;
//        self.stepsProgressDial.thicknessRatio = .25f;
//        self.stepsProgressDial.roundedCorners = YES;
        
    }
    }
//retrive table view data from parse



//-(void)viewDidAppear:(BOOL)animated
//{
//    [self getPlayerSteps];
//}

//- (void)progressDialChange:(float)ratio
- (void)progressDialChange
{
    
    NSArray *progressViews = @[self.xpProgressDial, self.stepsProgressDial ];
    for (DACircularProgressView *progressView in progressViews) {
        
        [progressView setProgress:self.myProgress animated:YES];
        
        
        
//        float progress = ratio;
        
//        float progress = .25;
//      [progressView setProgress:progress animated:YES];
        
//        if (progressView.progress >= 0.0f && [self.timer isValid]) {
//            [progressView setProgress:self.myProgress animated:YES];
//        }
        
//        if (progressView.progress >= 0.0f ) {
//            [progressView setProgress:progress animated:YES];
//        }
    }
}


//-(void)startAnimation
//{
////    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(progressDialChange:) userInfo:nil repeats:NO];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(progressDialChange) userInfo:nil repeats:NO];
//    NSLog(@"startAnimation");
//}

//- (void)updateStepLabel
//{
//    NSInteger numberOfSteps = [[NSUserDefaults standardUserDefaults] integerForKey:STEPS_KEY];
//    // doing %li and (long) so that we're safe for 64-bit
//    //MyStatsViewController *controller = [MyStatsViewController alloc];
//    self.stepsCountingLabel.text = [NSString stringWithFormat:@"%li", (long)numberOfSteps];
//}

// this method sets up the steps counter
//- (void)loadSteps
//{
////    // the if statement checks whether the device supports step counting (ie whether it has an M7 chip)
////    if ([CMStepCounter isStepCountingAvailable]) {
////        // the step counter needs a queue, so let's make one
////        NSOperationQueue *queue = [NSOperationQueue new];
////        // call it something appropriate
////        queue.name = @"Step Counter Queue";
////        // now to create the actual step counter
////        CMStepCounter *stepCounter = [CMStepCounter new];
////        // this is where the brunt of the action happens
////        [stepCounter startStepCountingUpdatesToQueue:queue updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
////            // save the numberOfSteps value to standardUserDefaults, and then update the step label
////            [[NSUserDefaults standardUserDefaults] setInteger:numberOfSteps forKey:STEPS_KEY];
////            [self updateStepLabel];
////        }];
////    }
//    
////    NSDate *now = [NSDate date];
////    
////    // Array to hold step values
////    _stepsArray = [[NSMutableArray alloc] initWithCapacity:7];
////    
////    // Check if step counting is avaliable
////    if ([CMStepCounter isStepCountingAvailable]) {
////        // Init step counter
////        self.cmStepCounter = [[CMStepCounter alloc] init];
////        // Tweak this value as you need (you can also parametrize it)
////        NSInteger daysBack = 6;
////        for (NSInteger day = daysBack; day > 0; day--) {
////            NSDate *fromDate = [now dateByAddingTimeInterval: -day * 24 * 60 * 60];
////            NSDate *toDate = [fromDate dateByAddingTimeInterval:24 * 60 * 60];
////            
////            [self.cmStepCounter queryStepCountStartingFrom:fromDate to:toDate     toQueue:self.operationQueue withHandler:^(NSInteger numberOfSteps, NSError *error) {
////                if (!error) {
////                    NSLog(@"queryStepCount returned %ld steps", (long)numberOfSteps);
////                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
////                        [_stepsArray addObject:@(numberOfSteps)];
////                        
////                        if ( day == 1) { // Just reached the last element, do what you want with the data
////                            NSLog(@"_stepsArray filled with data: %@", _stepsArray);
////                            // [self updateMyUI];
////                        }
////                    }];
////                } else {
////                    NSLog(@"Error occured: %@", error.localizedDescription);
////                }
////            }];
////        }
////    } else {
////        NSLog(@"device not supported");
////    }
//    self.stepCounter = [[CMStepCounter alloc] init];
//    NSDate *now = [NSDate date];
//    NSDate *from = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:now];
//    
//    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
//                                         
//       self.stepsCountingLabel.text = [@(numberOfSteps) stringValue];
//       
//    
//    
//    }];
//    
//    
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

        
        self.stepsCountingLabel.text = [@(numberOfSteps) stringValue];
        
        //prevent NAN values
        if (numberOfSteps == 0) {
            self.myPoints = 0;
            self.pointsValue.text = [NSString stringWithFormat:@"%d",0] ;
        }
        else
        {
        self.myPoints = [self calculatePoints:numberOfSteps];
        self.pointsValue.text = [NSString stringWithFormat:@"%@",self.myPoints] ;
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
            NSLog(@"Max value %@", [self.myWeekleyPointsArray valueForKeyPath:@"@max.doubleValue"]);
            
            self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyPointsArray valueForKeyPath:@"@max.self"]];
            
            NSNumber *max = [self.myWeekleyPointsArray valueForKeyPath:@"@max.self"];
            int midValue = [max intValue];
            
            self.mediumValue.text = [NSString stringWithFormat:@"%d",midValue/2];
            
            
            [self.barChart setYValues:self.myWeekleyPointsArray];
            [self.barChart strokeChart];
            NSLog(@"segmented control points pressed");
            
            break;
        }
        case 1:
        {
//            self.pointsOrSteps= NO;
            NSLog(@"Max value %@", [self.myWeekleyStepsArray valueForKeyPath:@"@max.doubleValue"]);
            
            self.highValue.text = [NSString stringWithFormat:@"%@",[self.myWeekleyStepsArray valueForKeyPath:@"@max.self"]];
            
            NSNumber *maxSteps = [self.myWeekleyStepsArray valueForKeyPath:@"@max.self"];
            int midStepsValue = [maxSteps intValue];
            
            self.mediumValue.text = [NSString stringWithFormat:@"%d",midStepsValue/2];
            
            
                       
            [self.barChart setYValues:self.myWeekleyStepsArray];
            [self.barChart strokeChart];
            NSLog(@"segmented control steps pressed");
            break;
        }
        default:
            break;
    }
    
}
@end
