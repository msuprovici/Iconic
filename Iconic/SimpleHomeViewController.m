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
#import "MyTeamsViewController.h"
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

@property (nonatomic, strong) NSArray *myTeamsViewControllers;

@property (strong, nonatomic) NSMutableArray *myTeamData;
@property (strong, nonatomic) NSMutableArray * arrayOfTeamScores;
@property (strong, nonatomic) NSMutableArray * vsTeamScores;
@property (strong, nonatomic) NSMutableArray * homeTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfhomeTeamScores;
@property (strong, nonatomic) NSMutableArray * awayTeamScores;


@property (strong, nonatomic) NSArray * teamPoints;



@property (nonatomic, assign) NSUInteger x;

@property (nonatomic, assign) BOOL receivedNotification;

//idex of the team displayed on the home screen controller
@property (nonatomic, assign) int matchupsIndex;
@property (nonatomic, assign) NSUInteger myMatchupIndex;
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
@property NSNumber* myLevel;
@property NSNumber* mySteps;
@property NSNumber* myPointsGained;

//my team name

@property NSString* nameOfMyTeamString;


@property BOOL deltaPointsLabelIsAnimating;



//My Teams Page Controller

@property (strong, nonatomic) UIPageViewController *myTeamsPageController;



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
//    CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [calculatePointsClass scheduleDailySummaryLocalNotification];
    
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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(showChart)
//                                                 name:UIApplicationWillEnterForegroundNotification object:nil];

    
    
    
    [self refreshHomeView];
    [self showChart];
   
   
//Use the line bellow to cancel local notficiations
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    
    
//    self.myTeamsPageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    
//    self.myTeamsPageController.dataSource = self;
//    [[self.myTeamsPageController view] setFrame:[self.MyTeamsView  bounds]];
//    
//    MyTeamsViewController *initialViewController = [self viewControllerAtIndex:0];
//    
//    
//    self.myTeamsViewControllers = [[NSArray alloc]init];
//    self.myTeamsViewControllers = [NSArray arrayWithObject:initialViewController];
//    
//    [self.myTeamsPageController setViewControllers:self.myTeamsViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
////    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
////    
////    [self.myTeamsPageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
//    [self addChildViewController:self.myTeamsPageController];
//    [self.MyTeamsView  addSubview:[self.myTeamsPageController view]];
//    [self.myTeamsPageController didMoveToParentViewController:self];

    
    
    
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
    [self loadScrollViewWithPage:1];
    [self.view addSubview:self.pageControl];
    
    //initialize all other methods
    
    [self savePointsFromCurrentAppLaunch];
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    [calculatePointsClass retrieveFromParse];
    [calculatePointsClass incrementPlayerPointsInBackground];
    
//    [calculatePointsClass migrateLeaguesToCoreData];

    
    [self findSevenDayStepsAndPoints];
    
    [self showChart];
    
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    int  numberOfTeams = (int)[RetrievedTeams integerForKey: kNumberOfTeams];
    
    if (numberOfTeams > 0) {
        [self beginDeltaPointsAnimation];
    }
    
//    [self beginDeltaPointsAnimation];
   
    self.myTeamsPageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.myTeamsPageController.dataSource = self;
    [[self.myTeamsPageController view] setFrame:[self.MyTeamsView  bounds]];
    
    MyTeamsViewController *initialViewController = [self viewControllerAtIndex:0];
    
    
    self.myTeamsViewControllers = [[NSArray alloc]init];
    self.myTeamsViewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.myTeamsPageController setViewControllers:self.myTeamsViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    [self addChildViewController:self.myTeamsPageController];
    [self.MyTeamsView  addSubview:[self.myTeamsPageController view]];
    [self.myTeamsPageController didMoveToParentViewController:self];

    
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
        self.myLeagueName.hidden = NO;
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
        self.myLeagueName.hidden = YES;
        
    }
    
}


-(void)updateTeamChart:(int)index
{
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    NSArray *homeTeamScores = [RetrievedTeams objectForKey:kArrayOfHomeTeamScores];
    NSArray *awayTeamScores = [RetrievedTeams objectForKey:kArrayOfAwayTeamScores];
    
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
    
    NSArray *arrayOfLeagueNames = [RetrievedTeams objectForKey:kArrayOfLeagueNames];
    
    
    int myStepsDelta = (int)[RetrievedTeams integerForKey:@"myStepsDelta"];
    
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

    
    
    for (int i = 0; i < myTeamsNames.count; i++) {
        {
            //            NSLog(@"myTeamsNames[i] %@",  myTeamsNames[i]);
            
            //            if([myTeamsNames containsObject:homeTeamName] || [myTeamsNames containsObject:awayTeamName])
            
            
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
                
//                self.MyTeamScore.text = homeTeamScore;
                
//                NSLog(@"homeTeamScore: %@",  homeTeamScore);
//                NSLog(@"homeTeamPoints: %d",  homeTeamPoints);
                
//                int pointsAfterPlayerScored = homeTeamPoints + myStepsDelta;
                
                int pointsBeforePlayerScored = homeTeamPoints - myStepsDelta;
                
//                self.MyTeamScore.text = [NSString stringWithFormat:@"%d",pointsBeforePlayerScored];
                
                
                    if (myStepsDelta > 0) {
                        
                        if(self.deltaPointsLabelIsAnimating == YES)
                        {
//                            [self.MyTeamScore  countFrom:homeTeamPoints to:pointsAfterPlayerScored withDuration:2];
                            [self.MyTeamScore  countFrom:pointsBeforePlayerScored to:homeTeamPoints withDuration:1.5];
                            self.deltaPointsLabelIsAnimating = NO;
                        }
                        else
                        {
                            self.MyTeamScore.text = [NSString stringWithFormat:@"%d",homeTeamPoints];
                        }
                        
                        
//                        [self.MyTeamScore  countFrom:pointsBeforePlayerScored to:homeTeamPoints withDuration:2];
                        
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
                
//                self.MyTeamScore.text = awayTeamScore;
                
//                int pointsAfterPlayerScored = awayTeamPoints + myStepsDelta;
                int pointsBeforePlayerScored = awayTeamPoints - myStepsDelta;
                
                if (myStepsDelta > 0)
                {
                        
                            if(self.deltaPointsLabelIsAnimating == YES)
                                {
                                 
                                [self.MyTeamScore  countFrom:pointsBeforePlayerScored to:awayTeamPoints withDuration:1.5];
                                self.deltaPointsLabelIsAnimating = NO;
                                   
                                }
                    
                            else
                                {
                                    self.MyTeamScore.text = [NSString stringWithFormat:@"%d",awayTeamPoints];
                                }

                }
                else
                {
                    self.MyTeamScore.text = [NSString stringWithFormat:@"%d",awayTeamPoints];
                    
                }
                

            }
        }

    
    
    
    
    //create bar chart to display days
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    
    //    PNBarChart * barChart = [[PNBarChart alloc] init];
    
    
    
//     NSArray * teamPoints = @[homeTeamScore, awayTeamScore];
    
    [barChart setYValues:self.teamPoints];
 
    
    [barChart setStrokeColors:@[PNWeiboColor, PNDarkBlue]];
    [barChart setBarBackgroundColor:[UIColor clearColor]];
    //    [barChart setStrokeColor:PNLightBlue];
    [barChart strokeChart];
    
    [self.teamBarChart addSubview:barChart];
    
    
//    //find out what team the player is on and set that as a property so that we can send it to VS view controller
//    NSArray *myTeamsNames = [RetrievedTeams objectForKey:kArrayOfMyTeamsNames];
//    
////    NSLog(@"# of teams I'm on: %lu",  (unsigned long)myTeamsNames.count);
////     for (int i = 0; i < myTeamsNames.count; i++) {
////        NSLog(@"myTeamsNames[index] %@",  myTeamsNames[index]);
////        NSLog(@"homeTeamName %@",  homeTeamName);
////        NSLog(@"awayTeamName %@",  awayTeamName);
//    
//    
//    
//    for (int i = 0; i < myTeamsNames.count; i++) {
//        {
////            NSLog(@"myTeamsNames[i] %@",  myTeamsNames[i]);
//            
////            if([myTeamsNames containsObject:homeTeamName] || [myTeamsNames containsObject:awayTeamName])
//            
//            //if the object in my teams arrays is equal to the home team set it
//            if([myTeamsNames[i] isEqualToString: homeTeamName])
//            {
//
//             self.nameOfMyTeamString = myTeamsNames[i];
//                self.nameOfMyTeamString = homeTeamName;
////             NSLog(@"my Home Team Name: %@",  self.nameOfMyTeamString);
//             
//         
//        }
//            //if the object in my teams arrays is equal to the away team set it
//
//            else if ([myTeamsNames[i] isEqualToString: awayTeamName])
//            {
//                self.nameOfMyTeamString = homeTeamName;
////                NSLog(@"my Away Team Name: %@",  self.nameOfMyTeamString);
//            }
//    }
    
    
    }
//     }
    
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
        
//        if (self.joinedTeamButtonPressed  == YES) {
        
//        self.joinedTeamButtonPressed  = YES;
//            NSLog(@"Player joined 1st team in simple");

//            self.joinedTeamButtonPressed = NO;
            //this is where you need to give the bonus and reload the view?
            
//        }

        
        
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
        
        
        self.mySteps = [NSNumber numberWithInteger:numberOfSteps];
        //convert steps to points
        //check for NAN values
//        if(numberOfSteps == 0)
//        {
//            self.myPoints = 0;
//            self.mySteps = 0;
//            
//        }
//        else
//        {
//            CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
//            
//            self.myPoints = [calculatePointsClass calculatePoints:numberOfSteps];
//            
//            self.mySteps = &(numberOfSteps);
//        }
        
        
        
        //set the player's total points in memory
        NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
        

        
        [myRetrievedPoints synchronize];
        
//        NSLog(@"self.myLevel: %d", [self.myLevel intValue]);
//        NSLog(@"self.myPoints intValue: %d", [self.myPoints intValue]);
        //to prevent null values check if # of steps is 0
        if(numberOfSteps == 0)
        {
            
//            [myRetrievedPoints setInteger:0 forKey:kMyMostRecentPointsBeforeSaving];
            [myRetrievedPoints setInteger:0 forKey:kMyMostRecentStepsBeforeSaving];
            
            [myRetrievedPoints synchronize];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
                    }
        
        else
        {
               //we are going to use this value to start the couter in the counting label in MyStatsViewController
//            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyMostRecentPointsBeforeSaving];
            //        NSLog(@"self.myPoints intValue: %d", [self.myPoints intValue]);
            [myRetrievedPoints setInteger:[self.mySteps intValue] forKey:kMyMostRecentStepsBeforeSaving];
            
            [myRetrievedPoints synchronize];
        }
        
        
        //set level
        
        //find out how many steps were gained since the last time the points were synct
        int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedStepsToday];
        int myMostRecentPointsValue = [self.mySteps intValue];
        int myPointsDeltaValue = myMostRecentPointsValue - myStoredPoints;
        
//        NSLog(@"Delta in simplehomeviewcontroller: %d", myPointsDeltaValue);
        
        
        
        //calculate the current total steps
        int myTotalPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedStepsTotal];
        int myNewTotalPoints = myTotalPoints + myPointsDeltaValue;
//        NSLog(@"myTotalPoints: %d", myTotalPoints);
//        NSLog(@"myNewTotalPoints: %d", myNewTotalPoints);
        //calculate current level
        self.myLevel = [calculatePointsClass calculateLevel:myNewTotalPoints];
//        NSLog(@"self.myLevel: %@", self.myLevel);
        
        //save the current level so that we can use it as a starting point for the level label counter
        [myRetrievedPoints setInteger: [self.myLevel intValue] forKey:kMyLevelOnLastLaunch];
        
        [myRetrievedPoints synchronize];
        
        
        
        
        
    }];

}

#pragma mark - MyTeams Scroll View

- (MyTeamsViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    MyTeamsViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTeamsViewController"];    childViewController.index = index;
    
    return childViewController;
    
}

- (NSUInteger)indexOfViewController:(MyTeamsViewController *)viewController
{
//    MyTeamsViewController *childViewController = [self.myTeamsPageController.viewControllers objectAtIndex:0];
    
    return [self.myTeamsViewControllers indexOfObject:viewController];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // If the page did not turn
    if (!completed)
    {
               return;
    }
    
    // This is where you would know the page number changed and handle it appropriately
    

   
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(MyTeamsViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
  
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(MyTeamsViewController *)viewController index];

    index++;
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfLeagueNames = [RetrievedTeams objectForKey:kArrayOfLeagueNames];
    
    if (index == arrayOfLeagueNames.count) {
        return nil;
    }
  
    
    return [self viewControllerAtIndex:index];
    
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfLeagueNames = [RetrievedTeams objectForKey:kArrayOfLeagueNames];
    return arrayOfLeagueNames.count;
}

- (NSInteger)presentationIndexForPageViewController:(MyTeamsViewController *)pageViewController {
   
   return 0;
}



//#pragma mark - Navigation
//
////pass the team to the teammates view controller
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    VSTableViewController *transferViewController = segue.destinationViewController;
//    
//     NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
//    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
//    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
//    
//    if ([segue.identifier isEqualToString:@"vs"]) {
//        
//        //        NSLog(@"Segue index sent: %d", self.matchupsIndex);
//        
////        NSInteger currentIndex = _myTeamsPageController.currentIndex;
//        
////        MyTeamsViewController *viewController = [self.myTeamsPageController.viewControllers objectAtIndex:self.myMatchupIndex];
////        NSUInteger retreivedIndex = [self.myTeamsViewControllers indexOfObject:viewController];
////     
//        
//        
////        NSUInteger retreivedIndex = [self indexOfViewController:currentViewController];
//       
////        NSLog(@"retreivedIndex: %lu", retreivedIndex);
//        int myRetreivedIndex = (int)self.myTeamsIndex ;
//        NSLog(@"myRetreivedIndex: %d", myRetreivedIndex);
//        
////        NSLog(@"myIndex: %lu", (unsigned long)self.myMatchupIndex);
////        int myTeamsMatchupsIndex = (int)self.myMatchupIndex ;
////         NSLog(@"myTeamsMatchupsIndex: %d", myTeamsMatchupsIndex);
//        
//        
//        [segue.destinationViewController initWithReceivedTeam:myRetreivedIndex];
//        
//        transferViewController.homeTeam = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:myRetreivedIndex]];
//        transferViewController.awayTeam = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:myRetreivedIndex]];
//        transferViewController.matchupsIndex = myRetreivedIndex;
//        
////        [segue.destinationViewController initWithReceivedTeam:self.matchupsIndex];
////        
////        transferViewController.homeTeam = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:self.matchupsIndex]];
////        transferViewController.awayTeam = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:self.matchupsIndex]];
////        transferViewController.matchupsIndex = self.matchupsIndex;
//        
//        //send my team name to vs view controller
//        transferViewController.myTeamReceived = [NSString stringWithFormat:@"%@",self.nameOfMyTeamString];
//        
//    }
//}



- (IBAction)joinTeam:(id)sender {
    
    //when selecting the join team button switch to leagues view controller
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    
    self.joinedTeamButtonPressed = YES;
    
    
    
//    
//    //send nsnotification if the player selected joinedTeamButton
//    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//    [nc postNotificationName:@"playerJoinedTheirFirstTeam" object:self];
//    
////    [nc postNotificationName:@"JoinedTeam" object:self userInfo:teamInfo];
    
    
    
}

#pragma mark - Delta Label Animation

-(void)beginDeltaPointsAnimation
{
    
    self.deltaPoints.hidden = YES;
    
    //wait untill the countdown is almost finished to begin animation
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(animateDeltaPointsLabel) userInfo:nil repeats:NO];
    
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1.5f]];
    
    
    
//    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
//        [calculatePointsClass retrieveFromParse];
//        [calculatePointsClass incrementPlayerPointsInBackground];
    
    
    
    
    
    
}

-(void)animateDeltaPointsLabel
{
    //show deltaPoints label
    self.deltaPoints.hidden = NO;
    
    //populate the deltaValueLabel
    NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
    
    int myStepsDelta = (int)[myRetrievedPoints integerForKey:@"myStepsDelta"];
//    int  numberOfTeams = (int)[myRetrievedPoints integerForKey: kNumberOfTeams];

    
//    NSLog(@"Delta in simplehomeviewcontroller: %d", myStepsDelta);
    
    
    
    if(myStepsDelta > 0)
    {
        self.deltaPoints.text = [NSString stringWithFormat:@"+%d", myStepsDelta];
        
        CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
        [calculatePointsClass retrieveFromParse];
        [calculatePointsClass incrementPlayerPointsInBackground];

        

    }
    else
    {
        
        //comment out this line to test deltaLabel animations
        self.deltaPoints.text = @"";
        
    }

    
    //animated label that shows the points the player contributed to his or her team(s)
    self.deltaPoints.center = CGPointMake(160, 184);
    float newX = 90.0f;
    float newY = 280.0f;
    
    //animate the label so that it drops right on top of my team score
    [UIView transitionWithView:self.deltaPoints
                      duration:2.0f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^(void) {
                        
                        self.deltaPointsLabelIsAnimating = YES;
                  
                        
                        self.deltaPoints.center = CGPointMake(newX, newY);
                        [self fadein];
                    }
                    completion:^(BOOL finished) {
                        // Hide label
                        self.deltaPoints.hidden = YES;
                        if(myStepsDelta > 0)
                        {
                            
                            [self showChart];
                            
                            
                        
                        }
                    }];
    
}

// fade in delta label
-(void) fadein
{
    self.deltaPoints.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    //don't forget to add delegate.....
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:1];
    self.deltaPoints.alpha = 1;
    
    //also call this before commit animations......
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}



-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished    context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    self.deltaPoints.alpha = 0;
    [UIView commitAnimations];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
