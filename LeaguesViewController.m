//
//  LeaguesViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Iconic. All rights reserved.
//

#import "LeaguesViewController.h"
#import <Parse/Parse.h>
#import "TeamsViewController.h"
#import "LeagueCell.h"

#import "Constants.h"
#import "PNChart.h"
#import "AppDelegate.h"
#import "Amplitude.h"

@interface LeaguesViewController ()

@property NSMutableArray *leaguesArray;
@property NSArray *myTeamObjectsArray;
@property NSMutableArray *myTeamNamesArray;

@property (nonatomic, retain) NSMutableDictionary *leagues;
@property (nonatomic, retain) NSMutableDictionary *categories;
@property (nonatomic, assign) BOOL receivedJoinLeaveNotification;
@property (nonatomic, assign) BOOL receivedAddedTeamNotification;
@property PFObject *leagueLeft;
@property PFObject *leagueJoined;
@property (nonatomic, retain) NSMutableArray *myLeagues;


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
        self.objectsPerPage = 50;
        
        //dictionaries for matchups & round
        self.leagues = [NSMutableDictionary dictionary];
        self.categories = [NSMutableDictionary dictionary];
    }
    
    
    //get the leagues the user is in
    PFUser * user = [PFUser currentUser];
    
    PFQuery *teamQuery = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    PFQuery *teamPlayersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
    [teamPlayersClass whereKey:kUserObjectIdString equalTo:user.objectId];
    [teamQuery whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:teamPlayersClass];
    [teamQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if(!error)
        {
            self.myTeamNamesArray = [[NSMutableArray alloc]init];
            self.myTeamObjectsArray = objects;
            for (int i = 0; i < objects.count; i++) {
                PFObject *myTeam = objects[i];
                NSString *myTeamName = [myTeam objectForKey:@"league"];
                
                [self.myTeamNamesArray addObject:myTeamName];
            }
        }
    }];

    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.leaguesArray = [[NSMutableArray alloc] init];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"JoinedTeam" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"LeftTeam" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJoinOrLeaveTeam:) name:@"LeagueFull" object:nil];

    UIColor *color = PNCloudWhite;
    self.view.backgroundColor = color;
    
    self.receivedAddedTeamNotification = NO;
    
//    [self.createLeague setTitle:@"+"];
//    
//    [self.createLeague  setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0]} forState:UIControlStateNormal];
    
    
    ///since we can't make the button invisible we make it clear
    [self.createLeague  setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0], NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateDisabled];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES ];
    
    
    // If we received joined/leave team notification update team charts
    if (self.receivedJoinLeaveNotification == YES) {
        
        
        //        [self.tableView reloadData];
        
//         NSLog(@"reload view was called");
        
        [self.tableView reloadData];
        [self.view setNeedsDisplay];
        self.receivedJoinLeaveNotification = NO;
    }
    
    if(self.receivedAddedTeamNotification == YES)
    {
        [self loadObjects];
    }
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
    
    NSInteger section = 1;
    NSInteger rowIndex = 0;
    
    
    
    
    
    
    //1st add my leagues to the legues dictionary
    
    if(self.myTeamNamesArray.count > 0)
    {
        NSString * myLeagues = @"My Leagues";
        
        [self.categories setObject:myLeagues forKey:[NSNumber numberWithInt:0]];
        [self.leagues setObject:self.myTeamNamesArray forKey:myLeagues];
    }
    
    
    for (PFObject *object in self.objects) {
        NSString *leagueCategory = [NSString stringWithFormat:@"%@",[object objectForKey:kLeagueCategories]];
        
//        NSLog(@"leagueCategory %@", leagueCategory);
        
        NSMutableArray *objectsInSection = [self.leagues objectForKey:leagueCategory];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
//            NSLog(@"objectsInSection %@", objectsInSection);
            
            // this is the first time we see this leagues section - increment the section index
            [self.categories setObject:leagueCategory forKey:[NSNumber numberWithInt:section++]];
            
                  }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.leagues setObject:objectsInSection forKey:leagueCategory];
        


        
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
    [query orderByAscending:@"categories"];
    
    
    
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
 
     
    if(self.myTeamNamesArray.count > 0) {
        
        //show names of my leagues in the 1st section if I'm on a team in this league
        if(indexPath.section == 0)
        {
            cell.leagueName.text =[self.myTeamNamesArray objectAtIndex:indexPath.row];
        }
        else
        {
            
            cell.leagueName.text =[object objectForKey:self.textKey];
            cell.leagueLevel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"Level"]];
        }
        
     }
     else
     {
         cell.leagueName.text =[object objectForKey:self.textKey];
         cell.leagueLevel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"Level"]];
     }
     
     
 
     
     
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     

     int playerXP = [[defaults objectForKey:@"myXP"]intValue];
     
//     NSNumber *myXP = [NSNumber numberWithInt:playerXP];
//     NSLog(@"playerXP %@", [defaults objectForKey:@"myXP"]);

    
     if ([defaults objectForKey:@"myXP"] < [object objectForKey:@"Level"]) {
         [cell.leagueLocked setHidden:NO];
         cell.leagueLocked.text =[NSString stringWithFormat:@"XP: %@", [object objectForKey:@"Level"]];
     }
     else
     {
         [cell.leagueLocked setHidden:YES];
     }
     
     
     
     
     
     
     //grey out cell if the player's XP is not high enough to unlock the other leagues
     
     int leagueLevel = [cell.leagueLevel.text intValue];
//     NSLog(@"leagueLevel %d", leagueLevel);
//     NSLog(@"playerXP %d", playerXP);
     if(playerXP >= leagueLevel)
     {
         [cell.leagueLocked setHidden:YES];
         [cell.leagueLevel setHidden:YES];
         [cell.unlocksAtLevelTitle setHidden:YES];
         //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
         cell.userInteractionEnabled = YES;
     }
     else{
         [cell.leagueLocked setHidden:NO];
         [cell.leagueLevel setHidden:NO];
         [cell.unlocksAtLevelTitle setHidden:NO];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.userInteractionEnabled = NO;
     }


 
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



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 65;
}



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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    [Amplitude logEvent:@"Leagues: League selected"];
    
}


//if the player's xp is not high enough cell should not be selected
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // rows in section 0 should not be selectable
//    if ( indexPath.section == 0 ) return nil;
    
    // first 3 rows in any section should not be selectable
//    if ( indexPath.row <= 1 ) return nil;
    
    // By default, allow row to be selected
    return indexPath;
}


#pragma mark - Receive NSNotification

//using NSNotification to refresh view controller
- (void) receiveJoinOrLeaveTeam:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"JoinedTeam"])
    {
        NSDictionary* objectFromNotificaiton = notification.userInfo;
        
//        NSLog(@"%@ notification object", [NSString stringWithFormat:@"%@",[objectFromNotificaiton objectForKey:@"team"]]);
        
        self.leagueJoined = [objectFromNotificaiton objectForKey:@"team"];
        self.leagueLeft = nil;
        
        self.receivedJoinLeaveNotification = YES;
        
        
        [self.tableView setNeedsDisplay];
//              NSLog (@"Successfully received notification!");
    }
    
    else if ([[notification name] isEqualToString:@"LeftTeam"])
    {
        
        NSDictionary* objectFromNotificaiton = notification.userInfo;
        
//        NSLog(@"%@ notification object", [NSString stringWithFormat:@"%@",[objectFromNotificaiton objectForKey:@"team"]]);
        
        self.leagueLeft = [objectFromNotificaiton objectForKey:@"team"];
        self.leagueJoined = nil;
        self.receivedJoinLeaveNotification = YES;
        
        [self.tableView setNeedsDisplay];
//                  NSLog (@"Successfully received notification!");
    }
    
    if([[notification name] isEqualToString:@"LeagueFull"])
    {
        
        
        self.receivedAddedTeamNotification = YES;
        
        
        [self.tableView setNeedsDisplay];
        //        NSLog (@"Successfully received notification!");
    }

    
}




#pragma mark - Navigation

//pass the league to the leagues view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"league"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        NSIndexPath *hitIndex = [self.tableView indexPathForSelectedRow];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:hitIndex.row inSection:hitIndex.section];
        
        if(self.myTeamNamesArray.count > 0)
        {
            //use my team's objects if the object is in my leagues section
            if (hitIndex.section == 0) {
            [segue.destinationViewController initWithLeague:[self.myTeamObjectsArray objectAtIndex: newIndexPath.row]];
            }
            
            //else use pfobject from query in section
            {
             //to pass the correct object we need to use the objectAtIndexPath method
                [segue.destinationViewController initWithLeague:[self objectAtIndexPath:newIndexPath]];
                
            }
        }
        else
        {
            [segue.destinationViewController initWithLeague:[self objectAtIndexPath:newIndexPath]];
        }
        
        
        
    }
    

    
    if ([segue.identifier isEqualToString:@"addleague"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        [Amplitude logEvent:@"Leagues: Add league pressed"];
        
    }
}

- (IBAction)unwindToLeagues:(UIStoryboardSegue *)segue
{
    [self loadObjects];
}






@end
