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

@property (strong, nonatomic) NSMutableArray * myTeamScores;

@property (strong, nonatomic) NSMutableArray * numberOfTeamScores;

@property (strong, nonatomic) NSMutableArray * arrayOfTeamScores;


@property (strong, nonatomic) NSMutableArray * vsTeamScores;
@property (strong, nonatomic) NSMutableArray * vsTeamScoresAway;
@property (strong, nonatomic) NSMutableArray * arrayOfvsTeamScores;


//@property (strong, nonatomic) NSMutableArray * myMatchups;
@property (strong, nonatomic) NSArray * myMatchups;
@property (strong, nonatomic) NSMutableArray * homeTeamPointers;
@property (strong, nonatomic) NSMutableArray * awayTeamPointers;
@property (strong, nonatomic) NSMutableArray * homeTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfhomeTeamScores;
@property (strong, nonatomic) NSMutableArray * awayTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfawayTeamScores;


@property (nonatomic, assign) NSUInteger x;

@property (nonatomic, assign) BOOL receivedNotification;



@property (strong, nonatomic) NSTimer *timer;

//for background taks

@property (nonatomic, assign) UIBackgroundTaskIdentifier activityPostBackgroundTaskId;



//step counting
@property (nonatomic, strong) CMStepCounter *cmStepCounter;
@property (nonatomic, strong) CMMotionActivityManager *motionActivity;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSMutableArray *stepsArray;
@property (nonatomic, strong) NSMutableArray *myWeeleyPointsArray;

//convert steps to points and store here
@property NSNumber* myPoints;

//days left in the week
@property int daysLeft;

@end



@implementation SimpleHomeViewController

@synthesize activityPostBackgroundTaskId;
@synthesize activityObject;
@synthesize myteamObject;
@synthesize myteamObjectatIndex;
//@synthesize receivedNotification;
@synthesize x;
@synthesize myPoints;

//Notifications NOT working

//- (void)dealloc {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JoinedTeam" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LeftTeam" object:nil];
//}
//
//-(id)init
//{
//    //Notification to let the view konw that a player has joined/left team
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTeamNotification:) name:@"JoinedTeam" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTeamNotification:) name:@"LeftTeam" object:nil];
//    
//
//    return self;
//}


//- (NSOperationQueue *)operationQueue
//{
//    if (_operationQueue == nil)
//    {
//        _operationQueue = [NSOperationQueue new];
//    }
//    return _operationQueue;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self)
//    {
//        //load my stats
//        [self refreshHomeView];
//    }
//    return self;
//}
-(id)init
{
    
    
    [self refreshHomeView];
    
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshHomeView)
                                                 name:UIApplicationDidFinishLaunchingNotification object:nil];
    //add past 7 days steps to an array
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(findPastWeekleySteps)
                                                 name:UIApplicationDidFinishLaunchingNotification object:nil];

    
    //refreshes the app when it enters foreground
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshHomeView)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //test tournament function
    
    
    //show player name header
    //[self playerNameHeader];
    self.playerPhoto.hidden = YES;
    
    
    
    [PFQuery clearAllCachedResults];
    //load my stats
    //show first team (index 0)
    [self updateTeamChart:0];
    
    

    [self refreshHomeView];
    //calculate days left in the week
    [self calculateDaysLeftinTheWeek];
    
    [self getMotionData];
    //calcualte weekely steps and add them to an array
    //[self findPastWeekleySteps];

    
    //Uncomment to test points and activity views
   //[self savePoints];
    
//    //Page control for MyStatsView
//    NSUInteger numberPages = self.contentList.count;
//    
//    // view controllers are created lazily
//    // in the meantime, load the array with placeholders which will be replaced on demand
//    NSMutableArray *controllers = [[NSMutableArray alloc] init];
//    for (NSUInteger i = 0; i < numberPages; i++)
//    {
//		[controllers addObject:[NSNull null]];
//    }
//    self.viewControllers = controllers;
//    
//    // a page is the width of the scroll view
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.contentSize =
//    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView.scrollsToTop = NO;
//    self.scrollView.delegate = self;
//    
//    self.pageControl.numberOfPages = numberPages;
//    self.pageControl.currentPage = 0;
//    
//    // pages are created on demand
//    // load the visible page
//    // load the page on either side to avoid flashes when the user starts scrolling
//    //
//    [self loadScrollViewWithPage:0];
//    //[self loadScrollViewWithPage:1];
//    [self.view addSubview:self.pageControl];
   
    
//    //retrived team data from parse and populate chart
//    [self performSelector:@selector(retrieveFromParse)];
//    
//    //increment points
//   [self incrementPlayerPoints];
  
    

    
    
//    
//    [PFCloud callFunctionInBackground:@"tournament2"
//                       withParameters:@{@"NumberOfTeams":@"2"}
//                                block:^(NSString *result, NSError *error) {
//                                    if (!error) {
//                                        // show matchups
//                                        
//                                        /*ScheduleGenerator *item1 = [[ScheduleGenerator alloc] init];
//                                         item1.itemName = [NSString stringWithFormat: @"%@", result
//                                         [self.scheduledMatchups addObject:item1];*/
//                                        
//                                        
//                                        NSLog(@"%@", result);
//                                    }
//                                }];

    
    
//    [self.scrollTeamsLeft setEnabled:FALSE];
//    [self.scrollTeamsRight setEnabled:TRUE];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES ];
    
//    //Page control for MyStatsView
//    NSUInteger numberPages = self.contentList.count;
//    
//    // view controllers are created lazily
//    // in the meantime, load the array with placeholders which will be replaced on demand
//    NSMutableArray *controllers = [[NSMutableArray alloc] init];
//    for (NSUInteger i = 0; i < numberPages; i++)
//    {
//		[controllers addObject:[NSNull null]];
//    }
//    self.viewControllers = controllers;
//    
//    // a page is the width of the scroll view
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.contentSize =
//    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, CGRectGetHeight(self.scrollView.frame));
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView.scrollsToTop = NO;
//    self.scrollView.delegate = self;
//    
//    self.pageControl.numberOfPages = numberPages;
//    self.pageControl.currentPage = 0;
//    
//    // pages are created on demand
//    // load the visible page
//    // load the page on either side to avoid flashes when the user starts scrolling
//    //
//    [self loadScrollViewWithPage:0];
//    //[self loadScrollViewWithPage:1];
//    [self.view addSubview:self.pageControl];
    
    
//    [self loadSteps];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"JoinedTeam" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LeftTeam" object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveTeamNotification:)
//                                                 name:@"JoinedTeam"
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveTeamNotification:)
//                                                 name:@"LeftTeam"
//                                               object:nil];

    
    
//    if (self.receivedNotification == YES) {
//        [self retrieveFromParse];
//        
//        //using a timer in case parse did not receive all the data
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(retrieveFromParse) userInfo:nil repeats:NO];
//        
//        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0f]];
//         [self setReceivedNotification:NO];
//    }
    
    
    
    //[self.view setNeedsDisplay];
    //[self receiveTestNotification:(NSNotification *)];
    //Retrieve from Parse
    //[self performSelector:@selector(retrieveFromParse)];
    //[self performSelector:@selector(retrieveFromParse)];

    }


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
    
    
  
    
    //increment points
    [self incrementPlayerPoints];
    
    
//    [self findPastWeekleySteps];
    
    [self retrieveFromParse];

    

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



#pragma mark Parse Methods

//retrive table view data from parse
- (void) retrieveFromParse {
    
    
    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
    
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    

            if(!error)
            {
                //check to see if the player is on a team
                if(objects.count > 0)
                {
                    
//                NSLog(@"team class query worked");
                    
                    
                    //making sure these items are visible in case they were reset when the player left all teams
                    self.teamMatchChart.hidden = NO;
                    self.vsTeamName.hidden = NO;
                    self.VSTeamScore.hidden = NO;
                
                //convert NSArray to myTeamDataArray
                self.myTeamData = [self createMutableArray:objects];
                 
            
                
                //get the 1st Object in the array
//                int myFirstTeamIndex = [self.myTeamData indexOfObject:self.myTeamData.firstObject];
//                self.myteamObjectatIndex = [self.myTeamData objectAtIndex:myFirstTeamIndex];
                    
//                    int myFirstTeamIndex = [self.myMatchups indexOfObject:self.myMatchups.firstObject];
//                    self.myteamObjectatIndex = [self.myMatchups objectAtIndex:myFirstTeamIndex];
                
                //Update team chart & data
                    
//                //show first team (index 0)
//                [self updateTeamChart:0];
                
                [self.scrollTeamsLeft setEnabled:FALSE];
                [self.scrollTeamsRight setEnabled:TRUE];
                
                
                if(self.myMatchups.count <= 1)
                {
                    self.scrollTeamsRight.hidden = YES ;
                    self.scrollTeamsLeft.hidden = YES ;
                    
                }
                else
                {
                    self.scrollTeamsRight.hidden = NO ;
                    self.scrollTeamsLeft.hidden = NO ;
                    
                }
                
                for (PFObject * object in objects)
                {
                    self.numberOfTeamScores = [object objectForKey:kScoreWeek];
                    //we are storing the mumber of teams in the array so that we can use it to calculate the number of daysPlayed
                    x = self.numberOfTeamScores.count+1;
                }
                
                
//                self.arrayOfTeamScores = [[NSMutableArray alloc] init];
//                
//                for (int i = 0; i < self.myTeamData.count; i++) {
//                    
//                    
//                    //create objects for
//                    PFObject *myWeekleyTeamScores = [objects objectAtIndex:i];
//                    
//                    //get my weekleyTeamScores(array) objects
//                    self.myTeamScores = [myWeekleyTeamScores objectForKey:kScoreWeek];
//                    
//                    //we add today's most uptodate data to the array
//                    [self.myTeamScores addObject:[myWeekleyTeamScores objectForKey:kScoreToday]];
//                    
//                    
//                    //add objects to array of teamScores(array) objects so that we don't have to download again
//                    [self.arrayOfTeamScores addObject:self.myTeamScores];
//                    
//                    //[self.arrayOfTeamScores replaceObjectAtIndex:i withObject:self.myTeamScores];
//                    NSLog(@"array of MY teamScores: %lu", (unsigned long)self.arrayOfTeamScores.count);
//                    NSLog(@"MYteamScores: %lu", (unsigned long)self.myTeamScores.count);
//
//                    
//                }
                    //show first team (index 0)
//                    [self updateTeamChart:0];

        [self updateTeamChart:0];
            }
                else
                {
                    
                    //if the player is not on a team...
                    self.MyTeamName.text = @"No Team";
                    self.MyTeamScore.text = @"";
                    self.scrollTeamsRight.hidden = YES ;
                    self.scrollTeamsLeft.hidden = YES ;
                    self.teamMatchChart.hidden = YES;
                    self.vsTeamName.hidden = YES;
                    self.VSTeamScore.hidden = YES;
                    
                }
                
        
           
                
            }
            else
            {
//                NSLog(@"query did not work");
                //Hardcoded for testing
                self.MyTeamName.text = @"NO TEAM";
                self.MyTeamScore.text = @"";
                
                
                
//                x = 0;
//                [self.myTeamScores addObject:[myWeekleyTeamScores objectForKey:kScoreToday]];
//                [self.arrayOfTeamScores addObject:self.myTeamScores];

            }
                
        
        }];
    
    //Query Team Class to see if the player's current team is the HOME team
    PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryHomeTeamMatchups whereKey:kHomeTeamName matchesKey:kTeams inQuery:query];
    
   
    
    PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryAwayTeamMatchups whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
  
    
    PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups,queryAwayTeamMatchups]];
    
    [queryTeamMatchupsClass includeKey:kHomeTeam];
    [queryTeamMatchupsClass includeKey:kAwayTeam];
    
    
    queryAwayTeamMatchups.cachePolicy = kPFCachePolicyCacheThenNetwork;
    queryHomeTeamMatchups.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [queryTeamMatchupsClass findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        if(!error)
        {
            

            if(objects.count > 0)
            {
//            NSLog(@"number of objects received: %lu", (unsigned long)objects.count);
                
                
                
                //this approach does not work because self.homeTeamScores is empty until we reach the loop bellow...
                
//                int newdaysLeft = (int)[self.daysLeft intValue];
//                 NSLog(@"homeTeamScores count: %d", (int)self.homeTeamScores.count);
//                NSLog(@"daysLeft: %d", (int)daysLeft);
                
                
                
            for (int i = 0; i < objects.count; i++) {
                
                PFObject *myMatchupObject = [objects objectAtIndex:i];
                
                
                NSString * round = [myMatchupObject objectForKey:kRound];

                
                self.arrayOfhomeTeamScores = [[NSMutableArray alloc] init];
                self.arrayOfawayTeamScores = [[NSMutableArray alloc] init];
                
                self.awayTeamPointers = [[NSMutableArray alloc] init];
                self.homeTeamPointers = [[NSMutableArray alloc] init];
                
                //self.myMatchups = [[NSMutableArray alloc] init];
                //int daysLeft = (int)(7 - self.homeTeamScores.count);
                
               
                
                //the round is hardcoded for now, need to make this dynamic based on the torunatment's status
                if ([round  isEqual: @"1"])
                {
                   
                    for (int i = 0; i < objects.count; i++) {
                       
                        PFObject *myMatchupObject = [objects objectAtIndex:i];
//                        NSLog(@"objects count: %lu", (unsigned long)objects.count);
                        
                        //add all objects to a array so that we can send the correct one to the next view controller
                        self.myMatchups = objects;
                        
                        //acces away & home team pointers in parse
                        PFObject* awayTeamPointer = [myMatchupObject objectForKey:kAwayTeam];
                        PFObject* homeTeamPointer = [myMatchupObject objectForKey:kHomeTeam];
                        
                        //add pointers to an array
                        [self.awayTeamPointers addObject:awayTeamPointer];
                        [self.homeTeamPointers addObject:homeTeamPointer];
                        
                        /* TO DO:  must move the code bellow out of this for loop */
                        
                        //creating an array to add toays scores and 0 values to the tail end of the downloaded socores
                        //this way there will always be 7 objects in the array even if we have not played for 7 days
                        //ex: if we played for 3/7 days, insert 0 for index 3 - 6 (day 4 - 7)
                        
                         //create array and include today's most recent data
//                         NSMutableArray *homeEndObjects = [[NSMutableArray alloc]initWithObjects:[homeTeamPointer objectForKey:kScoreToday], nil ];
                        
                        //create an empty array
//                        NSMutableArray *endObjects = [[NSMutableArray alloc]initWithObjects: nil ];
//                         NSLog(@"endObjects: %lu", (unsigned long)endObjects.count);
//                        //add 0s to the tail end of this array for the days that have not been played yet
//                        int zero = 0;
//                        NSNumber *zeroWrapped = [NSNumber numberWithInt:zero];
//                        
//
//                        //instead of 2 create a variable for # of days left in the week
//                        for (int z = 0; z < self.daysLeft; z++)
//                        {
//                            [endObjects addObject:zeroWrapped];
//                            NSLog(@"endObjects after inserting 0s: %lu", (unsigned long)endObjects.count);
//                        }
                    
                        
                    //Home Team Scores
                    //get homeTeamScores(array) objects
                    self.homeTeamScores = [homeTeamPointer objectForKey:kScoreWeek];
                    
                    //we add today's most uptodate data to the array
                    //[myArray addObjectsFromArray:otherArray];
//                    [self.homeTeamScores addObject:[homeTeamPointer objectForKey:kScoreToday]];
//                    [self.homeTeamScores addObjectsFromArray:endObjects];
                    
                    //add objects to array of teamScores(array) objects so that we don't have to download again
                    [self.arrayOfhomeTeamScores addObject:self.homeTeamScores];
                    
                    
                    //Away Team Scores
                    //get awayTeamScores(array) objects
                    
                    self.awayTeamScores = [awayTeamPointer objectForKey:kScoreWeek];
                        
                    
                    //we add today's most uptodate data to the array
//                    [self.awayTeamScores addObject:[awayTeamPointer objectForKey:kScoreToday]];
                    
                     
                    //add objects to array of teamScores(array) objects so that we don't have to download again
                    [self.arrayOfawayTeamScores addObject:self.awayTeamScores];
                    
                    
                    //logs
                    
//                    //home team
//                    NSLog(@"homeTeamScores: %lu", (unsigned long)self.homeTeamScores.count);
//                    NSLog(@"arrayOfhomeTeamScores: %lu", (unsigned long)self.arrayOfhomeTeamScores.count);
//                    
//                    //away team
//                    NSLog(@"awayTeamScores: %lu", (unsigned long)self.awayTeamScores.count);
//                    NSLog(@"arrayOfawayTeamScores: %lu", (unsigned long)self.arrayOfawayTeamScores.count);
//                        
//                    //pointers
//                    NSLog(@"awayTeamPointers: %lu", (unsigned long)self.awayTeamPointers.count);
//                    NSLog(@"homeTeamPointers: %lu", (unsigned long)self.arrayOfawayTeamScores.count);

                        
                    }
                    
                }
       

            }

                
        }
         
        
            

        }
        else
        {
            self.vsTeamName.text = @"NO TEAM";
        }
       

    }];
    
    
}

- (NSMutableArray *)createMutableArray:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}

#pragma mark scroll teams buttons

//scroll through team data
- (IBAction)scrollTeamsRight:(id)sender {
    
    //find the index of myNewTeamObject - we are using data (myTeamData array) received from 'query'
    //*!* using data (myMatchups) from queryTeamMatchupsClass leaks objects. it can't find myteamObject after adding/removing teams using the logic bellow
    int myTeamIndex = (int)[self.myTeamData indexOfObject:self.myNewTeamObject];
    int myFirstTeamIndex = (int)[self.myTeamData indexOfObject:self.myTeamData.firstObject];
    
    
    
    
//    NSLog(@"index of myteamObjectRight: %d", myTeamIndex);
    
    if (myTeamIndex <= self.myTeamData.count-1) {
        
        int incrementTeamIndex = myTeamIndex += 1;
        
        [self updateTeamChart:incrementTeamIndex];
        
        if (myTeamIndex == self.myTeamData.count-1 )
        {
            
            [self.scrollTeamsRight setEnabled:FALSE];
            [self.scrollTeamsLeft setEnabled:TRUE];
            
        }
        if (myTeamIndex > myFirstTeamIndex) {
            
            [self.scrollTeamsLeft setEnabled:TRUE];
            
        }
    }

   
    
//        //find the index of myTeamObject
//        int myTeamIndex = (int)[self.myMatchups indexOfObject:self.myteamObject];
//        int myFirstTeamIndex = (int)[self.myMatchups indexOfObject:self.myMatchups.firstObject];
//    
//    
//    
//    
//        NSLog(@"index of myteamObjectRight: %d", myTeamIndex);
//    
//        if (myTeamIndex <= self.myMatchups.count-1) {
//           
//            int incrementTeamIndex = myTeamIndex += 1;
//            
//            [self updateTeamChart:incrementTeamIndex];
//            
//            if (myTeamIndex == self.myMatchups.count-1 )
//            {
//                
//                [self.scrollTeamsRight setEnabled:FALSE];
//                [self.scrollTeamsLeft setEnabled:TRUE];
//                
//            }
//            if (myTeamIndex > myFirstTeamIndex) {
//                
//                [self.scrollTeamsLeft setEnabled:TRUE];
//
//            }
//        }

}



- (IBAction)scrollTeamsLeft:(id)sender {
    
    
    //find the index of myTeamObject - see comments above in scrollTeamsRight
    int myTeamIndex = (int)[self.myTeamData indexOfObject:self.myNewTeamObject];
    int myFirstTeamIndex = (int)[self.myTeamData indexOfObject:self.myTeamData.firstObject];
//    NSLog(@"index of myteamObjectLeft: %d", myTeamIndex);
    
    
    if (myTeamIndex <= self.myTeamData.count-1 )
    {
        [self.scrollTeamsRight setEnabled:TRUE];
        
        int decrementTeamIndex = myTeamIndex -= 1;
        
        [self updateTeamChart:decrementTeamIndex];
        
        
        
        if (myTeamIndex == myFirstTeamIndex) {
            
            [self.scrollTeamsLeft setEnabled:FALSE];
            [self.scrollTeamsRight setEnabled:TRUE];
            
        }
        
    }

    
//    
//    //find the index of myTeamObject
//    int myTeamIndex = (int)[self.myMatchups indexOfObject:self.myteamObject];
//    int myFirstTeamIndex = (int)[self.myMatchups indexOfObject:self.myMatchups.firstObject];
//    NSLog(@"index of myteamObjectLeft: %d", myTeamIndex);
//
//    
//     if (myTeamIndex <= self.myMatchups.count-1 )
//    {
//        [self.scrollTeamsRight setEnabled:TRUE];
//        
//        int decrementTeamIndex = myTeamIndex -= 1;
//        
//        [self updateTeamChart:decrementTeamIndex];
//        
//        
//        
//        if (myTeamIndex == myFirstTeamIndex) {
//            
//            [self.scrollTeamsLeft setEnabled:FALSE];
//            [self.scrollTeamsRight setEnabled:TRUE];
//            
//        }
//
//    }

}

#pragma mark update Team Chart

-(void)setTeamScore:(PFObject *)object
{
    // self.myteamObject = object;
    //get the daily score data from the days before, if any
    self.myTeamScores = [object objectForKey:kScoreWeek];
    
    
    //we add today's most uptodate data to the array
    [self.myTeamScores addObject:[object objectForKey:kScoreToday]];
    
    
}



//-(void)updateTeamChart:(PFObject *)object

-(void)updateTeamChart:(int)index
{
    self.myteamObject = [self.myMatchups objectAtIndex:index];
    
    self.myNewTeamObject = [self.myTeamData objectAtIndex:index];

    
    //get home and away teams
    PFObject * homeTeam = [self.homeTeamPointers objectAtIndex:index];
    PFObject * awayTeam = [self.awayTeamPointers objectAtIndex:index];
    
   
    //set home(MyTeamName) and away (vsTeamName) teams attributes
    //MyTeamName does not always equal the home team
    NSString * homeTeamName = [NSString stringWithFormat:@"%@",[homeTeam objectForKey:kTeams]];
    NSString * awayTeamName = [NSString stringWithFormat:@"%@",[awayTeam objectForKey:kTeams]];
    
    NSNumber *homeTeamScore = [NSNumber numberWithInt:[[homeTeam objectForKey:kScore]intValue]];
//    int myHomeTeamScore = [NSNumber numberWithInt:(int)[homeTeamScore intValue]];
    NSNumber *awayTeamScore = [NSNumber numberWithInt:[[awayTeam objectForKey:kScore]intValue]];;
//    int myAomeTeamScore = [awayTeamScore intValue];
    
    self.MyTeamName.text = [NSString stringWithFormat:@"%@",[homeTeam objectForKey:kTeams]];
    self.MyTeamScore.text = [NSString stringWithFormat:@"%@",[homeTeam objectForKey:kScore]];
    self.MyTeamName.textColor = PNBlue;
    self.MyTeamScore.textColor = PNBlue;
    
    self.vsTeamName.text = [NSString stringWithFormat:@"%@",[awayTeam objectForKey:kTeams]];
    self.VSTeamScore.text = [NSString stringWithFormat:@"%@",[awayTeam objectForKey:kScore]];
    self.vsTeamName.textColor = PNGreen;
    self.VSTeamScore.textColor = PNGreen;
 
    //update the home screen
    
    
//    self.MyTeamName.text = [NSString stringWithFormat:@"%@",[object objectForKey:kTeams]];
//    self.MyTeamScore.text = [NSString stringWithFormat:@"%@",[object objectForKey:kScore]];
//    self.MyTeamName.textColor = PNBlue;
//    self.MyTeamScore.textColor = PNBlue;
//    
////    self.vsTeamName.text = @"VS Team";
////    self.VSTeamScore.text = @"1200";
//    self.vsTeamName.textColor = PNGreen;
//    self.VSTeamScore.textColor = PNGreen;
    
    //For LineChart
    
//    //Static Labels
//    //self.yChartLabel.text = @"Points";
//    self.yChartLabel.textColor = PNDeepGrey;
//    self.yChartLabel.font = [UIFont systemFontOfSize:11];
//    self.yChartLabel.textAlignment = NSTextAlignmentLeft;
//    
//    //self.xChartLabel.text = @"Day";
//    self.xChartLabel.textColor = PNDeepGrey;
//    self.xChartLabel.font = [UIFont systemFontOfSize:11];
//    self.xChartLabel.textAlignment = NSTextAlignmentCenter;
    
    //Dynamic Labels
    // PFObject *tempObject = [vsTeamsArray objectAtIndex:indexPath.row]; //Get team score from Parse
    
    // cell.MyTeamScore.text = [NSString stringWithFormat:@"MyTeam %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
    
    //self.MyTeamScore.text = @"MyTeam"; //set in retrieveFromParse
    self.vsTeamName.textColor = PNBlue;
    self.MyTeamScore.textColor = PNBlue;
    //self.MyTeamScore.font = [UIFont boldSystemFontOfSize:15];
    //self.MyTeamScore.textAlignment = NSTextAlignmentLeft; //Set in story board
    
    
    
    //cell.VSTeamScore.text = [NSString stringWithFormat:@"Opponent %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
    
    // self.VSTeamScore.text = @"VsTeam"; //set in retrieveFromParse
    self.vsTeamName.textColor = PNGreen;
    self.VSTeamScore.textColor = PNGreen;
    //self.VSTeamScore.font = [UIFont boldSystemFontOfSize:15];
    //self.VSTeamScore.textAlignment = NSTextAlignmentLeft; //Set in story board
    
    
    
//    //Team Chart
//    
//    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, 260, 200)];
//    
//    //list of days of the week
//    NSArray * daysArray = @[@"S",@"M",@"T",@"W",@"T", @"F", @"S"];
//    
//    
//    // Line Chart for my team
//
//    //set the index eagual to that of my team objects
//    int i = index;
//    
//    //create a new array that gets the object from array of team scores
//    //each object in arrayOfTeamScores is an array
//    //NSMutableArray *getWeekleyTeamScores = [self.arrayOfTeamScores objectAtIndex:i];
//    
//    NSMutableArray *getWeekleyTeamScores = [self.arrayOfhomeTeamScores objectAtIndex:i];
//
//    //create a subarray that has the range of days played based on the amout of objects in myTeamScores
//    
//    //using 'x' where we store the number of weekley team scores to determine the days.
//    NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, x)];
//    // NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, [numberOfTeams count])]; //<-approach continues to add #s to the array eventually surppasing number of days, causing a crash
//    
//    //set the labels
//    [lineChart setXLabels:daysPlayed];
//    
//    
//    
//    PNLineChartData *data01 = [PNLineChartData new];
//    data01.color = PNBlue;
//    data01.itemCount = lineChart.xLabels.count;
//    data01.getData = ^(NSUInteger index) {
//        CGFloat yValue = [[getWeekleyTeamScores objectAtIndex:index] floatValue]/100;// <- devided points value by 100 because PNChart does not support large Y values
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
//    
//    
//    // Line Chart No.2
//    
//    //hardcoded values for opposing team
//    //TO DO: add opposing team data here
//   //NSArray * dummydataArray = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
//    //create a subarray that has the range of days played based on the amout of objects in myTeamScores
//
//    //using 'x' where we store the number of weekley team scores to determine the days.
//    //NSArray *data02Array = [dummydataArray subarrayWithRange: NSMakeRange(0, x)];
//    //NSArray *data02Array = [dummydataArray subarrayWithRange: NSMakeRange(0, [numberOfTeams count])];
//     //NSMutableArray *getvsWeekleyTeamScores = [self.arrayOfvsTeamScores objectAtIndex:i];
//    
//    NSMutableArray *getvsWeekleyTeamScores = [self.arrayOfawayTeamScores objectAtIndex:i];
//    
//    //NSArray *data02Array = @[@10, @20, @30, @40];
//    PNLineChartData *data02 = [PNLineChartData new];
//    data02.color = PNGreen;
//    data02.itemCount = lineChart.xLabels.count;
//    data02.getData = ^(NSUInteger index) {
//        CGFloat yValue = [[getvsWeekleyTeamScores objectAtIndex:index] floatValue]/100; // <- devided points value by 100 because PNChart does not support large Y values
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
//    
//    lineChart.chartData = @[data01, data02];
//    
//    
//    [lineChart strokeChart];
//    [self.teamMatchChart addSubview:lineChart];
//    [self.view addSubview:self.yChartLabel];
//    [self.view addSubview:self.xChartLabel];
//    [self.view addSubview:self.MyTeamScore];
//    [self.view addSubview:self.VSTeamScore];
    
    
    //create bar chart to display days
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 248)];
    
    //    PNBarChart * barChart = [[PNBarChart alloc] init];
    
    //list of days of the week
    NSArray * teamsNamesArray = @[homeTeamName, awayTeamName];
    
    
    
    //getting historical daily points arary from server
    //    NSMutableArray * playerPoints = [currentUser objectForKey:kPlayerPointsWeek];
     NSArray * teamPoints = @[homeTeamScore, awayTeamScore];
//    NSArray * teamPoints = @[@100, @40];
    //we add todays most uptodate data to the array
    //    [playerPoints addObject:[currentUser valueForKey:kPlayerPointsToday]];
    
    
    //            int indexValue = [playerPoints indexOfObject:playerPoints.lastObject];
    //
    //
    //            [playerPoints replaceObjectAtIndex:indexValue withObject:[currentUser valueForKey:kPlayerPointsToday]];
    
    
    //    //create a subarray that has the range of days played based on the amout of objects in playerPoints
    //    NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, [playerPoints count])];
    
    //set the labels
//    [barChart setXLabels:teamsNamesArray];
    
    [barChart setYValues:teamPoints];
    
    //sets the maximum value of the label.  so if the player has a goal of say 10k points/day then we would use this.
    //[barChart setYLabels:@[@500]];
    
    [barChart setStrokeColors:@[PNLightBlue, PNGreen]];
    [barChart setBarBackgroundColor:PNWhite];
    //    [barChart setStrokeColor:PNLightBlue];
    [barChart strokeChart];
    
    [self.teamBarChart addSubview:barChart];
    
}

#pragma mark page control UI

-(void) playerNameHeader
{
    // This is to generate thumbnail a player's thumbnail, name & title
    PFQuery* query = [PFUser query];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    PFUser* currentUser = [PFUser currentUser];
    
    if (currentUser) {
        //Get all player stats from Parse
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.playerName.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kUsername]] ;
            
           
            
            //Player photo
            //using PFImageView
            self.playerPhoto.file = [currentUser objectForKey:kUserProfilePicSmallKey];
            
//            PFImageView *photo = [[PFImageView alloc] init];
//
//            photo.file = (PFFile *)self.playerPhoto.file;
            
            [self.playerPhoto loadInBackground];
            
            //turn photo to circle
            CALayer *imageLayer = self.playerPhoto.layer;
            [imageLayer setCornerRadius:self.playerPhoto.frame.size.width/2];
            [imageLayer setBorderWidth:0];
            [imageLayer setMasksToBounds:YES];
            
        }];
    }
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSNotifications methods

- (void) receiveTeamNotification:(NSNotification *) notification
{
    //reload view if a player has joined a team
    
    if ([[notification name] isEqualToString:@"JoinedTeam"])
    {
        //Retrieve from Parse
        [self retrieveFromParse];
        
        //using a timer in case parse did not receive all the data
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(retrieveFromParse) userInfo:nil repeats:NO];
        
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0f]];
        [self setReceivedNotification:NO];
       //[self performSelector:@selector(retrieveFromParse)];
        [self setReceivedNotification:YES];
        [self.view setNeedsDisplay];
        
//        NSLog(@"Received Joined Team Notification on home screen");
        ;
    }
    else if ([[notification name] isEqualToString:@"LeftTeam"])
    {
        //Retrieve from Parse
        //[self performSelector:@selector(retrieveFromParse)];
        [self retrieveFromParse];
        
        //using a timer in case parse did not receive all the data
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(retrieveFromParse) userInfo:nil repeats:NO];
        
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:3.0f]];
        [self setReceivedNotification:NO];
        
       [self.view setNeedsDisplay];
        [self setReceivedNotification:YES];
        //self.receivedNotification = TRUE;
//        NSLog(@"Received Leave Team Notification on home screen");
    }
}


#pragma mark - Navigation

//pass the team to the teammates view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"vs"]) {
        
        //Find the row the button was selected from
        
        [segue.destinationViewController initWithReceivedTeam:self.myteamObject];
        
       
        
    }
}


#pragma mark Step Counting

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [NSOperationQueue new];
    }
    return _operationQueue;
}

-(void)findPastWeekleySteps {
    // Get now date
    NSDate *now = [NSDate date];
    
    // Array to hold step values
    _stepsArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    // Check if step counting is avaliable
    if ([CMStepCounter isStepCountingAvailable]) {
        // Init step counter
        self.cmStepCounter = [[CMStepCounter alloc] init];
        // Tweak this value as you need (you can also parametrize it)
        NSInteger daysBack = 7;
        for (NSInteger day = daysBack; day > 0; day--) {
            NSDate *fromDate = [now dateByAddingTimeInterval: -day * 24 * 60 * 60];
            NSDate *toDate = [fromDate dateByAddingTimeInterval:24 * 60 * 60];
            
            [self.cmStepCounter queryStepCountStartingFrom:fromDate to:toDate     toQueue:self.operationQueue withHandler:^(NSInteger numberOfSteps, NSError *error) {
                if (!error) {
//                    NSLog(@"queryStepCount returned %ld steps", (long)numberOfSteps);
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [_stepsArray addObject:@(numberOfSteps)];
                        
                        
                        if ( day == 1) { // Just reached the last element, we can now do what we want with the data
                            NSLog(@"_stepsArray filled with data: %@", _stepsArray);
                            
                            
                            //add the past 7 days worth of steps to NSuserdefualuts
                           
                            NSUserDefaults *myStats = [NSUserDefaults standardUserDefaults];
                            [myStats setObject:_stepsArray forKey:kMyStepsWeekArray];
                            
                            
                            //convert the past 7 days worth of steps to points
                            NSMutableArray * myWeekleyPoints = [[NSMutableArray alloc]initWithCapacity:7];
                            
                            for (int i = 0; i < _stepsArray.count; i++)
                            {
                                float daysSteps = [[_stepsArray objectAtIndex:i]floatValue] ;
                                [myWeekleyPoints addObject:[self calculatePoints:daysSteps]];
                                
                            }
                            
                            NSLog(@"myWeekleyPoints: %@", myWeekleyPoints);
                            
                            //save to NSUserDefaults
                            [myStats setObject:myWeekleyPoints forKey:kMyPointsWeekArray];
                            
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            
                            //save the past 7 days worth of steps & points to Parse
                            PFObject *playerStats = [PFUser currentUser];
                            [playerStats setObject:_stepsArray forKey:kPlayerStepsWeek];
                            [playerStats setObject:myWeekleyPoints forKey:kPlayerPointsWeek];
                            [playerStats saveEventually];

                        }
                        
                    }];
                
                    
                } else {
                    NSLog(@"Error occured: %@", error.localizedDescription);
                }
            }];
            
        }
    } else {
        NSLog(@"device not supported");
    }
    
    
    
}

#pragma mark Motion Activity

-(void)getMotionData {
    self.motionActivity = [[CMMotionActivityManager alloc] init];
    
    NSLog(@"activities called");
    
    NSDate *now = [NSDate date];
//    NSDate *from = [self beginningOfDay];
    NSDate *from = [self beginningOfDay];
   
    [self.motionActivity queryActivityStartingFromDate:from toDate:now toQueue:self.operationQueue withHandler:^(NSArray *activities, NSError *error) {
        NSLog(@"activities array: %@", activities);
        
        NSLog(@"activities array count: %lu", (unsigned long)activities.count);
    }];


}
#pragma mark - points & xp calculations


-(void)incrementPlayerPoints
{
    self.stepCounter = [[CMStepCounter alloc] init];
    NSDate *now = [NSDate date];
//    //NSDate *from = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:now];
//    
//    //find today's date
//    NSDate* sourceDate = [NSDate date];
//    
//    //convert to my local time zone
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone* myTimeZone = [NSTimeZone localTimeZone];
//    
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
//    NSInteger myGMTOffset = [myTimeZone secondsFromGMTForDate:sourceDate];
//    NSTimeInterval interval = myGMTOffset - sourceGMTOffset;
//    
//    NSDate* myDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate]init];
//  
//    NSDate *now = myDate;

    NSDate *from = [self beginningOfDay];
    
    //find the number of steps I have take today
    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        
        
        
        //convert steps to points
        //check for NAN values
        if(numberOfSteps == 0)
        {
            self.myPoints = 0;
            
        }
        else
        {
        self.myPoints = [self calculatePoints:numberOfSteps];
        }
        

        
        //set the player's total points in memory
        NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //to prevent null values check if # of steps is 0
        if(numberOfSteps == 0)
        {
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyPointsToday];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else
        {
        
        //saving most recent points before doing calcualtions to increment total lifetime points
        //we are going to use this value to start the couter in the counting label in MyStatsViewController
        [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyMostRecentPointsBeforeSaving];
        [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyPointsToday];
        int myMostRecentPointsValue = [self.myPoints intValue];
        int myPointsDeltaValue = myMostRecentPointsValue - myStoredPoints;
        
//        NSLog(@"myStoredPoints: %d", myStoredPoints);
//        NSLog(@"myMostRecentPointsValue: %d", myMostRecentPointsValue);
//        NSLog(@"myPointsDeltaValue: %d", myPointsDeltaValue);
        
        
        [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyPointsToday];
        
        
        //increment a player's total # of points
        
        //to do:
        //for 1st time users get 7 days worth of data & set here
        //for returning users retrieve a user's total points & set here
        
        int myTotalPoints = (int)[myRetrievedPoints integerForKey:kMyPointsTotal];
        int myNewTotalPoints = myTotalPoints + myPointsDeltaValue;
//        int myTotalPoints = 244;
//        int myNewTotalPoints = 244;
        
//        NSLog(@"myTotalPoints: %d", myTotalPoints);
//        NSLog(@"myNewTotalPoints: %d", myNewTotalPoints);
        
        [myRetrievedPoints setInteger:myNewTotalPoints  forKey:kMyPointsTotal];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //save the player's points for today to the server
        PFObject *playerPoints = [PFUser currentUser];
        [playerPoints setObject:self.myPoints forKey:kPlayerPointsToday];
        [playerPoints saveEventually];
        
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if(!error)
            {
                //retrieve the number of points in the database
//                NSNumber* retrievedPoints = [object objectForKey:kPlayerPointsToday];
//                NSNumber* lifetimePoints = [object objectForKey:kPlayerPoints];
//                
//                //convert nsnumbers to an ints so we can do math
//                int retrievedPointsValue = [retrievedPoints intValue];
////                NSLog(@"retrievedPointsValue: %d", retrievedPointsValue);
//                
//                int myPointsValue = [self.myPoints intValue];
////                NSLog(@"myPointsValue: %d", myPointsValue);
//                
//                //get delta between my current points and what is stored in the database
//                int pointsDeltaValue = myPointsValue - retrievedPointsValue;
////                NSLog(@"pointsDeltaValue: %d", pointsDeltaValue);
//                
//                //convert delta back to nsnumber
//               
//                NSNumber* pointsDelta = [NSNumber numberWithInt:pointsDeltaValue];
                

                //calculate level
//                float retrievedLevelValue = [lifetimePoints floatValue];
                
                
                
                NSNumber *myLevel = [self calculateLevel:myNewTotalPoints];
                float myLevelValue = [myLevel floatValue];
                
                //get the total points necessary for next level
                
                NSNumber *totalPointsToNextLevel = [self calculatePointsToReachNextLevel:myLevelValue];
                
                int myTotalPointsToNextLevelValue = [totalPointsToNextLevel intValue];
//                NSLog(@"myTotalPointsToNextLevelValue: %d", myTotalPointsToNextLevelValue);
//                 NSLog(@"retrievedLevelValue: %f", retrievedLevelValue);
                
                 //subtract the player's points from the current #
//                int pointsToNextLevelDelta = myTotalPointsToNextLevelValue - retrievedLevelValue;
                
                 int pointsToNextLevelDelta = myTotalPointsToNextLevelValue - myNewTotalPoints;
//              NSLog(@"pointsToNextLevelDelta: %d", pointsToNextLevelDelta);
                
                //calculate the # of points necessary to reach the next level
                NSNumber* myPointsToNextLevelDelta = [NSNumber numberWithInt:pointsToNextLevelDelta];
                
                //convert delta to NSNumber so we can increment later
                 NSNumber* myNSPointsDeltaValue = [NSNumber numberWithInt:myPointsDeltaValue];
                
                //To update an existing object, you first need to retrieve it
                
                //increment myPoints
//                [object incrementKey:kPlayerPointsToday byAmount:pointsDelta];
                
                //[object incrementKey:kPlayerPointsToday byAmount:myNSPointsDeltaValue];
                [object incrementKey:kPlayerPoints byAmount:myNSPointsDeltaValue];
                
                //set player's level
                [object setObject:myLevel forKey:kPlayerXP];
                //save #points needed to reach the next level
                [object setObject:myPointsToNextLevelDelta forKey:kPlayerPointsToNextLevel];
                //save the player's points for today to the server
               
                
                
                //save points
                //[object saveInBackground];
                [object saveEventually];//<-from Parse forums: "saveEventually should not trigger multiple-writer issues, but "inBackground" methods can"

                
                
//                //increment myPoints
//                [playerPoints incrementKey:kPlayerPointsToday byAmount:pointsDelta];
//                [playerPoints incrementKey:kPlayerPoints byAmount:pointsDelta];
//                
//                //set player's level
//                [playerPoints setObject:myLevel forKey:kPlayerXP];
//                //save #points needed to reach the next level
//                [playerPoints setObject:myPointsToNextLevelDelta forKey:kPlayerPointsToNextLevel];
//                
//
//                //save points
//                [playerPoints saveInBackground];
                
                
                
                //increment the points for all my teams
               [self incrementMyTeamsPoints:myNSPointsDeltaValue];
    
            }
            

        }];
            
        }

    }];
    
}



-(void)incrementMyTeamsPoints:(NSNumber*)delta
{

    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
//    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
    //Query where the current user is a teamate
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        

        if (!error) {
            // The find succeeded.
            //NSLog(@"Successfully retrieved my %lu teams", (unsigned long)objects.count);
            for (PFObject *object in objects)
                
            {
                //NSLog(@"%@", object.objectId);
                
                
                if (!error) {
                    
                    //increment the team's TOTAL points
                    [object incrementKey:kScore byAmount:delta];
                    
                    //increment the team's points for today
                    [object incrementKey:kScoreToday byAmount:delta];
                    
                    [object saveEventually];
                }
                else
                {
//                    NSLog(@"error in inner query");
                }
            }
            
        }
        else
        {
//            NSLog(@"error");
        }

    }];

}



-(NSNumber*)calculatePoints:(float)steps
{
    
    //alogrithm for generating points from steps: yourPoints = ((0.85^( ln(steps) /ln (2)))/time)*steps*constantValue
    
    //Converting float to NSNumber
    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50)];//rounded up to the largest following integer using ceiling function
    
      return points;
}


-(NSNumber*)calculateLevel:(float)points
{
    
    //scale = 11
    //hardcoded for now - will need to send this number down from the server
    //rounded up to the largest following integer using ceiling function
    //had to add 1.0 so that the level is never 0
   // NSNumber * level = [NSNumber numberWithFloat: ceil((pow((points/1000), (1/1)))+1.0)];
    
    
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * level = [NSNumber numberWithFloat: floor((pow((points/1000), (1/1)))+1.0)];

//    if(level == 0 || level == nil)
//        return [NSNumber numberWithInteger:1];
//    else
    return level;
}

-(NSNumber*)calculatePointsToReachNextLevel:(float)level
{
    
    //scale = 1
    //hardcoded for now - will need to send this number down from the server
//    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(level, 1)*1000))+1]; //rounded up to the largest following integer using ceiling function
    
    
 //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level, 1)*1000))+1];
    
    return points;
}

#pragma mark NSDate & Time
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
    
    return [cal dateFromComponents:components];
    
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
    //
    //
    //        NSLog(@"Converted date: %@",myDate);
    //        NSLog(@"Source date: %@",myDate);
    //
    //
    //    return myDate;
   
}

-(void)calculateDaysLeftinTheWeek
{
    //get Sunday in the current week
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
//    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    //calculate beginning of next week
    /* !This approach might not work on daylight savigs! */
    [componentsToSubtract setDay: 8 - ([weekdayComponents weekday] - 1)];
    
    
    NSDate *beginningOfNextWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    /*
     Optional step:
     beginningOfNextWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfNextWeek];
    beginningOfNextWeek = [gregorian dateFromComponents:components];
    
    
    //get the difference between the 2 dates
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *newComponents = [gregorian components:unitFlags fromDate:today toDate:beginningOfNextWeek options:0];
//    NSInteger months = [newComponents month];
    self.daysLeft = (int)[newComponents day];
    
    NSLog(@"days left in the week: %d", (int)self.daysLeft);
}



@end
