//
//  TeamsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Iconic. All rights reserved.
//

#import "TeamsViewController.h"
#import "TeamPlayersViewController.h"
#import "CreateTeamViewController.h"
#import "TeamCell.h"
#import <Parse/Parse.h>
#import "PNChart.h"
#import "Constants.h"
#import "Team.h"
#import "AppDelegate.h"
#import "Amplitude.h"

@interface TeamsViewController ()

@property NSMutableArray *leaguesArray;

@property (nonatomic, assign) BOOL receivedJoinLeaveNotification;

@property (nonatomic, assign) BOOL receivedAddedTeamNotification;

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
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"JoinedTeam" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"LeftTeam" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"LeagueFull" object:nil];
        


    
            }
    
    
    return self;
}

//get the league passed from the leagues view controller

- (IBAction)createTeamPressed:(id)sender {
    
    [Amplitude logEvent:@"Teams: Add team pressed"];
    
    int teamsInLeague = [[self.league objectForKey:@"numberOfTeams"]intValue];
    
    int teamsRetrieved = [[self.league objectForKey:@"totalNumberOfTeams"]intValue];
    
    if (teamsInLeague == teamsRetrieved) {
        NSString *maximumTeams = [NSString stringWithFormat:@"%d team maximum for this league",teamsInLeague];
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"League is full"
                                              message:maximumTeams
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       //                                           NSLog(@"OK action");
                                       
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

}

-(void)initWithLeague:(PFObject *)aLeague
{
    self.league = aLeague;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.receivedJoinLeaveNotification = NO;
    
    self.receivedAddedTeamNotification = NO;
    //self.leaguesArray = [[NSMutableArray alloc] init];
    
    //TeamsViewController.teamsViewControllerDelegate = self;
    
//    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"JoinedTeam" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"LeftTeam" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"LeagueFull" object:nil];

    UIColor *color = PNCloudWhite;
    self.view.backgroundColor = color;
    
    //set the title of the view controller to the selected League Name
    self.title = [NSString stringWithFormat:@"%@",[self.league objectForKey:kLeagues]];
    
    
    
//    //set up create team button
//    
//    [self.createTeam setTitle:@"+"];
//    
//    [self.createTeam  setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]} forState:UIControlStateNormal];
//    
//     //since we can't hide the button we disable it and make it clear
//     [self.createTeam  setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0], NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateDisabled];
    
    //if league is full disable create button
    int teamsInLeague = [[self.league objectForKey:@"numberOfTeams"]intValue];
    
    int teamsRetrieved = [[self.league objectForKey:@"totalNumberOfTeams"]intValue];
    
    
   
    
    
    int teamsLeft = teamsInLeague - teamsRetrieved;
    
    if (teamsLeft == 1)
    {
        self.teamsNeeded.text =[NSString stringWithFormat:@"%d more team needed to begin season", teamsLeft];
    }
    else
    {
        self.teamsNeeded.text =[NSString stringWithFormat:@"%d more teams needed to start season", teamsLeft];
    }

    
    
    
    if (teamsInLeague == teamsRetrieved) {
        self.createTeam.enabled = NO;
        self.scheduleButton.hidden = NO;
        self.teamsNeeded.hidden = YES;
       
        
    }
    else
    {
        self.createTeam.enabled = YES;
        self.scheduleButton.hidden = YES;
        
       
    }

    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES ];
    
//     [self loadInitialData];
//    [self.tableView reloadData];
    
    // If we received joined/leave team notification update team charts
    if (self.receivedJoinLeaveNotification == YES) {
        

//        [self.tableView reloadData];
        
        [self.tableView reloadData];
        
        [self loadObjects];
        
        self.receivedJoinLeaveNotification = NO;
    }
    
  
    //if league is full disable create button
    if(self.receivedAddedTeamNotification == YES)
        
    {
        
        self.createTeam.enabled = NO;
        self.scheduleButton.hidden = NO;
        self.teamsNeeded.hidden = YES;
    }
    
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
   
    
    // Set a placeholder image first
    cell.teamLogo.image = [UIImage imageNamed:@"team_place_holder.png"];
    cell.teamLogo.file = (PFFile *)object[@"teamAvatar"];
    [cell.teamLogo loadInBackground];
   
//    PFFile *imageFile = [object objectForKey:@"teamAvatar"];
//    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        // Now that the data is fetched, update the cell's image property.
//        cell.teamLogo.image = [UIImage imageWithData:data];
//    }];
    //turn photo to circle
    CALayer *imageLayer = cell.teamLogo.layer;
    [imageLayer setCornerRadius:cell.teamLogo.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];

   
    //add team record
    NSString *teamRecord = [NSString stringWithFormat:@"%@ - %@",[object objectForKey:@"wins"],[object objectForKey:@"losses"]];
    
    int numberOfTeamsInLeague = [[object objectForKey:@"numberOfTeamsInLeague"]intValue];
    
    
    //only show team record if the league contains more then two teams
    if(numberOfTeamsInLeague > 2)
    {
    cell.teamRecord.text = teamRecord;
    }
    else
    {
        cell.teamRecord.text = @"";
    }
    
    //set check mark if the player is on a team
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    
    NSString *currentLeague = [NSString stringWithFormat:@"%@",[self.league objectForKey:kLeagues]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"onteam = YES AND league = %@", currentLeague];
    [request setPredicate:pred];
    NSError *error;
    
        NSArray *fetchedTeams = [context executeFetchRequest:request error:&error];
        NSString *myTeamAtIndex = [NSString stringWithFormat:@"%@",[object objectForKey:kTeams]];
//    NSLog(@"myTeamAtIndex %@", [NSString stringWithFormat:@"%@",myTeamAtIndex]);
    
        NSString *myTeamName;
    
        for (NSManagedObject *teamNames in fetchedTeams) {
        
            myTeamName = [NSString stringWithFormat:@"%@",[teamNames valueForKeyPath:@"name"]];
       //        NSLog(@"myTeamName %@", [NSString stringWithFormat:@"%@",myTeamName]);
        
        }
    
            if ([myTeamName isEqualToString: myTeamAtIndex]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

    
    
    
    
    return cell;
}

////Create custom header for teams view
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    
//    //if league is not full show header
//    int teamsInLeague = [[self.league objectForKey:@"numberOfTeams"]intValue];
//    
//    int teamsRetrieved = [[self.league objectForKey:@"totalNumberOfTeams"]intValue];
//
//    
//    if (teamsRetrieved < teamsInLeague) {
//    return HeaderHeight;
//    }
//    else
//        return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    sectionHeader.backgroundColor = HeaderColor;
//    sectionHeader.textAlignment = HeaderAlignment;
//    sectionHeader.font = HeaderFont;
//    sectionHeader.textColor = HeaderTextColor;
//    
//    int teamsInLeague = [[self.league objectForKey:@"numberOfTeams"]intValue];
//    
//    int teamsRetrieved = [[self.league objectForKey:@"totalNumberOfTeams"]intValue];
//    
//    
//    int teamsLeft = teamsInLeague - teamsRetrieved;
//    
//    if (teamsLeft == 1)
//    {
//        sectionHeader.text =[NSString stringWithFormat:@"%d more team required to begin season", teamsLeft];
//    }
//    else
//    {
//        sectionHeader.text =[NSString stringWithFormat:@"%d more teams required to start season", teamsLeft];
//    }
//    
//   
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 65;
}

//dirty way to hide all other cells that do not contain data
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UIColor *color = PNCloudWhite;

    view.backgroundColor = color;
    
    return view;
}

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
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
//    [Amplitude logEvent:@"Teams: Team selected"];
    
}

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
        
        [Amplitude logEvent:@"Teams: Team selected"];
        
    }
    
    
    
    if ([segue.identifier isEqualToString:@"createTeam"]) {
        
        
        [segue.destinationViewController initWithLeague:self.league];
        
        [Amplitude logEvent:@"Teams: create team selected"];
        
        
    }
    
    if ([segue.identifier isEqualToString:@"schedule"]) {
        
        [Amplitude logEvent:@"Schedule pressed"];
        [segue.destinationViewController initWithLeague:self.league];
        
        [Amplitude logEvent:@"Teams: league selected"];
        
        
    }


    
}

- (IBAction)unwindToTeams:(UIStoryboardSegue *)segue
{
    [self loadObjects];
}


//- (IBAction)unwindToTeams:(UIStoryboardSegue *)segue
//{
////    TeamPlayersViewController *source = [segue sourceViewController];
////    TeamCell * cell = [[TeamCell alloc]init];
////    
////    NSIndexPath *hitIndex = [self.tableView indexPathForCell:cell];
////    
////    PFObject *team = source.team;
////   // cell.accessoryType = UITableViewCellAccessoryCheckmark;
////    
////    
//////    if (hitIndex == team)
//////    {
//////        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//////    }
//////    else {
//////        cell.accessoryType = UITableViewCellAccessoryNone;
//////    }
////
//    
//    TeamPlayersViewController * vc = [segue sourceViewController];
//    vc.delegate = self;
//    
//    [self loadObjects];
//}

#pragma mark - Receive NSNotification

//using NSNotification to refresh view controller
- (void) receiveJoinOrLeaveTeam:(NSNotification *) notification
{
        if ([[notification name] isEqualToString:@"JoinedTeam"])
        {
            
            
            self.receivedJoinLeaveNotification = YES;
            
            
        [self.tableView setNeedsDisplay];
//        NSLog (@"Successfully received notification!");
        }
   
        else if ([[notification name] isEqualToString:@"LeftTeam"])
        {
            
            
            self.receivedJoinLeaveNotification = YES;
            
            [self.tableView setNeedsDisplay];
//            NSLog (@"Successfully received notification!");
        }
    
    
    //if league is full flip boolean and refresh in view did appear
    if([[notification name] isEqualToString:@"LeagueFull"])
    {
        
        
        self.receivedAddedTeamNotification = YES;
        
        
        [self.tableView setNeedsDisplay];
        //        NSLog (@"Successfully received notification!");
    }

    
}

- (void)followUsersTimerFired:(NSTimer *)timer {
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
}




#pragma mark Core Data
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


@end
