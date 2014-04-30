//
//  SimpleHomeViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/10/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "SimpleHomeViewController.h"
#import "MyStatsViewController.h"
#import "ContentController.h"
#import "VSTableViewController.h"
#import "CalculatePoints.h"
#import <Foundation/Foundation.h>


#import "Cache.h"
#import "Constants.h"

#import "Constants.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

#import "UIImage+RoundedCornerAdditions.h"
#import "UIImage+ResizeAdditions.h"

#import <CoreMotion/CoreMotion.h>
#include <math.h>

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

@interface SimpleHomeViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) IBOutlet ContentController * contentController;
@property (nonatomic, strong) PFObject * activityObject;

@property (nonatomic, strong) PFObject * myteamObject;
@property (nonatomic, strong) PFObject * myNewTeamObject;
@property (nonatomic, strong) PFObject * myteamObjectatIndex;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) NSMutableArray *myTeamData;
@property (strong, nonatomic) NSMutableArray * arrayOfTeamScores;
@property (strong, nonatomic) NSMutableArray * vsTeamScores;
@property (strong, nonatomic) NSMutableArray * homeTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfhomeTeamScores;
@property (strong, nonatomic) NSMutableArray * awayTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfawayTeamScores;


@property (nonatomic, assign) NSUInteger x;

@property (nonatomic, assign) BOOL receivedNotification;

//idex of the team displayed on the home screen controller
@property (nonatomic, assign) int matchupsIndex;

@property (strong, nonatomic) NSTimer *timer;

//for background taks

@property (nonatomic, assign) UIBackgroundTaskIdentifier activityPostBackgroundTaskId;



//step counting
@property (nonatomic, strong) CMStepCounter *cmStepCounter;
@property (nonatomic, strong) CMMotionActivityManager *motionActivity;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSMutableArray *stepsArray;


//convert steps to points and store here
@property NSNumber* myPoints;
@property NSInteger* mySteps;


@end



@implementation SimpleHomeViewController

@synthesize activityPostBackgroundTaskId;
@synthesize activityObject;
@synthesize myteamObject;
@synthesize myteamObjectatIndex;
//@synthesize receivedNotification;
@synthesize x;
@synthesize myPoints;
@synthesize mySteps;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //schedule local notification to show daily points & steps summary
    CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
    [calculatePointsClass scheduleDailySummaryLocalNotification];
    
    [self setReceivedNotification:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTeamNotification:)
                                                 name:@"JoinedTeam"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTeamNotification:)
                                                 name:@"LeftTeam"
                                               object:nil];
    
    
    //refreshes the app when app is first launched
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(refreshHomeView)
//                                                 name:UIApplicationDidFinishLaunchingNotification object:nil];
    //add past 7 days steps to an array
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(findSevenDayStepsAndPoints)
                                                 name:UIApplicationDidFinishLaunchingNotification object:nil];

    
    //refreshes the app when it enters foreground
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshHomeView)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    [self refreshHomeView];
    
   
   
//Use the line bellow to cancel local notficiations
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES ];
    
    // If we received joined/leave team notification update team charts
    if (self.receivedNotification == YES) {
        
//        [self updateTeamChart:0];
//        [self refreshHomeView];
        
        [self showChart];
        
       self.receivedNotification = NO;
    }
     }
#pragma mark Refresh Home View

-(void)refreshHomeView
{
    //Page control for MyStatsView
//    NSUInteger numberPages = self.contentList.count;
    NSUInteger numberPages = 2;
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    
   
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    //[self loadScrollViewWithPage:1];
    [self.view addSubview:self.pageControl];
    
    [self savePointsFromCurrentAppLaunch];
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    [calculatePointsClass retrieveFromParse];
    [calculatePointsClass incrementPlayerPointsInBackground];
    

    [self showChart];
    
    [self.view setNeedsDisplay];

}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
//    NSUInteger numPages = self.contentList.count;
    
    
    NSUInteger numPages = 2;
    
    // adjust the contentSize (larger or smaller) depending on the orientation
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numPages, CGRectGetHeight(self.scrollView.frame));
    
    // clear out and reload our pages
    self.viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    [self loadScrollViewWithPage:self.pageControl.currentPage - 1];
    [self loadScrollViewWithPage:self.pageControl.currentPage];
    [self loadScrollViewWithPage:self.pageControl.currentPage + 1];
    [self gotoPage:NO]; // remain at the same page (don't animate)
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    
    
    if (page >= self.contentList.count)
        return;
    
    // replace the placeholder if necessary
    MyStatsViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[MyStatsViewController alloc] initWithPointsLabelNumber:page];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
        
    }
    
    
    

    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        
        
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        
        [controller didMoveToParentViewController:self];

    }
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    //[self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}
- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}


- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}





#pragma mark scroll teams buttons

//scroll through team data
- (IBAction)scrollTeamsRight:(id)sender {
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    
    int myTeamIndex = (int)[homeTeamNames indexOfObject:self.myNewTeamObject];
    int myFirstTeamIndex = (int)[homeTeamNames indexOfObject:homeTeamNames.firstObject];
    
   
   
    
//    NSLog(@"index of myteamObjectRight: %d", myTeamIndex);
    
    if (myTeamIndex <= homeTeamNames.count-1) {
        
        int incrementTeamIndex = myTeamIndex += 1;
        
        [self updateTeamChart:incrementTeamIndex];
        
        if (myTeamIndex == homeTeamNames.count-1 )
        {
            
            [self.scrollTeamsRight setEnabled:FALSE];
            [self.scrollTeamsLeft setEnabled:TRUE];
            
        }
        if (myTeamIndex > myFirstTeamIndex) {
            
            [self.scrollTeamsLeft setEnabled:TRUE];
            
        }
    }

}



- (IBAction)scrollTeamsLeft:(id)sender {
    
     NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    
    //find the index of myTeamObject - see comments above in scrollTeamsRight
    int myTeamIndex = (int)[homeTeamNames indexOfObject:self.myNewTeamObject];
    int myFirstTeamIndex = (int)[homeTeamNames indexOfObject:homeTeamNames.firstObject];
//    NSLog(@"index of myteamObjectLeft: %d", myTeamIndex);
    
   
//     NSLog(@"index of myteamObjectLeft: %d", self.matchupsIndex);
    
    if (myTeamIndex <= homeTeamNames.count-1 )
    {
        [self.scrollTeamsRight setEnabled:TRUE];
        
        int decrementTeamIndex = myTeamIndex -= 1;
        
        [self updateTeamChart:decrementTeamIndex];
        
        
        
        
        if (myTeamIndex == myFirstTeamIndex) {
            
            [self.scrollTeamsLeft setEnabled:FALSE];
            [self.scrollTeamsRight setEnabled:TRUE];
            
        }
        
    }

    

}

#pragma mark Team Chart

-(void)showChart
{
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    
    int  numberOfTeams = (int)[RetrievedTeams integerForKey: kNumberOfTeams];
    //NSLog(@"homeTeamNames.count: %lu", (unsigned long)homeTeamNames.count);
    
    //need to do something different then homeTeamNames.count because it aways returns 1 even if it's empty
    //need to come up with a condition if there is only one team
    if(numberOfTeams > 1 )
    {
        
        [self updateTeamChart:0];
        [self.scrollTeamsLeft setEnabled:FALSE];
        [self.scrollTeamsRight setEnabled:TRUE];
        
        //disable join team button
        [self.joinTeamButton setEnabled:FALSE];
        self.joinTeamButton.hidden = YES;
        
        //show navigation buttons
        self.scrollTeamsRight.hidden = NO ;
        self.scrollTeamsLeft.hidden = NO ;
        
        //show chart
        self.teamBarChart.hidden = NO;
        
        //show labels
        self.MyTeamName.hidden = NO;
        self.MyTeamScore.hidden = NO;
        self.vsTeamName.hidden = NO;
        self.VSTeamScore.hidden = NO;
        
        
    }
    else if(numberOfTeams == 1 )
    {
        [self updateTeamChart:0];
        
        
        //disable join team button
        [self.joinTeamButton setEnabled:FALSE];
        self.joinTeamButton.hidden = YES;
        
        
        //hide navigation buttons
        self.scrollTeamsRight.hidden = YES ;
        self.scrollTeamsLeft.hidden = YES ;
        
        //show chart
        self.teamBarChart.hidden = NO;
        
        //show labels
        self.MyTeamName.hidden = NO;
        self.MyTeamScore.hidden = NO;
        self.vsTeamName.hidden = NO;
        self.VSTeamScore.hidden = NO;
    }
    
    else
    {
        //enable join team button
        [self.joinTeamButton setEnabled:TRUE];
        self.joinTeamButton.hidden = NO;
        
        //hide navigation buttons
        self.scrollTeamsRight.hidden = YES ;
        self.scrollTeamsLeft.hidden = YES ;
        
        //hide chart
        self.teamBarChart.hidden = YES;
        
        //hide labels
        self.MyTeamName.hidden = YES;
        self.MyTeamScore.hidden = YES;
        self.vsTeamName.hidden = YES;
        self.VSTeamScore.hidden = YES;
        
    }
    
}


-(void)updateTeamChart:(int)index
{
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    NSArray *homeTeamScores = [RetrievedTeams objectForKey:kArrayOfHomeTeamScores];
    NSArray *awayTeamScores = [RetrievedTeams objectForKey:kArrayOfAwayTeamScores];
    
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
    
    
    self.myNewTeamObject = [homeTeamNames objectAtIndex:index];
    self.matchupsIndex = index;

//    NSLog(@"matchupsIndex %d", self.matchupsIndex);
//    NSLog(@"homeTeamNames retrieved: %@", homeTeamNames);
//    
//    NSLog(@"awayTeamNames retrieved: %@", awayTeamNames);
    
    //set team names
    NSString * homeTeamName = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:index]];
    self.MyTeamName.text = homeTeamName;
    
    NSString * awayTeamName = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:index]];
    self.vsTeamName.text = awayTeamName;
    
    
    //set score
    NSString * homeTeamScore = [NSString stringWithFormat:@"%@",[homeTeamScores objectAtIndex:index]];
    self.MyTeamScore.text = homeTeamScore;
    
    NSString * awayTeamScore = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:index]];
    self.VSTeamScore.text = awayTeamScore;
    
    
    //set colors
    self.MyTeamName.textColor = PNBlue;
    self.MyTeamScore.textColor = PNBlue;
    

    self.vsTeamName.textColor = PNGreen;
    self.VSTeamScore.textColor = PNGreen;
 
    
    //create bar chart to display days
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 248)];
    
    //    PNBarChart * barChart = [[PNBarChart alloc] init];
    
    
    
     NSArray * teamPoints = @[homeTeamScore, awayTeamScore];
    
    [barChart setYValues:teamPoints];
 
    
    [barChart setStrokeColors:@[PNLightBlue, PNGreen]];
    [barChart setBarBackgroundColor:PNWhite];
    //    [barChart setStrokeColor:PNLightBlue];
    [barChart strokeChart];
    
    [self.teamBarChart addSubview:barChart];
    
}





#pragma mark NSNotifications methods

- (void) receiveTeamNotification:(NSNotification *) notification
{
    //reload view if a player has joined a team
    
    if ([[notification name] isEqualToString:@"JoinedTeam"])
    {
        
        
        [self.view setNeedsDisplay];
        [self setReceivedNotification:YES];
//        NSLog(@"Received Joined Team Notification on home screen");
        ;
    }
    else if ([[notification name] isEqualToString:@"LeftTeam"])
    {
        
       [self.view setNeedsDisplay];
        [self setReceivedNotification:YES];
      
//        NSLog(@"Received Leave Team Notification on home screen");
    }
}




#pragma mark Step Counting



-(void)findSevenDayStepsAndPoints {
    CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
    [calculatePointsClass findPastWeekleySteps];

}

#pragma mark Motion Activity

-(void)getMotionData {
    self.motionActivity = [[CMMotionActivityManager alloc] init];
    
//    NSLog(@"activities called");
    
    NSDate *now = [NSDate date];
//    NSDate *from = [self beginningOfDay];
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    NSDate *from = [calculatePointsClass beginningOfDay];
   
    [self.motionActivity queryActivityStartingFromDate:from toDate:now toQueue:self.operationQueue withHandler:^(NSArray *activities, NSError *error) {
//        NSLog(@"activities array: %@", activities);
//        
//        NSLog(@"activities array count: %lu", (unsigned long)activities.count);
    }];


}


#pragma mark - Save Points From Current App Launch


//Store the points and steps from current app launch so that we can use them as the starting values for counting labels
-(void)savePointsFromCurrentAppLaunch
{
    self.stepCounter = [[CMStepCounter alloc] init];
    NSDate *now = [NSDate date];
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    NSDate *from = [calculatePointsClass beginningOfDay];
    
    //find the number of steps I have take today
    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        
        
        
        //convert steps to points
        //check for NAN values
        if(numberOfSteps == 0)
        {
            self.myPoints = 0;
            self.mySteps = 0;
            
        }
        else
        {
            CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
            
            self.myPoints = [calculatePointsClass calculatePoints:numberOfSteps];
            self.mySteps = &(numberOfSteps);
        }
        
        
        
        //set the player's total points in memory
        NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //to prevent null values check if # of steps is 0
        if(numberOfSteps == 0)
        {
            
            [myRetrievedPoints setInteger:0 forKey:kMyMostRecentPointsBeforeSaving];
            [myRetrievedPoints setInteger:0 forKey:kMyMostRecentStepsBeforeSaving];
            
            [myRetrievedPoints synchronize];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
                    }
        
        else
        {
               //we are going to use this value to start the couter in the counting label in MyStatsViewController
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyMostRecentPointsBeforeSaving];
            //        NSLog(@"self.myPoints intValue: %d", [self.myPoints intValue]);
            [myRetrievedPoints setInteger:*(self.mySteps) forKey:kMyMostRecentStepsBeforeSaving];
            
            [myRetrievedPoints synchronize];
        }
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
        
        //        NSLog(@"Segue index sent: %d", self.matchupsIndex);
        
        [segue.destinationViewController initWithReceivedTeam:self.matchupsIndex];
        
        transferViewController.homeTeam = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:self.matchupsIndex]];
        transferViewController.awayTeam = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:self.matchupsIndex]];
        
        
    }
}



- (IBAction)joinTeam:(id)sender {
    
    //when selecting the join team button switch to leagues view controller
    
    self.tabBarController.selectedViewController
    = [self.tabBarController.viewControllers objectAtIndex:2];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
