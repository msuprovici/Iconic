//
//  ScheduleViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 11/13/13.
//  Copyright (c) 2013 Iconic. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleGenerator.h"
#import <Parse/Parse.h>

#import "PNChart.h"
#import  "Constants.h"
@interface ScheduleViewController ()

@property NSMutableArray *scheduledMatchups;

@property (nonatomic, retain) NSMutableDictionary *matchups;
@property (nonatomic, retain) NSMutableDictionary *round;



@end

@implementation ScheduleViewController
@synthesize matchups = _matchups;
@synthesize round = _round;


/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/





- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        
        
        
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"TeamMatchups";
        //self.parseClassName = @"matchups";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"name";
        self.textKey = @"matchups";
        
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
        
        //dictionaries for matchups & round
        self.matchups = [NSMutableDictionary dictionary];
        self.round = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.scheduledMatchups = [[NSMutableArray alloc] init];
    
   [self loadInitialData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initWithLeague:(PFObject *)aLeague
{
    self.league = aLeague;
    
}


//method for loading table cells with scheduled matachups
- (void)loadInitialData {
    
    //[super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
  

    
     //ScheduleGenerator *item1 = [[ScheduleGenerator alloc] init];
    //This approach takes place on the main thread
    //Warning: A long-running Parse operation is being executed on the main thread.
    
//  item1.itemName = [NSString stringWithFormat: @"%@", [PFCloud callFunction:@"schedule" withParameters:@{@"NumberOfTeams":@4}]];
//    [self.scheduledMatchups addObject:item1];
//    
    //This approach takes place in the background but I can not yet display it in a cell
    //Get data schedule data from parse based on Number of Teams input bellow
//    [PFCloud callFunctionInBackground:@"tournament2"
//                       withParameters:@{@"NumberOfTeams":@"2"}
//                                block:^(NSString *result, NSError *error) {
//                                    if (!error) {
//                                        // show matchups
//                                        
//                                        /*ScheduleGenerator *item1 = [[ScheduleGenerator alloc] init];
//                                        item1.itemName = [NSString stringWithFormat: @"%@", result
//                                        [self.scheduledMatchups addObject:item1];*/
//                                        
//                                        
//                                        NSLog(@"%@", result);
//                                    }
//                                }];
    
    
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

//- (void)objectsWillLoad {
//    [super objectsWillLoad];
//    
//    // This method is called before a PFQuery is fired to get more objects
//    
//    ScheduleGenerator *item1 = [[ScheduleGenerator alloc] init];
//    //This approach takes place on the main thread
//    //Warning: A long-running Parse operation is being executed on the main thread.
//    
////    item1.itemName = [NSString stringWithFormat: @"%@", [PFCloud callFunction:@"schedule" withParameters:@{@"NumberOfTeams":@4}]];
////    [self.scheduledMatchups addObject:item1];
//    
//    /*  [PFCloud callFunctionInBackground:@"schedule"
//     withParameters:@{@"NumberOfTeams":@4}
//     block:^(NSString *result, NSError *error) {
//     if (!error) {
//     // show matchups
//     
//     NSLog(@"%@", result);
//     }
//     }];*/
//
//
//}


//using sections, to keep track of which PFObjects belong to which section
//Since every round is represented as a PFObject in self.objects, we are storing the index of their PFObject in sections
//sorting our objects into the sections dictionary

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery

    [self.matchups removeAllObjects];
    [self.round removeAllObjects];
  
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *teamMatchup = [NSString stringWithFormat:@"Week %@",[object objectForKey:@"currentRound"]];
        NSMutableArray *objectsInSection = [self.matchups objectForKey:teamMatchup];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this teamMatchup - increment the section index
            [self.round setObject:teamMatchup forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.matchups setObject:objectsInSection forKey:teamMatchup];
    }
    [self.tableView reloadData];
  
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:kHomeTeam];
    [query includeKey:kAwayTeam];
    
    [query whereKey:@"leaguename" equalTo:[self.league objectForKey:@"league"]];
    
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
    
    // Order by teamMatchup type
    [query orderByAscending:@"currentRound"];
    return query;
}


// We will use the section indeces as keys to look up which round is represented by a section.
- (NSString *)round:(NSInteger)section {
    return [self.round objectForKey:[NSNumber numberWithInt:section]];
}




 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"Matchup";
     
     
     ScheduleCell *cell = (ScheduleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[ScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     // Configure the cell
     cell.homeTeam.text = [[object objectForKey:@"hometeam"] objectForKey:@"teams"];
     cell.awayTeam.text = [[object objectForKey:@"awayteam"] objectForKey:@"teams"];
     //cell.teamMatchups.font = [UIFont fontWithName:@"DIN Alternate" size:17];
     // cell.imageView.file = [object objectForKey:self.imageKey];
     
     return cell;

 
     
// PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
// if (cell == nil) {
// cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
// }
// 
// // Configure the cell
// cell.textLabel.text = [object objectForKey:self.textKey];
// cell.textLabel.font = [UIFont fontWithName:@"DIN Alternate" size:17];
//// cell.imageView.file = [object objectForKey:self.imageKey];
// 
// return cell;
 }

//create custom section header for schedule view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sectionHeader.backgroundColor = HeaderColor;
    sectionHeader.textAlignment = HeaderAlignment;
    sectionHeader.font = HeaderFont;
    sectionHeader.textColor = HeaderTextColor;
    
    sectionHeader.text =[self round:section];
    
    return sectionHeader;
    
}


 // Get the array of indeces for that section. This lets us pick the correct PFObject from self.objects
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *teamMatchups = [self round:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.matchups objectForKey:teamMatchups];
    
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}


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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.matchups.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)matchup
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    
    //return the # of matchups in the array
    
    NSString *roundType = [self round:matchup];
    NSArray *rowIndecesInSection = [self.matchups objectForKey:roundType];
    return rowIndecesInSection.count;
 
    //return [self.scheduledMatchups count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *roundType = [self round:section];
//    return roundType;
//}

//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//   static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    if (indexPath.section == self.objects.count) {
//        
//        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
//        return cell;
//    }
//    
//
// //static NSString *CellIdentifier = @"Matchup";
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//        
//    // Configure the cell...
//    
////    ScheduleGenerator *scheduleMatchup = [self.scheduledMatchups objectAtIndex:indexPath.row];
////    cell.textLabel.text = scheduleMatchup.itemName;
////    
////    if (scheduleMatchup.selected) {
////        
////    //TO DO: perfom segue to VS (matchup detail) view - MS
////   //the checkmark bellow is just a test and will be taken out later
////        cell.accessoryType = UITableViewCellAccessoryCheckmark;
////    } else {
////        cell.accessoryType = UITableViewCellAccessoryNone;
////    }
//    
//    return cell;
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
//    //    //create selection here
////    
////    //code de-selects cell after selection
////    [tableView deselectRowAtIndexPath:indexPath animated:NO];
////    
////    //find the corresponding item scheduledMatchups
////    ScheduleGenerator *tappedItem = [self.scheduledMatchups objectAtIndex:indexPath.row];
////    
////    //toggle the compeltion state of the tapped item
////    tappedItem.selected = !tappedItem.selected;
////    
////    //tell the table view to reload the row whose data you just updated
////    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
