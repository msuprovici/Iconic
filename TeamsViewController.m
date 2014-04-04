//
//  TeamsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "TeamsViewController.h"
#import "TeamPlayersViewController.h"
#import "TeamCell.h"
#import <Parse/Parse.h>
#import "PNChart.h"
#import "Constants.h"

@interface TeamsViewController ()

@property NSMutableArray *leaguesArray;

@property (nonatomic, retain) NSMutableDictionary *teams;
//@property (nonatomic, retain) NSMutableDictionary *categories;

@end

@implementation TeamsViewController

@synthesize teams = _teams;
//@synthesize categories = _categories;


/*- (id)initWithStyle:(UITableViewStyle)style
 {
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization
 }
 return self;
 }*/

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   // [super dealloc];
}



- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        
        
        
        // Customize the table
        
        // The className to query on
        self.parseClassName = kTeamTeamsClass;
        
        
        // The key of the PFObject to display in the label of the default cell style
        
        self.textKey = kTeams;
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        //dictionaries for teams & categories
        self.teams = [NSMutableDictionary dictionary];
       // self.categories = [NSMutableDictionary dictionary];
        
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"JoinedTeam" object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"LeftTeam" object:nil];
        


    
            }
    
    
    return self;
}

//get the league passed from the leagues view controller
-(void)initWithLeague:(PFObject *)aLeague
{
    self.league = aLeague;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //self.leaguesArray = [[NSMutableArray alloc] init];
    
    //TeamsViewController.teamsViewControllerDelegate = self;
    
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"JoinedTeam" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"LeftTeam" object:nil];

}

//method for loading table cells with leagues
- (void)loadInitialData {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

//using sections, to keep track of which PFObjects belong to which section
//Since every categories is represented as a PFObject in self.objects, we are storing the index of their PFObject in sections
//sorting our objects into the sections dictionary

//- (void)objectsDidLoad:(NSError *)error {
//    [super objectsDidLoad:error];
//    
//    // This method is called every time objects are loaded from Parse via the PFQuery
//    
//    [self.teams removeAllObjects];
//    [self.categories removeAllObjects];
//    
//    NSInteger section = 0;
//    NSInteger rowIndex = 0;
//    for (PFObject *object in self.objects) {
//        NSString *Teams = [NSString stringWithFormat:@"%@",[object objectForKey:kLeagues]];
//        NSMutableArray *objectsInSection = [self.teams objectForKey:Teams];
//        if (!objectsInSection) {
//            objectsInSection = [NSMutableArray array];
//            
//            // this is the first time we see this Teams - increment the section index
//            //[self.categories setObject:Teams forKey:[NSNumber numberWithInt:section++]];
//        }
//        
//        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
//        [self.teams setObject:objectsInSection forKey:Teams];
//    }
//    
//    
//    
////    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
////    PFQuery *query = [PFQuery queryWithClassName:kTeamPlayersClass];
////    //[query whereKey:kTeamate equalTo:[PFUser currentUser]];
////    [query whereKey:kTeam equalTo:object];
////    
////    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
////        if (!error) {
////            
////            cell.accessoryType = UITableViewCellAccessoryCheckmark;
////            
////        }
////        else
////        {
////            [self.tableView reloadData];
////            
////            //[self.tableView reloadRowsAtIndexPaths:self.objects withRowAnimation:UITableViewRowAnimationNone];
////        }
////        
////    }];
//
//    
//    
//    [self.tableView reloadData];
//    
//}
//

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     //compare the league name to the league name recived from the previous controller
    PFObject * receivedLeagues = [self.league objectForKey:kLeagues];
    
    [query whereKey:kLeagues equalTo:receivedLeagues];
   
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // Order by Teams type
   // [query orderByAscending:@"categories"];
    return query;
}


// We will use the section indeces as keys to look up which categories is represented by a section.
//- (NSString *)categories:(NSInteger)section {
//    return [self.categories objectForKey:[NSNumber numberWithInt:section]];
//}




// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"teamsCell";
    
    TeamCell *cell = (TeamCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TeamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.teamName.text = [object objectForKey:self.textKey];
    
    //query the team players class to determine if the player is on a team
    //if the player is on a team show a checkmark accessory for the cell
    PFQuery *query = [PFQuery queryWithClassName:kTeamPlayersClass];
    [query whereKey:kTeamate equalTo:[PFUser currentUser]];
    [query whereKey:kTeam equalTo:object];
   // query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        TeamPlayersViewController *tappedCell = [[TeamPlayersViewController alloc]init];
        
        if (!error) {
            
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //flip off boolean for that cell
            tappedCell.addTeam = YES;
                }
        else if(error)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //flip off boolean here
            tappedCell.addTeam = NO;
        }
       
            }];
    
    
    
    
    return cell;
}

//Create custom header for teams view
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return HeaderHeight;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    sectionHeader.backgroundColor = HeaderColor;
//    sectionHeader.textAlignment = HeaderAlignment;
//    sectionHeader.font = HeaderFont;
//    sectionHeader.textColor = HeaderTextColor;
//    
//    
//   sectionHeader.text =[self categories:section];
//    
//    return sectionHeader;
//    
//}


// Get the array of indeces for that section. This lets us pick the correct PFObject from self.objects
//- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *Teams = [self categories:indexPath.section];
//    
//    NSArray *rowIndecesInSection = [self.teams objectForKey:Teams];
//    
//    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
//    return [self.objects objectAtIndex:[rowIndex intValue]];
//}


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


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return self.teams.allKeys.count;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)league
//{
//    
//    // Return the number of rows in the section.
//    //return 0;
//    
//    //return the # of teams in the array
//    
//    NSString *categoryType = [self categories:league];
//    NSArray *rowIndecesInSection = [self.teams objectForKey:categoryType];
//    return rowIndecesInSection.count;
//    
//    
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *categoryType = [self categories:section];
//    return categoryType;
//}


#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    
//    PFObject *selectedObject = [self objectAtIndexPath:indexPath];
//    
//    
//    
//    //create selection here
//    
//    //code de-selects cell after selection
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    //find the corresponding item scheduledMatchups
//    //    ScheduleGenerator *tappedItem = [self.scheduledMatchups objectAtIndex:indexPath.row];
//    //
//    //    //toggle the compeltion state of the tapped item
//    //    tappedItem.selected = !tappedItem.selected;
//    //
//    //tell the table view to reload the row whose data you just updated
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation

//pass the team to the teammates view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"teamates"]) {
        
        //Find the row the button was selected from
        //        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        //        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        NSIndexPath *hitIndex = [self.tableView indexPathForSelectedRow];
        
        PFObject *team = [self.objects objectAtIndex:hitIndex.row];
        
        [segue.destinationViewController initWithTeam:team];
        
        //[segue.destinationViewController initWithTeam:self.league];
        
    }
}


- (IBAction)unwindToTeams:(UIStoryboardSegue *)segue
{
//    TeamPlayersViewController *source = [segue sourceViewController];
//    TeamCell * cell = [[TeamCell alloc]init];
//    
//    NSIndexPath *hitIndex = [self.tableView indexPathForCell:cell];
//    
//    PFObject *team = source.team;
//   // cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    
//    
////    if (hitIndex == team)
////    {
////        cell.accessoryType = UITableViewCellAccessoryCheckmark;
////    }
////    else {
////        cell.accessoryType = UITableViewCellAccessoryNone;
////    }
//
    
    TeamPlayersViewController * vc = [segue sourceViewController];
    vc.delegate = self;
    
    [self loadObjects];
}


//attempt to use a NSNotification to update cell accessoryType - does not work.
//using NSNotification to refresh view controller
- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"JoinedTeam"])
    {
        NSDictionary* teamInfo = notification.userInfo;
       //PFObject *pushedteams = [[teamInfo objectForKey:@"team"] object];
        
         NSString *team = [[teamInfo objectForKey:@"team"] objectId];
        NSLog (@"Successfully received Joined Team notification! %@", team);
        
        
        TeamCell *cell = [[TeamCell alloc]init];

        NSIndexPath *hitIndex = [self.tableView indexPathForCell:cell];
       // NSInteger rowOfTheCell = [hitIndex row];
        
        NSString *teamCell = [[self.objects objectAtIndex:hitIndex.row]objectId];
        
       // PFObject *teams = [self.objects objectAtIndex:hitIndex.row];

       //comparing the objectId pushed in the NSNotificaiton to the objectId at indexpath
        if (team == teamCell ) {
            
            
            if (team) {
                
                //attempt to update the accessory - does not work
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                NSLog(@"Objects are equal");

            [self.tableView reloadData];
                
                }
            else
            {
                NSLog(@"Object not found");
            }

        }
        else
        {
            
             NSLog(@"Objects are NOT equal");
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
           
            
        }
//        }
    }
    else if ([[notification name] isEqualToString:@"LeftTeam"])
    {
        NSDictionary* teamInfo = notification.userInfo;
        // PFObject *team = [[teamInfo objectForKey:@"team"] object];
        
        NSString *team = [[teamInfo objectForKey:@"team"] objectId];
        NSLog (@"Successfully received Left Team notification! %@", team);
        
        
        
        TeamCell *cell = [[TeamCell alloc]init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.view setNeedsDisplay];
        
        
        
        //using a timer in case parse did not receive all the data
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(followUsersTimerFired:) userInfo:nil repeats:NO];
        
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
        
//        NSIndexPath *hitIndex = [self.tableView indexPathForCell:cell];
//        
//        NSString *teamCell = [[self.objects objectAtIndex:hitIndex.row]objectId];
//        
//        
//        
//        if (team == teamCell) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            
//        }
//        else
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            
//        }

    }
}

- (void)followUsersTimerFired:(NSTimer *)timer {
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}



//attempt to use a delegate to update cell accessoryType - does not work.
-(void)updateCells
{
    NSLog(@"This delegate works");
}

-(void)didSelectJoinTeam:(TeamPlayersViewController *)controller team:(NSObject *)team
{
    NSLog(@"This delegate works");
    
}


@end
