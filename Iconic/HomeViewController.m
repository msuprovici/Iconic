//
//  HomeViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "HomeViewController.h"
#import "MyStatsViewController.h"
#import "ContentController.h"
#import "SWRevealViewController.h"
#import "Cache.h"
//#import "Utility.h"
#import "Constants.h"

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

@interface HomeViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) IBOutlet ContentController * contentController;

@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HomeViewController

@synthesize teamatesTable;


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //reveal menu slider
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle:)];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    //this enables us to move the whole view with a swipe
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.rearViewRevealWidth = 150;
    //self.revealViewController.rearViewRevealOverdraw = 130;
   self.revealViewController.bounceBackOnOverdraw = YES;
    self.revealViewController.stableDragOnOverdraw = YES;
    //[self.revealViewController setFrontViewPosition:FrontViewPositionRight];

    
  
    [self performSelector:@selector(retrieveFromParse)];
    
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
    [self loadScrollViewWithPage:1];
    
    [self savePoints];
    
    
    
    
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
        
        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        controller.statsImage.image = [UIImage imageNamed:[numberItem valueForKey:kImageKey]];
        controller.viewTitle.text = [numberItem valueForKey:kNameKey];
       // controller.pointsValue.text = [NSString stringWithFormat:@"%@",[numberItem objectForKey:@"points"]];
        
        //Utility * addPoints =  [[Utility alloc]init] ;
        //[addPoints calculatePoints:100];
        
       // NSNumber * myNumber = [NSNumber numberWithFloat:[addPoints calculatePoints:100]];
        
        //self.PointsForPlayer[kPlayerPoints] = @"100";
        
        //PointsForPlayer[kPlayerPoints] = @"100";
        
//        PFObject *steps = [PFObject objectWithClassName:kPhysicalActivityClass];
//         steps[kPlayerPoints]=@150;
//        [self saveUserPointsInBackground:steps block:^(BOOL succeeded, NSError *error) {
//            if (!error) {
//                NSLog(@"Points Saved");
//               // self.PointsForPlayer[kPlayerPoints] = @"100";
//                
//               
//
//            
//            }
//            else
//            {
//                NSLog(@"Did not save points");
//            }
//            
//            
//        }];
        
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
    [self loadScrollViewWithPage:page + 1];
    
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


#pragma mark table view metods

//retrive table view data from parse
- (void) retrieveFromParse {
    
    //My Teamates
    PFQuery *retrieveTeamates = [PFQuery queryWithClassName:@"Test"];
    retrieveTeamates.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    
    [retrieveTeamates findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSLog(@"%@", objects);
       if (!error) {
            teamatesArray = [[NSArray alloc] initWithArray:objects];
        }
        [teamatesTable reloadData];
    }];
    
    //Competion
    PFQuery *retrieveScores = [PFQuery queryWithClassName:@"TeamName"];
    retrieveScores.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    
    [retrieveScores findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSLog(@"%@", objects);
        if (!error) {
            vsTeamsArray = [[NSArray alloc] initWithArray:objects];
        }
        [teamatesTable reloadData];
    }];
    
    
    

}





//*********************Setup table of folder names ************************



//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}



//create a header section for My Team
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sectionHeader.backgroundColor = [UIColor greenColor];
    sectionHeader.textAlignment = NSTextAlignmentCenter;
    sectionHeader.font = [UIFont fontWithName:@"DIN Alternate" size:17];
    sectionHeader.textColor = [UIColor blackColor];
    
    
    
    if(section == 0)
        
        sectionHeader.text = @"Match";
    
    
    else
        sectionHeader.text = @"My Team";
    
    return sectionHeader;
    
}



//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
    
        return 1;
   
   else
    return teamatesArray.count;
    }


//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //setup cell
    static NSString *CellIdentifier = @"teamatesCell";
    
    static NSString *vsCellIdentfier = @"vsCell";
    
    
    if(indexPath.section == 0)
    {
        VSCell *cell = [tableView dequeueReusableCellWithIdentifier:vsCellIdentfier forIndexPath:indexPath];
        
        PFObject *tempObject = [vsTeamsArray objectAtIndex:indexPath.row];
        
        //My Team
        
        cell.MyTeam.text = [tempObject objectForKey:@"MyTeam"]; //Team Name
        cell.MyTeamScore.text = [NSString stringWithFormat:@"%@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score
        
        //Opponent Team
        cell.VSTeam.text = [tempObject objectForKey:@"VSTeam"]; //Team Name
        cell.VSTeamScore.text = [NSString stringWithFormat:@"%@",[tempObject objectForKey:@"VSTeamScore"]]; //Team Score
        
        
        return cell;

        
    }
    
    else {
       
   
    TeamatesCell *cell = (TeamatesCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[TeamatesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    PFObject *tempObject = [teamatesArray objectAtIndex:indexPath.row];
    
   
    //Teamate Name
    cell.teamateName.text = [tempObject objectForKey:@"teammate"];
        
    //Teammate Points & XP
    cell.teamtePoints.text = [NSString stringWithFormat:@"%@",[tempObject objectForKey:@"points"]];
        
        //Using calculatePoints method to generate points:  hardcoded step count to 100 for now for now
       
        //Utility * points =  [[Utility alloc]init] ;
        //cell.teamtePoints.text = [NSString stringWithFormat:@"%f", [points calculatePoints:100]];
        cell.teamteXP.text = [NSString stringWithFormat:@"%@",[tempObject objectForKey:@"xp"]];
        
    //Teammate photos
    
    PFFile *imageFile = [tempObject objectForKey: @"Photo"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error)
        {
            cell.teamtePicture.image = [UIImage imageWithData:data];
        }
    }];
        
        //XP Dials
        
        cell.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
        //self.progressView.roundedCorners = YES;
       // cell.progressView.trackTintColor = [UIColor clearColor];
       // [cell.view addSubview:self.progressView];
        
        
        
        cell.circleProgressView.trackTintColor = [UIColor lightGrayColor];
        cell.circleProgressView.progressTintColor = [UIColor greenColor];
        //self.circleProgressView.roundedCorners = YES;
        cell.circleProgressView.thicknessRatio = .4f;
        
        
        //Convert XP # into a float & show progress indicator
        
        NSNumber *progress = [tempObject objectForKey:@"xp"];
        //this is just for demo purposes
        //TO DO:  playerProgress needs to be determined by how much one has to progress to get to the next XP level.  This value will be stored in parse.
        CGFloat playerProgress = [progress floatValue]/10;
        
        [cell.circleProgressView setProgress:playerProgress animated:YES];
        
            
       
    
    return cell;
    }
}




//user selects cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell tapped");
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"teammateProfile"])
    {
        NSLog(@"segue to teammateProfile");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark points & xp calculations



-(void)savePoints
{
    
    //if it's the current user update points
    if ([PFUser currentUser]) {
        
        //Query special 'User' class in parse -> need to use PFUser
        PFQuery *query = [PFUser query];
        //creating query for current loggedin user
        [query whereKey:kUser equalTo:[PFUser currentUser]];
        //creating a points object for loggedin user
        PFObject *points = [PFUser currentUser];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
        {
            //To Do: create method for generating by amount increase in points & when to reset. 100 value is currently hardcoded.
            [points incrementKey:kPlayerPoints byAmount:[self calculatePoints:100]];
            
            //[points saveInBackground];
            
            [points saveEventually];
            //[points refresh]; //<- long running operation on the main thread
            
       }];

    }
    
    //if it's a new user create a new points object
    else
    {
   
        PFObject *points = [PFUser currentUser];
        
        [points setObject:[PFUser currentUser] forKey:kPlayerPoints];
         points[kPlayerPoints]= [self calculatePoints:150];
        //[points saveInBackground];
        [points saveEventually];
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

//-(float)calculatePoints:(float)steps
//{
//    
//    //alogrithm for generating points from steps: yourPoints = ((0.85^( ln(steps) /ln (2)))/time)*steps*constantValue
//    
//    return ((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50);
//    
//    
//}





@end
