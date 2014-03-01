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

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) NSTimer *timer;

//for background taks

@property (nonatomic, assign) UIBackgroundTaskIdentifier activityPostBackgroundTaskId;

@end



@implementation SimpleHomeViewController

@synthesize activityPostBackgroundTaskId;
@synthesize activityObject;
@synthesize myteamObject;


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
    

    //test tournament function
    
//    [PFCloud callFunctionInBackground:@"tournament2"
//                       withParameters:@{@"NumberOfTeams":@"4"}
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
    
    
    //         //[self savePoints];
    
    //Line Chart Section
    
//    //For LineChart
//    
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
//    
//    //Dynamic Labels
//    // PFObject *tempObject = [vsTeamsArray objectAtIndex:indexPath.row]; //Get team score from Parse
//    
//    // cell.MyTeamScore.text = [NSString stringWithFormat:@"MyTeam %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
//    
//    //self.MyTeamScore.text = @"MyTeam"; //set in retrieveFromParse
//    self.vsTeamName.textColor = PNBlue;
//    self.MyTeamScore.textColor = PNBlue;
//    self.MyTeamScore.font = [UIFont boldSystemFontOfSize:15];
//    //self.MyTeamScore.textAlignment = NSTextAlignmentLeft; //Set in story board
//    
//    
//    
//    //cell.VSTeamScore.text = [NSString stringWithFormat:@"Opponent %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
//    
//   // self.VSTeamScore.text = @"VsTeam"; //set in retrieveFromParse
//    self.vsTeamName.textColor = PNFreshGreen;
//    self.VSTeamScore.textColor = PNFreshGreen;
//    self.VSTeamScore.font = [UIFont boldSystemFontOfSize:15];
//    //self.VSTeamScore.textAlignment = NSTextAlignmentLeft; //Set in story board
//    
//    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, 280, 220)];
//    [lineChart setXLabels:@[@"S",@"M",@"T",@"W",@"T", @"F", @"S"]];
//    //[lineChart setYLabels:@[@"0",@"100", @"200"]];
//    
//    // Line Chart No.1
//    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
//    PNLineChartData *data01 = [PNLineChartData new];
//    data01.color = PNBlue;
//    data01.itemCount = lineChart.xLabels.count;
//    data01.getData = ^(NSUInteger index) {
//        CGFloat yValue = [[data01Array objectAtIndex:index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
//    // Line Chart No.2
//    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
//    PNLineChartData *data02 = [PNLineChartData new];
//    data02.color = PNFreshGreen;
//    data02.itemCount = lineChart.xLabels.count;
//    data02.getData = ^(NSUInteger index) {
//        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
//    
//    lineChart.chartData = @[data01, data02];
//    [lineChart strokeChart];
//    [self.teamMatchChart addSubview:lineChart];
//    [self.view addSubview:self.yChartLabel];
//    [self.view addSubview:self.xChartLabel];
//    [self.view addSubview:self.MyTeamScore];
//    [self.view addSubview:self.VSTeamScore];
//    
//    
//    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES ];
   
    
     
    //[self receiveTestNotification:(NSNotification *)];
    //Retrieve from Parse
    [self performSelector:@selector(retrieveFromParse)];
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
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
   [query2 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)  {
      //  [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
       
       //adding ojbec to myteamObject
       //[self.myteamObject setObject:object forKey:kTeams];
      
      
        
        if (!error) {
            
       // for (PFObject *object in objects){
            
            
        PFObject *firstObject = [object objectForKey:kTeam];
        [query whereKey:@"objectId" equalTo:firstObject.objectId];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
        //[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            
          //  for (PFObject *object in objects){
            
            
            if(!error)
            {
                
                //set the value  of myTeamObject so that we can pass object to VSTableViewController
                self.myteamObject = object;
                
                
                
                //update the home screen
                
            NSLog(@"team class query worked");
            self.MyTeamName.text = [NSString stringWithFormat:@"%@",[object objectForKey:kTeams]];
            self.MyTeamScore.text = [NSString stringWithFormat:@"%@",[object objectForKey:kScore]];
                self.MyTeamName.textColor = PNBlue;
                self.MyTeamScore.textColor = PNBlue;
                
            self.vsTeamName.text = @"VS Team";
            self.VSTeamScore.text = @"1200";
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
   
                //get the daily score data from the days before, if any
                NSMutableArray * myTeamScores = [object objectForKey:kScoreWeek];
                
                //we add today's most uptodate data to the array
                [myTeamScores addObject:[object objectForKey:kScoreToday]];
                
                //create a subarray that has the range of days played based on the amout of objects in myTeamScores
                NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, [myTeamScores count])];
                
                //set the labels
                 [lineChart setXLabels:daysPlayed];
                
                
                PNLineChartData *data01 = [PNLineChartData new];
                data01.color = PNBlue;
                data01.itemCount = lineChart.xLabels.count;
                data01.getData = ^(NSUInteger index) {
                    CGFloat yValue = [[myTeamScores objectAtIndex:index] floatValue]/100;// <- devided points value by 100 because PNChart does not support large Y values
                    return [PNLineChartDataItem dataItemWithY:yValue];
                };
                
                
                // Line Chart No.2
                
                //hardcoded values for opposing team
                //TO DO: add opposing team data here
                NSArray * dummydataArray = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
                //create a subarray that has the range of days played based on the amout of objects in myTeamScores
               NSArray *data02Array = [dummydataArray subarrayWithRange: NSMakeRange(0, [myTeamScores count])];
                
                
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
            else
            {
                NSLog(@"query did not work");
                //Hardcoded for testing
                self.MyTeamName.text = @"NO TEAM";
                self.MyTeamScore.text = @"";

            }
                
                
           // }
        }];
            
       // }
            
        
         
        }
        else{
            //Hardcoded for testing
            self.MyTeamName.text = @"NO TEAM";
            self.MyTeamScore.text = @"";
            
            
        }
        
         
         
        
   
    }];
    
    
    
//        if(!error)
//        {
//  
//        //[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//
//        self.MyTeamScore.text = [NSString stringWithFormat:@"%@",[object objectForKey:kTeams]];
//            
//        //}];
//         
//        }
//        }
//    }];
//    
    
    
}

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
        [self performSelector:@selector(retrieveFromParse)];
        [self.view setNeedsDisplay];
        
        NSLog(@"Received Joined Team Notification on home screen");
        ;
    }
    else if ([[notification name] isEqualToString:@"LeftTeam"])
    {
        //Retrieve from Parse
        [self performSelector:@selector(retrieveFromParse)];
        [self.view setNeedsDisplay];
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
