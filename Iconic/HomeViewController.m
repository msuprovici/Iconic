//
//  HomeViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Iconic All rights reserved.
//

#import "HomeViewController.h"
#import "MyStatsViewController.h"
#import "ContentController.h"

#import "Cache.h"
//#import "Utility.h"
#import "Constants.h"
#import "PNChart.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

@interface HomeViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) IBOutlet ContentController * contentController;

;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HomeViewController

@synthesize teamatesTable;




- (void)viewDidLoad
{
    



    //Retrieve from Parse
//    [self performSelector:@selector(retrieveFromParse)];
    
    
    
    
    
    
    
    
    
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
   [self.teamatesTable addSubview:self.pageControl];
   
    
//         //[self savePoints];
    
    
    
 [super viewDidLoad];

    
    
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
        
        
    
//        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
//        controller.statsImage.image = [UIImage imageNamed:[numberItem valueForKey:kImageKey]];
//        controller.viewTitle.text = [numberItem valueForKey:kNameKey];
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
//    PFQuery *retrieveScores = [PFQuery queryWithClassName:@"TeamName"];
//    retrieveScores.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    
//    
//    [retrieveScores findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        NSLog(@"%@", objects);
//        if (!error) {
//            vsTeamsArray = [[NSArray alloc] initWithArray:objects];
//        }
//        [teamatesTable reloadData];
//    }];
    
    
    

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
    return HeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 140;
        }
    }
    else if (indexPath.section == 1)
    {
    return 70;
    }
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sectionHeader.backgroundColor = HeaderColor;
    sectionHeader.textAlignment = HeaderAlignment;
    sectionHeader.font = HeaderFont;
    sectionHeader.textColor = HeaderTextColor;
    
    
    
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
        
        
      //  PFObject *tempObject = [vsTeamsArray objectAtIndex:indexPath.row];
        
//        //My Team
//        
//        cell.MyTeam.text = [tempObject objectForKey:@"MyTeam"]; //Team Name
//        cell.MyTeamScore.text = [NSString stringWithFormat:@"%@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score
//        
//        //Opponent Team
//        cell.VSTeam.text = [tempObject objectForKey:@"VSTeam"]; //Team Name
//        cell.MyTeamScore.text = [NSString stringWithFormat:@"%@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score
        
        
        //Line Chart Section
        
        //For LineChart
        
        //Static Labels
        cell.yChartLabel.text = @"Points";
        cell.yChartLabel.textColor = PNDeepGrey;
        cell.yChartLabel.font = [UIFont systemFontOfSize:11];
        cell.yChartLabel.textAlignment = NSTextAlignmentLeft;

        cell.xChartLabel.text = @"Day";
        cell.xChartLabel.textColor = PNDeepGrey;
        cell.xChartLabel.font = [UIFont systemFontOfSize:11];
        cell.xChartLabel.textAlignment = NSTextAlignmentCenter;
        
        //Dynamic Labels
       // PFObject *tempObject = [vsTeamsArray objectAtIndex:indexPath.row]; //Get team score from Parse
        
        // cell.MyTeamScore.text = [NSString stringWithFormat:@"MyTeam %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
        
        cell.MyTeamScore.text = @"MyTeam 1532"; //hardcoded for demo
        cell.MyTeamScore.textColor = PNBlue;
        cell.MyTeamScore.font = [UIFont boldSystemFontOfSize:13];
        cell.MyTeamScore.textAlignment = NSTextAlignmentLeft;
        
        
        
        //cell.VSTeamScore.text = [NSString stringWithFormat:@"Opponent %@",[tempObject objectForKey:@"MyTeamScore"]]; //Team Score from Parse
        
        cell.VSTeamScore.text = @"VsTeam 1711"; //hardcoded for demo
        cell.VSTeamScore.textColor = PNFreshGreen;
        cell.VSTeamScore.font = [UIFont boldSystemFontOfSize:13];
        cell.VSTeamScore.textAlignment = NSTextAlignmentLeft;
        
        PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, 275, 115)];
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
        [cell.teamMatchChart addSubview:lineChart];
       [cell addSubview:cell.yChartLabel];
       [cell addSubview:cell.xChartLabel];
        [cell addSubview:cell.MyTeamScore];
        [cell addSubview:cell.VSTeamScore];
        
        
        
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
       
        
        //cell.teamtePoints.text = [NSString stringWithFormat:@"%f", [points calculatePoints:100]];
        cell.teamteXP.text = [NSString stringWithFormat:@"%@",[tempObject objectForKey:@"xp"]];
        
    //Teammate photos
        
        //using PFImageView
        cell.teamtePicture.file = [tempObject objectForKey:@"Photo"];
        
        PFImageView *photo = [[PFImageView alloc] init];
        
        photo.image = [UIImage imageWithContentsOfFile:@"user_place_holder.png"]; // placeholder image
        photo.file = (PFFile *)cell.teamtePicture.file;
        
        [photo loadInBackground];

        //turn photo to circle
        CALayer *imageLayer = cell.teamtePicture.layer;
        [imageLayer setCornerRadius:cell.teamtePicture.frame.size.width/2];
        [imageLayer setBorderWidth:0];
        [imageLayer setMasksToBounds:YES];

        //XP Dials

        
        //cell.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
        //self.progressView.roundedCorners = YES;
       // cell.progressView.trackTintColor = [UIColor clearColor];
       // [cell.view addSubview:self.progressView];
        
        
        
        cell.circleProgressView.trackTintColor = PNGrey;
        cell.circleProgressView.progressTintColor = PNBlue;
        cell.circleProgressView.roundedCorners = YES;
        cell.circleProgressView.thicknessRatio = .25f;
        
        
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



//-(void)savePoints
//{
//    
//    
//    //Query special 'User' class in parse -> need to use PFUser
//    PFQuery *query = [PFUser query];
//    PFUser* currentUser = [PFUser currentUser];
//    
//    //creating query for current loggedin user
//    //[query whereKey:kUsername equalTo:[PFUser currentUser]];// Error: no results matched the query
//    //creating a points object for loggedin user
//    PFObject *points = [PFUser currentUser];
//
//    
//    //if it's the current user update points
//    if (currentUser) {
//        
//        
//        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
//        {
//            //To Do: create method for generating by amount increase in points & when to reset. 100 value is currently hardcoded.
//            [points incrementKey:kPlayerPoints byAmount:[self calculatePoints:100]];
//            
//            [points saveInBackground];
//            
//            //[points saveEventually];
//            //[points refresh]; //<- long running operation on the main thread
//            
//       }];
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
//         points[kPlayerPoints]= [self calculatePoints:150];
//        [points saveInBackground];
//       //[points saveEventually];
//        //[points refresh]; //<- long running operation on the main thread
//    }
//    
//    
//
//}


//-(void)retrievePlayerStats
//{
//    PFQuery *query = [PFUser query];
//    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    [query whereKey:kUser equalTo:[PFUser currentUser]];
//    
//    PFObject *playerStats = [PFUser currentUser];
//   
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
//     {
//         
//    //retrieve player stats from server
//    NSString *playerName = playerStats[KUsername];
//    PFFile *profilePicture = playerStats[kProfilePicture];
//    int points = [[playerStats objectForKey:kPlayerPoints] intValue];
//    int xp = [[playerStats objectForKey:kPlayerXP] intValue];
//    int steps = [[playerStats objectForKey:kPlayerSteps]intValue];//TO DO: retrieve steps from M7
//    NSString *playerTitle = playerStats[KPlayerTitle];
//         
//         //Download & display player photo from parse server
//         PFImageView *playerProfilePicture = [[PFImageView alloc] init];
//         playerProfilePicture.image = [UIImage imageNamed:@"empty_avatar.png"];//placeholder iamge
//         playerProfilePicture.file = (PFFile *)profilePicture;
//         [playerProfilePicture loadInBackground];
//         
//         
//         MyStatsViewController *controller = [[MyStatsViewController alloc] init];
////         controller.statsImage.image = [UIImage imageNamed:[numberItem valueForKey:kImageKey]];
////         controller.viewTitle.text = [numberItem valueForKey:kNameKey];
//         
//         controller.playerName.text = playerName;
//         controller.playerPhoto = playerProfilePicture;
//         controller.viewTitle.text = playerTitle;
//         controller.xpValue.text = [NSString stringWithFormat:@"%d",xp];
//         controller.pointsValue.text = [NSString stringWithFormat:@"%d",points];
//
//     }];
//    
//}

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
