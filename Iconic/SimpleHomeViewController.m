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
#import "SWRevealViewController.h"
#import "Cache.h"

#import "Constants.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

@interface SimpleHomeViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) IBOutlet ContentController * contentController;

//@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) NSTimer *timer;


@end

@implementation SimpleHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //reveal navigator
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    //this enables us to move the whole view with a swipe
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    //Retrieve from Parse
    [self performSelector:@selector(retrieveFromParse)];
    
    
    
    
    
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
    
    //For LineChart
    
    //Static Labels
    self.yChartLabel.text = @"Points";
    self.yChartLabel.textColor = PNDeepGrey;
    self.yChartLabel.font = [UIFont systemFontOfSize:11];
    self.yChartLabel.textAlignment = NSTextAlignmentLeft;
    
    self.xChartLabel.text = @"Day";
    self.xChartLabel.textColor = PNDeepGrey;
    self.xChartLabel.font = [UIFont systemFontOfSize:11];
    self.xChartLabel.textAlignment = NSTextAlignmentCenter;
    
    //Dynamic Labels
    // PFObject *tempObject = [vsTeamsArray objectAtIndex:indexPath.row]; //Get team score from Parse
    
    // cell.MyTeamScore.text = [NSString stringWithFormat:@"MyTeam %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
    
    self.MyTeamScore.text = @"MyTeam 1532"; //hardcoded for demo
    self.MyTeamScore.textColor = PNBlue;
    self.MyTeamScore.font = [UIFont boldSystemFontOfSize:15];
    self.MyTeamScore.textAlignment = NSTextAlignmentLeft;
    
    
    
    //cell.VSTeamScore.text = [NSString stringWithFormat:@"Opponent %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
    
    self.VSTeamScore.text = @"VsTeam 1711"; //hardcoded for demo
    self.VSTeamScore.textColor = PNFreshGreen;
    self.VSTeamScore.font = [UIFont boldSystemFontOfSize:15];
    self.VSTeamScore.textAlignment = NSTextAlignmentLeft;
    
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, 280, 210)];
    [lineChart setXLabels:@[@"1",@"2",@"3",@"4",@"5", @"6", @"7"]];
    //[lineChart setYLabels:@[@"0",@"100", @"200"]];
    
    // Line Chart No.1
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @127.2, @176.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNBlue;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data01Array objectAtIndex:index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    // Line Chart No.2
    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @167.2, @276.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = PNFreshGreen;
    data02.itemCount = lineChart.xLabels.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [[data02Array objectAtIndex:index] floatValue];
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
    
    //My Teamates
    PFQuery *retrieveTeamates = [PFQuery queryWithClassName:@"Test"];
    retrieveTeamates.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    
    [retrieveTeamates findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSLog(@"%@", objects);
        if (!error) {
            teamScores = [[NSArray alloc] initWithArray:objects];
        }
        
    }];
    
      
    
}



#pragma mark points & xp calculations



-(void)savePoints
{
    
    
    //Query special 'User' class in parse -> need to use PFUser
    PFQuery *query = [PFUser query];
    PFUser* currentUser = [PFUser currentUser];
    
    //creating query for current loggedin user
    //[query whereKey:kUsername equalTo:[PFUser currentUser]];// Error: no results matched the query
    //creating a points object for loggedin user
    PFObject *points = [PFUser currentUser];
    
    
    //if it's the current user update points
    if (currentUser) {
        
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
         {
             //To Do: create method for generating by amount increase in points & when to reset. 100 value is currently hardcoded.
             [points incrementKey:kPlayerPoints byAmount:[self calculatePoints:100]];
             
             [points saveInBackground];
             
             //[points saveEventually];
             //[points refresh]; //<- long running operation on the main thread
             
         }];
        
    }
    
    //if it's a new user create a new points object
    else
    {
        
        PFObject *points = [PFUser currentUser];
        
        [points setObject:[PFUser currentUser] forKey:kPlayerPoints];
        points[kPlayerPoints]= [self calculatePoints:150];
        [points saveInBackground];
        //[points saveEventually];
        //[points refresh]; //<- long running operation on the main thread
    }
    
    
    
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

@end
