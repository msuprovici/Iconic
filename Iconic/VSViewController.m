//
//  VSViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Iconic All rights reserved.
//

#import "VSViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface VSViewController ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation VSViewController

@synthesize progressView = _progressview;
@synthesize circleProgressView = _circleProgressView;
@synthesize timer = _timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0, 30.0, 40.0, 40.0)];
//    //self.progressView.roundedCorners = YES;
//    self.progressView.trackTintColor = [UIColor clearColor];
//    [self.view addSubview:self.progressView];
    
    
    //timer label
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:_timerLabel andTimerType:MZTimerLabelTypeTimer];
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
            
            //if no network connection countdown to Sunday
            
            //approach from Apple: https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
            //makes the timer = 00:00:00, need to revisit this later
            //for now we are caching the query results
            
            
//            NSDate *today = [[NSDate alloc] init];
//            NSCalendar *gregorian = [[NSCalendar alloc]
//                                     initWithCalendarIdentifier:NSGregorianCalendar];
//            
//            // Get the weekday component of the current date
//            NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit
//                                                               fromDate:today];
//            
//            /*
//             Create a date components to represent the number of days to subtract from the current date.
//             The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
//             */
//            NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
//            [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
//            
//            NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract
//                                                                 toDate:today options:0];
//            
//            /*
//             Optional step:
//             beginningOfWeek now has the same hour, minute, and second as the original date (today).
//             To normalize to midnight, extract the year, month, and day components and create a new date from those components.
//             */
//            NSDateComponents *components =
//            [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
//                                   NSDayCalendarUnit) fromDate: beginningOfWeek];
//            beginningOfWeek = [gregorian dateFromComponents:components];
//            
//            
//          
//            
//            //Set timer
//            [timer setCountDownToDate:beginningOfWeek];
//            timer.delegate = self;
//            [timer start];
        }
        
        
    }];
    
  
    
    
//    //hardcoded a date 7 days from today for testing
//    NSDate *now = [NSDate date];
//    int daysToAdd = 7;
//    NSDate *newDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
//
//    [timer setCountDownToDate:newDate];
//    timer.delegate = self;
//    [timer start];
    
    //block to do something once the timer is done
    //we are resetting the timer when it's done
   
//        [timer startWithEndingBlock:^(NSTimeInterval countTime) {
//            
//            NSString *msg = [NSString stringWithFormat:@"Game finished!\nTime counted: %i seconds",(int)countTime];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil];
//            [alertView show];
//            
//            [timer start];
//            
//            
//        }];
    


    
    
    
    self.circleProgressView.trackTintColor = PNGrey;
    self.circleProgressView.progressTintColor = PNBlue;
    self.circleProgressView.roundedCorners = YES;
    self.circleProgressView.thicknessRatio = .11f;
    
    
    [self.view addSubview:self.circleProgressView];
    
    
    
    [self startAnimation];
    
    //[self progressChange];
    //self.circleProgressView.roundedCorners = YES;
}

- (void)progressChange
{
    
    NSArray *progressViews = @[self.circleProgressView ];
    for (DACircularProgressView *progressView in progressViews) {
        
        //this is where we will compute the score ratio and display it to the user
        //simple equation:  myteam score / opponent score
        CGFloat progress = .60;
       [progressView setProgress:progress animated:YES];
        
        if (progressView.progress >= 1.0f && [self.timer isValid]) {
            [progressView setProgress:0.f animated:YES];
        }
    }
}


- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(progressChange) userInfo:nil repeats:NO];
    
}

//method to show days

- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{

        int second = (int)time  % 60;
        int minute = ((int)time / 60) % 60;
        int hours = ((int)time / 7200 )% 60;
        int days = (((int)time / 3600) / 24)% 60;
    
        return [NSString stringWithFormat:@"%02dd : %02dh : %02dm : %02ds", days,hours,minute,second];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
