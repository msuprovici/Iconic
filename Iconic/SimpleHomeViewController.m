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

#import "Cache.h"

#import "Constants.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

#import "UIImage+RoundedCornerAdditions.h"
#import "UIImage+ResizeAdditions.h"

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

@interface SimpleHomeViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) IBOutlet ContentController * contentController;
@property (nonatomic, strong) PFObject * activityObject;

@property (nonatomic, strong) PFObject * myteamObject;
@property (nonatomic, strong) PFObject * myteamObjectatIndex;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) NSMutableArray *myTeamData;

@property (strong, nonatomic) NSMutableArray * myTeamScores;

@property (strong, nonatomic) NSMutableArray * numberOfTeamScores;

@property (strong, nonatomic) NSMutableArray * arrayOfTeamScores;

@property (strong, nonatomic) NSArray * myTeamNames;

@property (nonatomic, assign) int x;

@property (nonatomic, assign) BOOL receivedNotification;



@property (strong, nonatomic) NSTimer *timer;

//for background taks

@property (nonatomic, assign) UIBackgroundTaskIdentifier activityPostBackgroundTaskId;

@end



@implementation SimpleHomeViewController

@synthesize activityPostBackgroundTaskId;
@synthesize activityObject;
@synthesize myteamObject;
@synthesize myteamObjectatIndex;
//@synthesize receivedNotification;
@synthesize x;

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

    //test tournament function
    
    
    //show player name header
    [self playerNameHeader];
    
    //Uncomment to test points and activity views
   //[self savePoints];
    
    //Page control for MyStatsView
    NSUInteger numberPages = self.contentList.count;
    
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
    
    
[self performSelector:@selector(retrieveFromParse)];
    
    
//    [self.scrollTeamsLeft setEnabled:FALSE];
//    [self.scrollTeamsRight setEnabled:TRUE];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES ];
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

    
    
    if (self.receivedNotification == YES) {
        [self retrieveFromParse];
         [self setReceivedNotification:NO];
    }
    
    
    
    //[self.view setNeedsDisplay];
    //[self receiveTestNotification:(NSNotification *)];
    //Retrieve from Parse
    //[self performSelector:@selector(retrieveFromParse)];
    //[self performSelector:@selector(retrieveFromParse)];

    }

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = self.contentList.count;
    
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
                    
                NSLog(@"team class query worked");
                    
                    
                    //making sure these items are visible in case they were reset when the player left all teams
                    self.teamMatchChart.hidden = NO;
                    self.vsTeamName.hidden = NO;
                    self.VSTeamScore.hidden = NO;
                
                //convert NSArray to myTeamDataArray
                self.myTeamData = [self createMutableArray:objects];
                 
            
                
                //get the 1st Object in the array
                int myFirstTeamIndex = [self.myTeamData indexOfObject:self.myTeamData.firstObject];
                self.myteamObjectatIndex = [self.myTeamData objectAtIndex:myFirstTeamIndex];
                
                //Update team chart & data
                    
                //show first team (index 0)
                [self updateTeamChart:0];
                
                [self.scrollTeamsLeft setEnabled:FALSE];
                [self.scrollTeamsRight setEnabled:TRUE];
                
                
                if(self.myTeamData.count <= 1)
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
                    x = self.numberOfTeamScores.count;
                }
                
                
                self.arrayOfTeamScores = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < self.myTeamData.count; i++) {
                    
                    
                    //create objects for
                    PFObject *myWeekleyTeamScores = [objects objectAtIndex:i];
                    
                    //get my weekleyTeamScores(array) objects
                    self.myTeamScores = [myWeekleyTeamScores objectForKey:kScoreWeek];
                    
                    //we add today's most uptodate data to the array
                    [self.myTeamScores addObject:[myWeekleyTeamScores objectForKey:kScoreToday]];
                    
                    //add objects to array of teamScores(array) objects so that we don't have to download again
                    [self.arrayOfTeamScores addObject:self.myTeamScores];
                    
                    //[self.arrayOfTeamScores replaceObjectAtIndex:i withObject:self.myTeamScores];
                        
                    
                }
               
        
            }
                else
                {
                    
                    //if the player is not on a team...
                    self.MyTeamName.text = @"NO TEAM";
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
                NSLog(@"query did not work");
                //Hardcoded for testing
                self.MyTeamName.text = @"NO TEAM";
                self.MyTeamScore.text = @"";
                
                
                
//                x = 0;
//                [self.myTeamScores addObject:[myWeekleyTeamScores objectForKey:kScoreToday]];
//                [self.arrayOfTeamScores addObject:self.myTeamScores];

            }
                
        
        }];
    
    //Query Team Class to see if the player's current team is the HOME team
    PFQuery *queryTeamMatchupsClass = [PFQuery queryWithClassName:kTeamMatchupClass];
 
    
    [queryTeamMatchupsClass whereKey:kHomeTeamName matchesKey:kTeams inQuery:query];
    [queryTeamMatchupsClass includeKey:kHomeTeam];
    [queryTeamMatchupsClass includeKey:kAwayTeam];
    [queryTeamMatchupsClass findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        if(!error)
        {
            NSLog(@"number of objects received: %d", objects.count);
            
            for (PFObject *object in objects)
            {
                
                NSString * round = [object objectForKey:kRound];
                //find the away team
                PFObject *awayTeamPointer =[object objectForKey:kAwayTeam];
                
                
                //need to use a dynamic variable for the current round here
                //hardcoeded round '3' for testing
                if ([round  isEqual: @"3"])
                {
                        //use the object that the class is pointing to in order to set the oposite team's name & score
                        self.vsTeamName.text = [awayTeamPointer objectForKey:kTeams];
                        self.VSTeamScore.text = [NSString stringWithFormat:@"%@",[awayTeamPointer objectForKey:kScore]];
                    
                }
                
                
            }
        }
        
    }];
    
    
    //parse forces us to make to calls here
    //need a better apprach then reapting the same calls twice
    
    //Query Team Class to see if the player's current team is the AWAY team
    PFQuery *queryawayTeamMatchupsClass = [PFQuery queryWithClassName:kTeamMatchupClass];
    
    
    [queryawayTeamMatchupsClass whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
    //[queryTeamMatchupsClass whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
    
    [queryawayTeamMatchupsClass findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        if(!error)
        {
            NSLog(@"number of objects received: %d", objects.count);
            
            for (int i = 0; i < objects.count; i++) {
                
            }
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
   
    
        //find the index of myTeamObject
        int myTeamIndex = [self.myTeamData indexOfObject:self.myteamObject];
        int myFirstTeamIndex = [self.myTeamData indexOfObject:self.myTeamData.firstObject];
    
        NSLog(@"index of myteamObject: %d", myTeamIndex);
    
        if (myTeamIndex <= self.myTeamData.count-1) {
           
           
            
             //we are no sending the index of the object to team chart rather then the whole object
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

}



- (IBAction)scrollTeamsLeft:(id)sender {
    
    
    //find the index of myTeamObject
    int myTeamIndex = [self.myTeamData indexOfObject:self.myteamObject];
    int myFirstTeamIndex = [self.myTeamData indexOfObject:self.myTeamData.firstObject];
    NSLog(@"index of myteamObject: %d", myTeamIndex);

    
     if (myTeamIndex <= self.myTeamData.count-1 )
    {
        [self.scrollTeamsRight setEnabled:TRUE];
        
        //self.myteamObjectatIndex = [self.myTeamData objectAtIndex:myTeamIndex-=1];
        
        
        //we are no sending the index of the object to team chart rather then the whole object
        int decrementTeamIndex = myTeamIndex -= 1;
        
        [self updateTeamChart:decrementTeamIndex];
        
        
        
        if (myTeamIndex == myFirstTeamIndex) {
            
            [self.scrollTeamsLeft setEnabled:FALSE];
            [self.scrollTeamsRight setEnabled:TRUE];
            
        }

    }

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
    
    PFObject * object = [self.myTeamData objectAtIndex:index];
    
    //set the value  of myTeamObject so that we can pass object to VSTableViewController
    self.myteamObject = object;
 
    //update the home screen
    
    
    self.MyTeamName.text = [NSString stringWithFormat:@"%@",[object objectForKey:kTeams]];
    self.MyTeamScore.text = [NSString stringWithFormat:@"%@",[object objectForKey:kScore]];
    self.MyTeamName.textColor = PNBlue;
    self.MyTeamScore.textColor = PNBlue;
    
//    self.vsTeamName.text = @"VS Team";
//    self.VSTeamScore.text = @"1200";
    self.vsTeamName.textColor = PNFreshGreen;
    self.VSTeamScore.textColor = PNFreshGreen;
    
    //For LineChart
    
    //Static Labels
    //self.yChartLabel.text = @"Points";
    self.yChartLabel.textColor = PNDeepGrey;
    self.yChartLabel.font = [UIFont systemFontOfSize:11];
    self.yChartLabel.textAlignment = NSTextAlignmentLeft;
    
    //self.xChartLabel.text = @"Day";
    self.xChartLabel.textColor = PNDeepGrey;
    self.xChartLabel.font = [UIFont systemFontOfSize:11];
    self.xChartLabel.textAlignment = NSTextAlignmentCenter;
    
    //Dynamic Labels
    // PFObject *tempObject = [vsTeamsArray objectAtIndex:indexPath.row]; //Get team score from Parse
    
    // cell.MyTeamScore.text = [NSString stringWithFormat:@"MyTeam %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
    
    //self.MyTeamScore.text = @"MyTeam"; //set in retrieveFromParse
    self.vsTeamName.textColor = PNBlue;
    self.MyTeamScore.textColor = PNBlue;
    self.MyTeamScore.font = [UIFont boldSystemFontOfSize:15];
    //self.MyTeamScore.textAlignment = NSTextAlignmentLeft; //Set in story board
    
    
    
    //cell.VSTeamScore.text = [NSString stringWithFormat:@"Opponent %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
    
    // self.VSTeamScore.text = @"VsTeam"; //set in retrieveFromParse
    self.vsTeamName.textColor = PNFreshGreen;
    self.VSTeamScore.textColor = PNFreshGreen;
    self.VSTeamScore.font = [UIFont boldSystemFontOfSize:15];
    //self.VSTeamScore.textAlignment = NSTextAlignmentLeft; //Set in story board
    
    
    
    //Team Chart
    
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, 260, 200)];
    
    //list of days of the week
    NSArray * daysArray = @[@"S",@"M",@"T",@"W",@"T", @"F", @"S"];
    
    
    // Line Chart for my team

    //set the index eagual to that of my team objects
    int i = index;
    
    //create a new array that gets the object from array of team scores
    //each object in arrayOfTeamScores is an array
    NSMutableArray *getWeekleyTeamScores = [self.arrayOfTeamScores objectAtIndex:i];
    
    
    //create a subarray that has the range of days played based on the amout of objects in myTeamScores
    
    //using 'x' where we store the number of weekley team scores to determine the days.
    NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, x)];
    // NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, [numberOfTeams count])]; //<-approach continues to add #s to the array eventually surppasing number of days, causing a crash
    
    //set the labels
    [lineChart setXLabels:daysPlayed];
    
    
    
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNBlue;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [[getWeekleyTeamScores objectAtIndex:index] floatValue]/100;// <- devided points value by 100 because PNChart does not support large Y values
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    
    // Line Chart No.2
    
    //hardcoded values for opposing team
    //TO DO: add opposing team data here
    NSArray * dummydataArray = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    //create a subarray that has the range of days played based on the amout of objects in myTeamScores

    //using 'x' where we store the number of weekley team scores to determine the days.
    NSArray *data02Array = [dummydataArray subarrayWithRange: NSMakeRange(0, x)];
    //NSArray *data02Array = [dummydataArray subarrayWithRange: NSMakeRange(0, [numberOfTeams count])];
    
    
    //NSArray *data02Array = @[@10, @20, @30, @40];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNFreshGreen;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue]/100; // <- devided points value by 100 because PNChart does not support large Y values
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data01, data02];
    
    
    [lineChart strokeChart];
    [self.teamMatchChart addSubview:lineChart];
    [self.view addSubview:self.yChartLabel];
    [self.view addSubview:self.xChartLabel];
    [self.view addSubview:self.MyTeamScore];
    [self.view addSubview:self.VSTeamScore];
    
    
    
    
    
    
    

    
}

#pragma page control UI

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



#pragma mark points & xp calculations



-(void)savePoints
{
    
    //test points value here
    //will need points
    NSNumber *newPoints = [self calculatePoints:108];
  
    
// Save points to ativity class
    
    PFObject *activity = [PFObject objectWithClassName:kActivityClassKey];
    [activity setObject:[PFUser currentUser] forKey:kActivityUserKey];
    [activity setObject:newPoints forKey:kActivityKey];
    
    // Activity is public, but may only be modified by the user
          PFACL *activityACL = [PFACL ACLWithUser:[PFUser currentUser]];
          [activityACL setPublicReadAccess:YES];
          activity.ACL = activityACL;

    
    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
          //  NSLog(@"Points uploaded");
            [[Cache sharedCache] setAttributesForActivity:activity likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];

        }
        
        else {
            NSLog(@"Points failed to save: %@", error);
        }
        
    }];
    
    //increment the player's points
    PFObject *playerPoints = [PFUser currentUser];
    
    //increment the player's TOTAL lifetime points
    [playerPoints incrementKey:kPlayerPoints byAmount:newPoints];
    
    //increment the player's today's points
    [playerPoints incrementKey:kPlayerPointsToday byAmount:newPoints];
    
    [playerPoints saveInBackground];
    
    
    //increment team's points by
    
    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
   [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
    
   [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
    
   [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d objects", objects.count);
            for (PFObject *object in objects)
            
            {
                  NSLog(@"%@", object.objectId);

                
                if (!error) {
                
                    //increment the team's TOTAL points
                [object incrementKey:kScore byAmount:newPoints];
                    
                    //increment the team's points for today
                 [object incrementKey:kScoreToday byAmount:newPoints];
                    
                [object saveInBackground];
                }
                  else
                  {
                      NSLog(@"error in inner query");
                  }
            }
            
        }
       else
       {
           NSLog(@"error");
       }
        
        
        
        
    }];

    
    
    
    
//    //if it's the current user update points
//    if (currentUser) {
//        
//        
//        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
//         {
//             //To Do: create method for generating by amount increase in points & when to reset. 100 value is currently hardcoded.
//             [points incrementKey:kPlayerPoints byAmount:[self calculatePoints:100]];
//             
//             [points saveInBackground];
//             
//             
//             
//             
//             //[points saveEventually];
//             //[points refresh]; //<- long running operation on the main thread
//             
//         }];
//        
//    }
//    
//    //if it's a new user create a new points object
//    else
//    {
//        
//        PFObject *points = [PFUser currentUser];
//        
//        [points setObject:[PFUser currentUser] forKey:kPlayerPoints];
//        points[kPlayerPoints]= [self calculatePoints:150];//<- hardcoded for now
//        
//        // Activity is public, but may only be modified by the user
//        PFACL *activityACL = [PFACL ACLWithUser:[PFUser currentUser]];
//        [activityACL setPublicReadAccess:YES];
//        points.ACL = activityACL;
//        
//        // Request a background execution task to allow us to finish uploading the points even if the app is backgrounded
//        self.activityPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//            [[UIApplication sharedApplication] endBackgroundTask:self.activityPostBackgroundTaskId];
//        }];
//
//        // save
//        [points saveInBackground];
//        
////        [points saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
////            if (succeeded) {
////                NSLog(@"Activity uploaded");
////                
////                [[Cache sharedCache] setAttributesForActivity:points likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
////                
////                // userInfo might contain any caption which might have been posted by the uploader
////                if (userInfo) {
////                    NSString *commentText = [userInfo objectForKey:kEditActivityViewControllerUserInfoCommentKey];
////                    
////                    if (commentText && commentText.length != 0) {
////                        // create and save photo caption
////                        PFObject *comment = [PFObject objectWithClassName:kPlayerActionClassKey];
////                        [comment setObject:kPlayerActionTypeComment forKey:kPlayerActionTypeKey];
////                        [comment setObject:points forKey:kActivityClassKey];
////                        [comment setObject:[PFUser currentUser] forKey:kPlayerActionFromUserKey];
////                        [comment setObject:[PFUser currentUser] forKey:kPlayerActionToUserKey];
////                        [comment setObject:commentText forKey:kPlayerActionContentKey];
////                        
////                        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
////                        [ACL setPublicReadAccess:YES];
////                        comment.ACL = ACL;
////                        
////                        [comment saveEventually];
////                        [[Cache sharedCache] incrementCommentCountForActivity:points];
////                    }
////                }
////                
////                [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:points];
////            } else {
////                NSLog(@"Photo failed to save: %@", error);
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
////                [alert show];
////            }
////            [[UIApplication sharedApplication] endBackgroundTask:self.activityPostBackgroundTaskId];
////        }];
//
//
//    }
//    
//    
    
}

-(NSNumber*)calculatePoints:(float)steps
{
    
    //alogrithm for generating points from steps: yourPoints = ((0.85^( ln(steps) /ln (2)))/time)*steps*constantValue
    
    //Converting float to NSNumber
    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50)];//rounded up to the largest following integer using ceiling function
    
    return points;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) receiveTeamNotification:(NSNotification *) notification
{
    //reload view if a player has joined a team
    
    if ([[notification name] isEqualToString:@"JoinedTeam"])
    {
        //Retrieve from Parse
        [self retrieveFromParse];
       //[self performSelector:@selector(retrieveFromParse)];
        [self setReceivedNotification:YES];
        [self.view setNeedsDisplay];
        
        NSLog(@"Received Joined Team Notification on home screen");
        ;
    }
    else if ([[notification name] isEqualToString:@"LeftTeam"])
    {
        //Retrieve from Parse
        //[self performSelector:@selector(retrieveFromParse)];
        [self retrieveFromParse];
        
       [self.view setNeedsDisplay];
        [self setReceivedNotification:YES];
        //self.receivedNotification = TRUE;
        NSLog(@"Received Leave Team Notification on home screen");
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




@end
