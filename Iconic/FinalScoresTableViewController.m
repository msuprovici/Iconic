//
//  FinalScoresTableViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 7/14/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "FinalScoresTableViewController.h"
#import "FinalScoresTableViewCell.h"
#import "Constants.h"

@interface FinalScoresTableViewController ()



@end

@implementation FinalScoresTableViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];

    if (self) {
        
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"TeamName";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"teams";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //remove separatorlines in between rows
    self.tableView.separatorColor=[UIColor clearColor];
    
    
    //make navigation bar transparent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
 PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
      
     PFQuery *teamPlayersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
     [teamPlayersClass includeKey:@"playerpointer"];
     [teamPlayersClass includeKey:@"team"];
     
     [teamPlayersClass whereKey:@"playerpointer" equalTo:[PFUser currentUser]];

     
     [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:teamPlayersClass];
    
     
     
     //Query Team Classes, find the team matchups and save the team scores to memory
     PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
     [queryHomeTeamMatchups whereKey:@"hometeam" matchesQuery:query];

     
     
     PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
     [queryAwayTeamMatchups whereKey:kAwayTeam matchesQuery:query];


     PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups, queryAwayTeamMatchups]];
     
     [queryTeamMatchupsClass whereKey:@"currentRound" matchesKey:@"round" inQuery:query];

     
     [queryTeamMatchupsClass includeKey:kHomeTeam];
     [queryTeamMatchupsClass includeKey:kAwayTeam];
     
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByDescending:@"createdAt"];
 
 return queryTeamMatchupsClass;
 }



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"FinalScoresCell";
    
    FinalScoresTableViewCell *cell = (FinalScoresTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FinalScoresTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    //always show my teams on the left side of the cell (myTeamName & myTeamScore)
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    NSArray *myTeamsNames = [RetrievedTeams objectForKey:kArrayOfMyTeamsNames];

     for (int i = 0; i < myTeamsNames.count; i++) {
         
         
         PFObject * homeTeamObject = [object objectForKey:kHomeTeam];
         PFObject * awayTeamObject = [object objectForKey:kAwayTeam];
         
         NSString * homeTeamNameString = [homeTeamObject objectForKey:kTeams];
         NSString * awayTeamNameString = [awayTeamObject objectForKey:kTeams];
         
         NSString * homeTeamScoreString = [homeTeamObject objectForKey:kFinalScore];
         NSString * awayTeamScoreString = [awayTeamObject objectForKey:kFinalScore];

         
         //comparing the teamname string in memory to the *!kTeamMatchupClass!* class
         if([myTeamsNames[i] isEqualToString: [homeTeamObject objectForKey:kTeams]])
         {
             
             
             //use object properties in kTeamsTeam class
             cell.myTeamName.text = [NSString stringWithFormat:@"%@",homeTeamNameString];
             cell.myTeamScore.text = [NSString stringWithFormat:@"%@",homeTeamScoreString];
             
             
             cell.vsTeamName.text = [NSString stringWithFormat:@"%@",awayTeamNameString];
             cell.vsTeamScore.text = [NSString stringWithFormat:@"%@",awayTeamScoreString];
           
         }
         
         
         //now reverse the cell data
         if([myTeamsNames[i] isEqualToString: [awayTeamObject objectForKey:kTeams]])
         {
             
             cell.vsTeamName.text = [NSString stringWithFormat:@"%@",homeTeamNameString];
             cell.vsTeamScore.text = [NSString stringWithFormat:@"%@",homeTeamScoreString];
             
             
             cell.myTeamName.text = [NSString stringWithFormat:@"%@",awayTeamNameString];
             cell.myTeamScore.text = [NSString stringWithFormat:@"%@",awayTeamScoreString];
             
         }
     }
    
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
