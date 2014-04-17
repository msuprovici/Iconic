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
@interface VSTableViewController ()

@property (strong, nonatomic) NSTimer *timer;



@end

@implementation VSTableViewController

@synthesize timer = _timer;

- (id)initWithCoder:(NSCoder *)aDecoder{
     self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = kTeamPlayersClass;
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}

//get the players team passed from the leagues view controller
-(void)initWithReceivedTeam:(PFObject *)aReceivedTeam
{
    self.receivedTeam = aReceivedTeam;
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //populate labels
    
    PFObject *homeTeam = [self.receivedTeam objectForKey:kHomeTeam];
//    NSLog(@"homeTeam: %@", homeTeam);
    PFObject *awayTeam = [self.receivedTeam objectForKey:kAwayTeam];
//    NSLog(@"awayTeam: %@", awayTeam);
    
    //my team name
    //self.myTeamName.text = [NSString stringWithFormat:@"%@",[homeTeam objectForKey:kTeams]];
    
    //my team score
    self.myTeamScore.text = [NSString stringWithFormat:@"%@",[homeTeam objectForKey:kScore]];
    
    //my team name abriviated
    self.myTeam.text = [NSString stringWithFormat:@"%@",[homeTeam objectForKey:kTeamsAbr]];
    
    //populate days of the week labels
    
    //get the daily score data from the days before, if any
    NSMutableArray * myTeamScores = [homeTeam objectForKey:kScoreWeek];
    
    //we add today's most uptodate data to the array
    [myTeamScores addObject:[homeTeam objectForKey:kScoreToday]];
    
    //we add values to ensure the array is never empty through index 6
    [myTeamScores addObjectsFromArray:@[@"-", @"-", @"-", @"-", @"-", @"-", @"-"]];
    
    //we add each day's score to the appropriate label
    self.myTeamMonday.text = [NSString stringWithFormat:@"%@",[myTeamScores objectAtIndex:0]];
    self.myTeamTuesday.text = [NSString stringWithFormat:@"%@",[myTeamScores objectAtIndex:1]];
    self.myTeamWednesday.text = [NSString stringWithFormat:@"%@",[myTeamScores objectAtIndex:2]];
    self.myTeamThursday.text = [NSString stringWithFormat:@"%@",[myTeamScores objectAtIndex:3]];
    self.myTeamFriday.text = [NSString stringWithFormat:@"%@",[myTeamScores objectAtIndex:4]];
    self.myTeamSaturday.text = [NSString stringWithFormat:@"%@",[myTeamScores objectAtIndex:5]];
    self.myTeamSunday.text = [NSString stringWithFormat:@"%@",[myTeamScores objectAtIndex:6]];
    
    

    
    
    //vs team score
//    //hardcoded untill matchups are done
//    
//    self.vsTeamScore.text = [NSString stringWithFormat:@"%@",[awayTeam objectForKey:kScore]];
//    
//    
//    //vs team name abriviated
//    //self.vsTeam.text = [NSString stringWithFormat:@"%@",[self.receivedTeam objectForKey:kTeamsAbr]];
//    self.vsTeam.text = @"BRU";
//    
//    //populate days of the week labels
//    
//    //get the daily score data from the days before, if any
//    //NSMutableArray * vsTeamScores = [self.receivedTeam objectForKey:kScoreWeek];
//    NSArray* vsTeamScores = @[@100, @120, @200, @5, @355, @43, @999, @1000];
//    //we add today's most uptodate data to the array
//    [myTeamScores addObject:[self.receivedTeam objectForKey:kScoreToday]];
//    
//    //we add values to ensure the array is never empty through index 6
//    [myTeamScores addObjectsFromArray:@[@"-", @"-", @"-", @"-", @"-", @"-", @"-"]];
    
        //my team score
    self.vsTeamScore.text = [NSString stringWithFormat:@"%@",[awayTeam objectForKey:kScore]];
    
    //my team name abriviated
    self.vsTeam.text = [NSString stringWithFormat:@"%@",[awayTeam objectForKey:kTeamsAbr]];
    
    //populate days of the week labels
    
    //get the daily score data from the days before, if any
    NSMutableArray * vsTeamScores = [awayTeam objectForKey:kScoreWeek];
    
    //we add today's most uptodate data to the array
    [vsTeamScores addObject:[awayTeam objectForKey:kScoreToday]];
    
    //we add values to ensure the array is never empty through index 6
    [vsTeamScores addObjectsFromArray:@[@"-", @"-", @"-", @"-", @"-", @"-", @"-"]];

    
    
    //we add each day's score to the appropriate label
    self.vsTeamMonday.text = [NSString stringWithFormat:@"%@",[vsTeamScores objectAtIndex:0]];
    self.vsTeamTuesday.text = [NSString stringWithFormat:@"%@",[vsTeamScores objectAtIndex:1]];
    self.vsTeamWednesday.text = [NSString stringWithFormat:@"%@",[vsTeamScores objectAtIndex:2]];
    self.vsTeamThursday.text = [NSString stringWithFormat:@"%@",[vsTeamScores objectAtIndex:3]];
    self.vsTeamFriday.text = [NSString stringWithFormat:@"%@",[vsTeamScores objectAtIndex:4]];
    self.vsTeamSaturday.text = [NSString stringWithFormat:@"%@",[vsTeamScores objectAtIndex:5]];
    self.vsTeamSunday.text = [NSString stringWithFormat:@"%@",[vsTeamScores objectAtIndex:6]];

    
   
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
    
    return [NSString stringWithFormat:@"%02dd : %02dh : %02dm : %02ds", days,hours,minute,second];
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
     
     
     PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:self.parseClassName];
     [queryHomeTeamMatchups whereKey:kTeam equalTo:[self.receivedTeam objectForKey:kHomeTeam]];
     
     
     PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:self.parseClassName];
     [queryAwayTeamMatchups whereKey:kTeam equalTo:[self.receivedTeam objectForKey:kAwayTeam]];
     
     //get both team objects (home & away)
     PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups,queryAwayTeamMatchups]];
     [query includeKey:kTeam];
     [query includeKey:kTeamate];
     
     
     //Query Team Class
     PFQuery *teamClass = [PFQuery queryWithClassName:kTeamTeamsClass];
     
     //Query Teamates Class (querying again to find the teams the player is currently on)
     PFQuery *playerClass = [PFQuery queryWithClassName:kTeamPlayersClass];
     teamClass.cachePolicy = kPFCachePolicyCacheThenNetwork;
     playerClass.cachePolicy = kPFCachePolicyCacheThenNetwork;
     
     [playerClass whereKey:kTeamate equalTo:[PFUser currentUser]];
     
     [teamClass whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:playerClass];
     
     //out of the teams we got in query, get the team that matches the player's team
     [query whereKey:kTeam matchesKey:@"objectId" inQuery:teamClass];
     
     
     
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