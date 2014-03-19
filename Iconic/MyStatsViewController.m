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

#import "UIImage+RoundedCornerAdditions.h"
#import "UIImage+ResizeAdditions.h"
#import <CoreMotion/CoreMotion.h>

@interface MyStatsViewController ()
{
    int pointslabelNumber;
    
}

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MyStatsViewController


@synthesize xpProgressView = _xpProgressView;
@synthesize xpProgressDial = _xpProgressDial;
@synthesize timer = _timer;



- (id)initWithPointsLabelNumber:(NSUInteger)pointslabel
{
    if (self = [super initWithNibName:@"MyStatsViewController" bundle:nil])
    {
        pointslabelNumber = pointslabel;
    }
    return self;
}


- (void)viewDidLoad
{
    
    //    [self retrievePlayerStats];
    

    
    
    [super viewDidLoad];
    
    [self getPlayerSteps];
    
    
    
    
    //Cycle through label string
    for (int i = 0; i <= pointslabelNumber; i++) {
        PFQuery* query = [PFUser query];
        [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
        //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        PFUser* currentUser = [PFUser currentUser];
        

        
        if (i == 0) {
            if (pointslabelNumber == 0) {
               
            // This is to generate thumbnail a player's thumbnail, name & title
            
            
            if (currentUser) {
                
                [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    
                    self.xpValue.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerXP]];
                    
                    //Get my lifetime points
                     NSNumber* myLifetimePoints = [object objectForKey:kPlayerPoints];
                   // NSLog(@"myLifetimePoints: %@", myLifetimePoints);
                     float myPointsValue = [myLifetimePoints floatValue];
                    
                    //get total points need to reach next level
                     NSNumber* myPointsToNextLevel = [object objectForKey:kPlayerPointsToNextLevel];
                     float myPointsToNextLevelValue = [myPointsToNextLevel floatValue];
                    
                    float totalPointsToNextLevelValue = (myPointsToNextLevelValue + myPointsValue);
                    //NSLog(@"totalPointsToNextLevelValue: %f", totalPointsToNextLevelValue);
                    
                    //calculate the % complete to next level
                    float myProgress = myPointsValue/totalPointsToNextLevelValue;
                    //NSLog(@"myPointsValue: %f", myProgress);
                    
                    //animate the progress dial
                    [self progressDialChange:myProgress];

                    
               
                }];
                
                
            }

        self.stepsImage.hidden = YES;
        self.stepsCountingLabel.hidden = YES;
        self.viewTitle.hidden = YES;
        self.statsImage.hidden = YES;
        self.xpLabel.text = @"Level";
        self.pointsLabel.text = @"Points";
                
            //self.timeActiveLabel.hidden = YES;
                
            self.stepsProgressDial.hidden = true;

            
            self.xpProgressDial.trackTintColor = PNGrey;
            self.xpProgressDial.progressTintColor = PNBlue;
            
                
            [self startAnimation];
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
               
            
            [self startAnimation];
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
                
                
            }
            
            self.viewTitle.text = @"Points";
            
            
            //create bar chart to display days
            PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
            
            //list of days of the week
            NSArray * daysArray = @[@"S",@"M",@"T",@"W",@"T", @"F", @"S"];
            
            
                
            //getting historical daily points arary from server
            NSMutableArray * playerPoints = [currentUser objectForKey:kPlayerPointsWeek];
            
            //we add todays most uptodate data to the array
            [playerPoints addObject:[currentUser valueForKey:kPlayerPointsToday]];
            
            
//            int indexValue = [playerPoints indexOfObject:playerPoints.lastObject];
//                
//            
//            [playerPoints replaceObjectAtIndex:indexValue withObject:[currentUser valueForKey:kPlayerPointsToday]];
            
            
            //create a subarray that has the range of days played based on the amout of objects in playerPoints
            NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, [playerPoints count])];
            
            //set the labels
            [barChart setXLabels:daysPlayed];
            
            [barChart setYValues:playerPoints];
            
            //sets the maximum value of the label.  so if the player has a goal of say 10k points/day then we would use this.
            //[barChart setYLabels:@[@500]];
            
            
            [barChart setStrokeColor:PNLightBlue];
            [barChart strokeChart];
            
            [self.stepsBarChart addSubview:barChart]; 
            //}];
            
           

            
            
           

            
        }
        
        self.xpProgressDial.thicknessRatio = .25f;
        self.xpProgressDial.roundedCorners = YES;
//        self.stepsProgressDial.thicknessRatio = .25f;
//        self.stepsProgressDial.roundedCorners = YES;
        
    }
    }
//retrive table view data from parse



//-(void)viewDidAppear:(BOOL)animated
//{
//    [self getPlayerSteps];
//}

- (void)progressDialChange:(float)ratio
{
    
    NSArray *progressViews = @[self.xpProgressDial, self.stepsProgressDial ];
    for (DACircularProgressView *progressView in progressViews) {
        
        //this is where we will compute the score ratio and display it to the user
        //simple equation:  myteam score / opponent score
        float progress = ratio;
        [progressView setProgress:progress animated:YES];
        
        if (progressView.progress >= 1.0f && [self.timer isValid]) {
            [progressView setProgress:0.f animated:YES];
        }
    }
}


- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(progressDialChange:) userInfo:nil repeats:NO];
    
}

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
   // NSDate *now = [NSDate date];
    //NSDate *from = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:now];
    
    
    
    
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
    NSDate *now = myDate;
    NSDate *from = [self beginningOfDay];
    
    
//    NSLog(@"time now: %@",now);
//    NSLog(@"time from: %@",from);

    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        
        
        
        self.stepsCountingLabel.text = [@(numberOfSteps) stringValue];
        
        NSNumber *myPoints = [self calculatePoints:numberOfSteps];
        
        self.pointsValue.text = [NSString stringWithFormat:@"%@",myPoints] ;
        
        
    }];

}



//find the beginning of the day
-(NSDate *)beginningOfDay
{

    //find the beginning of the day
    //nsdate always returns GMT
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    
    //NSLog(@"Local Time Zone %@",[[NSTimeZone localTimeZone] name]);
    
//     NSLog(@"Calendar date: %@",[cal dateFromComponents:components]);
    
    //convert GMT to my local time
    NSDate* sourceDate = [cal dateFromComponents:components];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* myTimeZone = [NSTimeZone localTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger myGMTOffset = [myTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = myGMTOffset - sourceGMTOffset;
    
    NSDate* myDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate]init];
    
    
//    NSLog(@"Converted date: %@",myDate);
//    NSLog(@"Source date: %@",myDate);
   
    //return [cal dateFromComponents:components];
    return myDate;
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

-(NSNumber*)calculatePoints:(float)steps
{
    
    //alogrithm for generating points from steps: yourPoints = ((0.85^( ln(steps) /ln (2)))/time)*steps*constantValue
    
    //Converting float to NSNumber
    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50)];//rounded up to the largest following integer using ceiling function
    
    return points;
}

@end
