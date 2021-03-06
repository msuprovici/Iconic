//
//  LeaguesViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "LeaguesViewController.h"
#import <Parse/Parse.h>
#import "TeamsViewController.h"
#import "LeagueCell.h"

#import "Constants.h"
#import "PNChart.h"

@interface LeaguesViewController ()

@property NSMutableArray *leaguesArray;

@property (nonatomic, retain) NSMutableDictionary *leagues;
@property (nonatomic, retain) NSMutableDictionary *categories;



@end

@implementation LeaguesViewController

@synthesize leagues = _leagues;
@synthesize categories = _categories;


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
        
        //self.parseClassName = kTeamTeamsClass;

        self.parseClassName = kLeagueClass;
        //self.parseClassName = @"matchups";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"name";
       self.textKey = kLeagues;
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        //dictionaries for matchups & round
        self.leagues = [NSMutableDictionary dictionary];
        self.categories = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     
    self.leaguesArray = [[NSMutableArray alloc] init];
    
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//Since every round is represented as a PFObject in self.objects, we are storing the index of their PFObject in sections
//sorting our objects into the sections dictionary

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    [self.leagues removeAllObjects];
    [self.categories removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *league = [NSString stringWithFormat:@"%@",[object objectForKey:kLeagueCategories]];
        NSMutableArray *objectsInSection = [self.leagues objectForKey:league];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this leagues section - increment the section index
            [self.categories setObject:league forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.leagues setObject:objectsInSection forKey:league];
        
        
//        NSInteger count = [objectsInSection count];
//        for (NSInteger index = (count - 1); index >= 0; index--) {
//            objectsInSection *p = objectsInSection[index];
//            if ([objectsInSection isEqualToString:@"NFL"]) {
//                [objectsInSection removeObjectAtIndex:index];
//            }
//        }
//        
//        
        
        
//        
//        PFObject *leagueName = [self.leagues objectForKey:kLeagues];
//        
//        if (object == leagueName) // Are they the same?
//        {
//            [self.leagues setObject:objectsInSection forKey:league];
//        }
        
//        // Now we check if we already had this wall post
//        
//        for (PFObject *leagueNames in self.leagues) // Loop through all the wall posts we have
//        {
//            PFObject * myLeagueName = [leagueNames objectForKey:kLeagues];
//            
//            if (object == leagueNames && leagueName == myLeagueName) // Are they the same?
//            {
//                [self.leagues setObject:objectsInSection forKey:league];
//            }
//        }
        
           }
    
    [self.tableView reloadData];
}



// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
   PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
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
   // [query orderByAscending:@"round"];
    return query;
}


// We will use the section indeces as keys to look up which category is represented by a section.
- (NSString *)categories:(NSInteger)section {
    return [self.categories objectForKey:[NSNumber numberWithInt:section]];
}

// We will use the section indeces as keys to look up which category is represented by a section.
- (NSString *)theLeagues:(NSInteger)section {
    return [self.leagues objectForKey:[NSNumber numberWithInt:section]];
}


 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"leaguesCell";
 
 LeagueCell *cell = (LeagueCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[LeagueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
     
//     //compare the league name column
//     NSString *leagueName = [object objectForKey:kLeagues];
//     PFObject *leagueCategory = [object objectForKey:kLeagueCategories];
//     
//     NSString *receivedLeagueName = [self.objects objectAtIndex:cell.tag];;
//     
//     
//     if (leagueName == receivedLeagueName) {
         cell.leagueName.text =[object objectForKey:self.textKey];
     
     
 // Configure the cell
         //cell.leagueName.text =[object objectForKey:self.textKey];
         //cell.textLabel.text = [object objectForKey:self.textKey];
         //cell.textLabel.font = [UIFont fontWithName:@"DIN Alternate" size:17];
         //cell.imageView.file = [object objectForKey:self.imageKey];
         
     
 //cell.textLabel.text = [object objectForKey:self.textKey];
 //cell.textLabel.font = [UIFont fontWithName:@"DIN Alternate" size:17];
 //cell.imageView.file = [object objectForKey:self.imageKey];
 
 return cell;
 }


//create a header section for Leagues
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
    
    sectionHeader.text =[self categories:section];

    return sectionHeader;
    
}




// Get the array of indeces for that section. This lets us pick the correct PFObject from self.objects
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *leagues = [self categories:indexPath.section];
   
    NSArray *rowIndecesInSection = [self.leagues objectForKey:leagues];
    
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
    return self.leagues.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)league
{

    // Return the number of rows in the section.
    //return 0;
    
    //return the # of leagues in the array
    
    NSString *leagueType = [self categories:league];
    NSArray *rowIndecesInSection = [self.leagues objectForKey:leagueType];
    
   //ensures that we don't have duplicates of the same team in the same category
    
    if (!leagueType) {
        return 1;
    }
    else
    {
    return rowIndecesInSection.count;
    }

}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *roundType = [self categories:section];
//    
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
////create selection here
//
////code de-selects cell after selection
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
////find the corresponding item scheduledMatchups
////    ScheduleGenerator *tappedItem = [self.scheduledMatchups objectAtIndex:indexPath.row];
////
////    //toggle the compeltion state of the tapped item
////    tappedItem.selected = !tappedItem.selected;
////
//    //tell the table view to reload the row whose data you just updated
//  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - Navigation

//pass the league to the leagues view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"league"]) {
        
        NSIndexPath *hitIndex = [self.tableView indexPathForSelectedRow];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:hitIndex.row inSection:hitIndex.section];
        
        
         //to pass the correct object we need to use the objectAtIndexPath method
        [segue.destinationViewController initWithLeague:[self objectAtIndexPath:newIndexPath]];
        
    }
}







@end
