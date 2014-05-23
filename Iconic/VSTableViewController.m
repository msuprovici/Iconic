//
//  VSTableViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 2/28/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "VSTableViewController.h"
#import "Constants.h"
#import "Parse/Parse.h"
#import "VSTableViewCell.h"
#import "CalculatePoints.h"
#import "PNColor.h"

@interface VSTableViewController ()

@property (strong, nonatomic) NSTimer *timer;
//@property NSArray * teamMatchups;



@end

@implementation VSTableViewController

@synthesize timer = _timer;

- (id)initWithCoder:(NSCoder *)aDecoder{
     self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom the table
//        [self downloadTeams];
        
        // The className to query on
        self.parseClassName = kTeamPlayersClass;
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 4;
    }
    return self;
}

//get the players team passed from the leagues view controller
//-(void)initWithReceivedTeam:(PFObject *)aReceivedTeam
//{
//    self.receivedTeam = aReceivedTeam;
//    
//}


-(void)initWithReceivedTeam:(int)matchupsIndex
{
    self.matchupsIndex = matchupsIndex;
//    NSLog(@"Segue index received: %d", self.matchupsIndex);
    
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIColor *color = PNCloudWhite;
//    self.view.backgroundColor = color;
    
   [self loadTeams:self.matchupsIndex];
    //populate timer
    
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



    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//method to show days in timer label

- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    
    int second = (int)time  % 60;
    int minute = ((int)time / 60) % 60;
    int hours = ((int)time / 3600 )% 24;
    int days = (((int)time / 3600) / 24)% 60;
    
    return [NSString stringWithFormat:@"%01d %02d %02d %02d", days,hours,minute,second];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - get teams

-(void)loadTeams: (int)index
{
    
    //retrieve data from the arrays in nsuserdefaults
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    NSArray *homeTeamScores = [RetrievedTeams objectForKey:kArrayOfHomeTeamScores];
    NSArray *awayTeamScores = [RetrievedTeams objectForKey:kArrayOfAwayTeamScores];
    
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
    
    NSArray *arrayOfWeekleyTeamScoresArrays = [RetrievedTeams objectForKey:kArrayOfWeekleyHomeTeamScores];
    NSArray *arrayOfWeekleyAwayTeamScoresArrays = [RetrievedTeams objectForKey:kArrayOfWeekleyAwayTeamScores];
    
    NSArray *arrayOfTodayHomeTeamScores = [RetrievedTeams objectForKey:kArrayOfTodayHomeTeamScores];
//    NSLog(@"arrayOfTodayHomeTeamScores VS: %@", arrayOfTodayHomeTeamScores);
    NSArray *arrayOfTodayAwayTeamScores = [RetrievedTeams objectForKey:kArrayOfTodayAwayTeamScores];
//     NSLog(@"arrayOfTodayAwayTeamScores VS: %@", arrayOfTodayAwayTeamScores);
    
    NSArray *arrayOfMyTeamNames = [RetrievedTeams objectForKey:kArrayOfMyTeamsNames];

    
    
    
    //set my team name
    self.myTeamName.text = [NSString stringWithFormat:@"%@",[arrayOfMyTeamNames objectAtIndex:index]];
    
    self.myTeamName.text = self.myTeamReceived;
    
    
    
    
    
    //ensure that my team is always displayed in the left hand side
    //if my team is the home team set the data for the labels
    if([self.myTeamReceived isEqualToString:[homeTeamNames objectAtIndex:index]])
    {

    //home team score
    self.myTeamScore.text = [NSString stringWithFormat:@"%@",[homeTeamScores objectAtIndex:index]];
    
       //home team name
    self.myTeam.text = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:index]];

    //create an array for the daily scores for the week
    //have to make mutableCopy because values returned from NSUserDefaults are immutable
    NSMutableArray * homeTeamWeekleyScores = [[arrayOfWeekleyTeamScoresArrays objectAtIndex:index]mutableCopy];
    
    //add the updated score for today to the array
    NSNumber *todaysHomeTeamScore = [arrayOfTodayHomeTeamScores objectAtIndex:index];
    [homeTeamWeekleyScores addObject:todaysHomeTeamScore];
    
    //we add values to ensure the array is never empty through index 6
    [homeTeamWeekleyScores addObjectsFromArray:@[@"-", @"-", @"-", @"-", @"-", @"-", @"-"]];
    
    //we add each day's score to the appropriate label
    self.myTeamMonday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:0]];
    self.myTeamTuesday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:1]];
    self.myTeamWednesday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:2]];
    self.myTeamThursday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:3]];
    self.myTeamFriday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:4]];
    self.myTeamSaturday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:5]];
    self.myTeamSunday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:6]];
    
    
    //home team score
    self.vsTeamScore.text = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:index]];
    
    //home team name
    self.vsTeam.text = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:index]];

    
    //have to make mutableCopy because values returned from NSUserDefaults are immutable
    //add the updated score for today to the array
    NSMutableArray * awayTeamWeekleyScores = [[arrayOfWeekleyAwayTeamScoresArrays objectAtIndex:index]mutableCopy];
    
    //add the updated score for today to the array
    NSNumber *todaysAwayTeamScore = [arrayOfTodayAwayTeamScores objectAtIndex:index];
    [awayTeamWeekleyScores addObject:todaysAwayTeamScore];
    
    
    //we add values to ensure the array is never empty through index 6
    [awayTeamWeekleyScores addObjectsFromArray:@[@"-", @"-", @"-", @"-", @"-", @"-", @"-"]];
    
    //we add each day's score to the appropriate label
    self.vsTeamMonday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:0]];
    self.vsTeamTuesday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:1]];
    self.vsTeamWednesday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:2]];
    self.vsTeamThursday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:3]];
    self.vsTeamFriday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:4]];
    self.vsTeamSaturday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:5]];
    self.vsTeamSunday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:6]];

    }
    
    /*Reverse the data for the labels*/
    //if my team is the away team REVERSE the data for the labels
    else if([self.myTeamReceived isEqualToString: [awayTeamNames objectAtIndex:index]])
    {
        //home team score
        self.myTeamScore.text = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:index]];
        
        //home team name
        self.myTeam.text = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:index]];
        
        
        
        
        //create an array for the daily scores for the week
        //have to make mutableCopy because values returned from NSUserDefaults are immutable
        NSMutableArray * homeTeamWeekleyScores = [[arrayOfWeekleyAwayTeamScoresArrays objectAtIndex:index]mutableCopy];
        
        //add the updated score for today to the array
        NSNumber *todaysHomeTeamScore = [arrayOfTodayAwayTeamScores objectAtIndex:index];
        [homeTeamWeekleyScores addObject:todaysHomeTeamScore];
        
        //we add values to ensure the array is never empty through index 6
        [homeTeamWeekleyScores addObjectsFromArray:@[@"-", @"-", @"-", @"-", @"-", @"-", @"-"]];
        
        //we add each day's score to the appropriate label
        self.myTeamMonday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:0]];
        self.myTeamTuesday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:1]];
        self.myTeamWednesday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:2]];
        self.myTeamThursday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:3]];
        self.myTeamFriday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:4]];
        self.myTeamSaturday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:5]];
        self.myTeamSunday.text = [NSString stringWithFormat:@"%@",[homeTeamWeekleyScores objectAtIndex:6]];
        
        
        //home team score
        self.vsTeamScore.text = [NSString stringWithFormat:@"%@",[homeTeamScores objectAtIndex:index]];
        
        //home team name
        self.vsTeam.text = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:index]];
        
        
        //have to make mutableCopy because values returned from NSUserDefaults are immutable
        //add the updated score for today to the array
        NSMutableArray * awayTeamWeekleyScores = [[arrayOfWeekleyTeamScoresArrays objectAtIndex:index]mutableCopy];
        
        //add the updated score for today to the array
        NSNumber *todaysAwayTeamScore = [arrayOfTodayHomeTeamScores objectAtIndex:index];
        [awayTeamWeekleyScores addObject:todaysAwayTeamScore];
        
        
        //we add values to ensure the array is never empty through index 6
        [awayTeamWeekleyScores addObjectsFromArray:@[@"-", @"-", @"-", @"-", @"-", @"-", @"-"]];
        
        //we add each day's score to the appropriate label
        self.vsTeamMonday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:0]];
        self.vsTeamTuesday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:1]];
        self.vsTeamWednesday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:2]];
        self.vsTeamThursday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:3]];
        self.vsTeamFriday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:4]];
        self.vsTeamSaturday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:5]];
        self.vsTeamSunday.text = [NSString stringWithFormat:@"%@",[awayTeamWeekleyScores objectAtIndex:6]];
        
    }
    
    
    
    

}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     
//     PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//     [query whereKey:kTeam equalTo:self.receivedTeam];
//     
//     [query includeKey:kTeamate];
//     
//     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     
     
//     NSLog(@"home team in table %@", self.homeTeam);
//     NSLog(@"away team in table %@", self.awayTeam);
     
     //Query Team Class - query that mathches team names sent in segue
     PFQuery *homeTeamsClass = [PFQuery queryWithClassName:kTeamTeamsClass];
     [homeTeamsClass whereKey:kTeams equalTo:self.homeTeam];
     
     
     PFQuery *awayTeamsClass = [PFQuery queryWithClassName:kTeamTeamsClass];
     [awayTeamsClass whereKey:kTeams equalTo:self.awayTeam];
     
     
     //query either home or away teams
     PFQuery *retrievedTeams = [PFQuery orQueryWithSubqueries:@[homeTeamsClass,awayTeamsClass]];

     
     //Query Teamates Class (query to find what the team the player is on)
     PFQuery *playersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
     [playersClass whereKey:kTeamate equalTo:[PFUser currentUser]];
     [retrievedTeams whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:playersClass];

     
     //finally get the players that are on that team
     PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
     [query includeKey:kTeam];
     [query includeKey:kTeamate];
     
     [query whereKey:kTeam matchesKey:@"objectId" inQuery:retrievedTeams];
     
     
     
     // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
         query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
     
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
         query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
     
     // Order by categories type
     [query orderByDescending:@"createdAt"];
     return query;

 }



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"myTeamates";
    
    VSTableViewCell *cell = (VSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    // Configure the cell
    
    [cell setUser:[object objectForKey:kTeamate]];
    
    
    
    
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

//dirty way to hide all other cells that do not contain data
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
//    UIColor *color = PNCloudWhite;
//    
//    view.backgroundColor = color;
    
    
    return view;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */





#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end