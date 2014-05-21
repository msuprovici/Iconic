//
//  TeamPlayersViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "TeamPlayersViewController.h"
#import <Parse/Parse.h>
#import "PNChart.h"
#import "Constants.h"
#import "TeamPlayerCell.h"
#import "TeamCell.h"
#import "Team.h"
#import "CalculatePoints.h"
#import "SimpleHomeViewController.h"
#import "AppDelegate.h"


@interface TeamPlayersViewController ()

@property NSMutableArray *leaguesArray;

@property (nonatomic, retain) NSMutableDictionary *players;
//@property (nonatomic, retain) NSMutableDictionary *categories;
@property NSString * selectedTeamName;


@end

@implementation TeamPlayersViewController



@synthesize players = _players;
//@synthesize categories = _categories;

//@synthesize delegate;




- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        
        
        
        // Customize the table
        
        // The className to query on
        self.parseClassName = kTeamPlayersClass;
        
        
        // The key of the PFObject to display in the label of the default cell style
         //       self.textKey = @"players";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
      //  self.imageKey = @"photo";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        //dictionaries for players & categories
//        self.players = [NSMutableDictionary dictionary];
//        self.categories = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)initWithTeam:(PFObject *)aTeam
{
    self.team = aTeam;
    self.selectedTeamName = [NSString stringWithFormat:@"%@",[self.team objectForKey:kTeams]];
//    NSLog(@"self.selectedTeamName: %@", self.selectedTeamName);
}



- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
  
      
    [self.joinTeam setTitle:@"Join" forState:UIControlStateNormal];
    [self.joinTeam setTitle:@"Leave" forState:UIControlStateSelected];
    
    [self joinTeamButtonState];
    [self.tableView reloadData];
    
//    [self.joinTeam setEnabled:YES];
//    [self.joinTeam setSelected:YES];
  
    

    
    
   }

//-(void) viewWillAppear:(BOOL)animated
//{

//}

//-(void) viewDidAppear:(BOOL)animated
//{

//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

//using sections, to keep track of which PFObjects belong to which section
//Since every categories is represented as a PFObject in self.objects, we are storing the index of their PFObject in sections
//sorting our objects into the sections dictionary

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    
   
    
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
//    [self.players removeAllObjects];
//    [self.categories removeAllObjects];
//    
//    NSInteger section = 0;
//    NSInteger rowIndex = 0;
//    for (PFObject *object in self.objects) {
//        NSString *teamPlayers = [NSString stringWithFormat:@"%@",[object objectForKey:@"categories"]];
//        NSMutableArray *objectsInSection = [self.players objectForKey:teamPlayers];
//        if (!objectsInSection) {
//            objectsInSection = [NSMutableArray array];
//            
//            // this is the first time we see this teamMatchup - increment the section index
//            [self.categories setObject:teamPlayers forKey:[NSNumber numberWithInt:section++]];
//        }
//        
//        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
//        [self.players setObject:objectsInSection forKey:teamPlayers];
//    }
//    
//    [self.tableView reloadData];
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kTeam equalTo:self.team];
    
    [query includeKey:kTeamate];
    
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
    
    // Order by categories type
    [query orderByDescending:@"createdAt"];
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
    static NSString *CellIdentifier = @"teamatesCell";
    
    TeamPlayerCell *cell = (TeamPlayerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TeamPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    }
    
    // Configure the cell
    
    [cell setUser:[object objectForKey:kTeamate]];
    
   
    
    return cell;
}

//Create custom header for teams view
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return HeaderHeight;
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
//    sectionHeader.text =[self categories:section];
//        
//    return sectionHeader;
//    
//}



// Get the array of indeces for that section. This lets us pick the correct PFObject from self.objects
//- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *teamPlayers = [self categories:indexPath.section];
//    
//    NSArray *rowIndecesInSection = [self.players objectForKey:teamPlayers];
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
//    return self.players.allKeys.count;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)league
//{
//    
//    // Return the number of rows in the section.
//    //return 0;
//    
//    //return the # of players in the array
//    
//    NSString *categoryType = [self categories:league];
//    NSArray *rowIndecesInSection = [self.players objectForKey:categoryType];
//    return rowIndecesInSection.count;
//    
//    
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *categoryType = [self categories:section];
//    return categoryType;
//}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    //PFObject *selectedObject = [self objectAtIndexPath:indexPath];
    
    
    
    //create selection here
    
    //code de-selects cell after selection
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //find the corresponding item scheduledMatchups
    //    ScheduleGenerator *tappedItem = [self.scheduledMatchups objectAtIndex:indexPath.row];
    //
    //    //toggle the compeltion state of the tapped item
    //    tappedItem.selected = !tappedItem.selected;
    //
    //tell the table view to reload the row whose data you just updated
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

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


- (IBAction)joinTeam:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *teamFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Team"];
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    
    
    NSError *error;
    NSArray *storedTeamNames = [context executeFetchRequest:teamFetchRequest error:&error];
    
//    Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
    
    PFUser *loggedInUser = [PFUser objectWithClassName:self.parseClassName];
    
    if(self.joinTeam.selected == NO)
    {
        
        
        [self.joinTeam setSelected:YES];
        
        //find out if the team name that = the stored team and filp the onteam flag to yes
        for (int i = 0; i < [storedTeamNames count]; i++) {
            NSManagedObject *teamNames = storedTeamNames[i];
            
            NSString *teamNameAtIndex = [NSString stringWithFormat:@"%@",[teamNames valueForKeyPath:@"name"]];
            
//            NSLog(@"teamNames %@", [NSString stringWithFormat:@"%@",teamNameAtIndex]);
//            NSLog(@"teams in league %@", [NSString stringWithFormat:@"%@",[teamNames valueForKeyPath:@"league"]]);
            
            if([teamNameAtIndex isEqualToString:self.selectedTeamName])
            {
               
                
                NSManagedObjectContext * context = [appDelegate managedObjectContext];
                NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc]init];
                [request setEntity:entityDesc];
                
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)" , self.selectedTeamName];
                [request setPredicate:pred];
                
                //if the player joined the team set the team's boolean to yes
                
                NSError *error;
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                NSArray *fetchedTeamNames = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
                [request setSortDescriptors:fetchedTeamNames];
                
                Team *team = [[context executeFetchRequest:request error:&error] objectAtIndex:0];

                
//                    NSLog(@"teamNameJoinedAtIndex %@", team.name);
                
                team.onteam = [NSNumber numberWithBool:YES];
                [context save:&error];
                    
                    
            }
            
        }

        
        
        
        
        
       
        //save a pointer to the current logged in user
        [loggedInUser setObject:[PFUser currentUser] forKey:kTeamate];
        
        //convert the current user's object ID into a string and save to new colum so that we can do a comparrison querry later
        NSString * userPointerObject = [NSString stringWithFormat:@"%@",[PFUser currentUser].objectId];
        [loggedInUser setObject:userPointerObject forKey:kUserObjectIdString];
        
        
        //save a pointer to the team selected by the user
        [loggedInUser setObject:self.team forKey:kTeam];
        
        //convert the team's object ID into a string and save to new colum so that we can do a comparrison querry later
        NSString * teamPointerObject = [NSString stringWithFormat:@"%@",self.team.objectId];
        
        [loggedInUser setObject:teamPointerObject forKey:kTeamObjectIdString];
        
        
        [loggedInUser saveEventually:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
//                 [self.joinTeam setSelected:YES];
                
                [self loadObjects];
                CalculatePoints * calculatePoints = [[CalculatePoints alloc]init];
                [calculatePoints retrieveFromParse];
                
                NSUserDefaults *Teams = [NSUserDefaults standardUserDefaults];
                NSArray *homeTeamNames = [Teams objectForKey:kArrayOfHomeTeamScores];
//                NSLog(@"homeTeamNames.count: %lu", (unsigned long)homeTeamNames.count);
                
                //subscribe to the team's push notification chanel
                NSString *pushChanelName = [NSString stringWithFormat:@"%@", [self.team objectForKey:kTeams]];
                
//                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//                [currentInstallation addUniqueObject:@"Test" forKey:@"channels"];
//                [currentInstallation saveEventually];
                
//                [PFPush subscribeToChannelInBackground: pushChanelName block:^(BOOL succeeded, NSError *error) {
//                    
//                    if (!error) {
//                        //                                NSLog(@"unsubscribed to push chanel: %@", [self.team objectForKey:kTeams]);
//                    } else {
//                        //                                NSLog(@"Failed to unsubscribe to push chanel, Error: %@", error);
//                    }
//                    
//                }];

               
            }
        }];
        
        //subscribe to the team's push notificaiton channel
        NSString *pushChanelName = [NSString stringWithFormat:@"%@", [self.team objectForKey:kTeams]];
        [[PFInstallation currentInstallation] addUniqueObject:pushChanelName forKey:@"channels"];
        [[PFInstallation currentInstallation] saveInBackground];

        
        //send nsnotificaiton to view controllers so they can update
        NSMutableDictionary* teamInfo = [NSMutableDictionary dictionary];
        [teamInfo setObject:self.team forKey:@"team"];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"JoinedTeam" object:self userInfo:teamInfo];
    }
    
    
    
    
    
    
    
    
    else if (self.joinTeam.selected == YES)
    {
        
      

        [self.joinTeam setSelected:NO];
        //find out if the team name that = the stored team and filp the onteam flag to no
        for (int i = 0; i < [storedTeamNames count]; i++) {
            NSManagedObject *teamNames = storedTeamNames[i];
            
            
            NSString *teamNameAtIndex = [NSString stringWithFormat:@"%@",[teamNames valueForKeyPath:@"name"]];
            
//            NSLog(@"left team name %@", [NSString stringWithFormat:@"%@",teamNameAtIndex]);
//            NSLog(@"team left in league %@", [NSString stringWithFormat:@"%@",[teamNames valueForKeyPath:@"league"]]);
            
            
            if([teamNameAtIndex isEqualToString:self.selectedTeamName])
            {
                //
                NSManagedObjectContext * leftTeamContext = [appDelegate managedObjectContext];
                NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:leftTeamContext];
                NSFetchRequest *request = [[NSFetchRequest alloc]init];
                [request setEntity:entityDesc];
                
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)" , self.selectedTeamName];
                [request setPredicate:pred];
                
                //left team: switch the team's boolean to no
                NSError *error;
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                NSArray *fetchedTeamNames = [[NSArray alloc] initWithObjects:sortDescriptor, nil];//ensure that the selected team comes up  1st
                [request setSortDescriptors:fetchedTeamNames];
                
                
                Team *team = [[context executeFetchRequest:request error:&error] objectAtIndex:0];
                
//                NSLog(@"teamNameJoinedAtIndex %@", team.name);
                
                team.onteam = [NSNumber numberWithBool:NO];
                
                
                [context save:&error];


                

            }
            
            
        }

        
        
        
       //save team Parse
        
        PFQuery *query = [PFQuery queryWithClassName:kTeamPlayersClass];
        [query whereKey:kTeamate equalTo:[PFUser currentUser]];
        

        [query whereKey:kTeamObjectIdString equalTo:self.team.objectId];
         query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                
            if (!error) {
//                NSLog(@"number of teams: %lu", (unsigned long)objects.count);
                
                for (PFObject *object in objects)
                {
//                    NSLog(@"team object id: %@", object);
//                    NSLog(@"self.team: %@", self.team);
                    
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded)
                        {
                        
//                        [self.joinTeam setSelected:NO];
                        
                        [self loadObjects];
                        
                        CalculatePoints * calculatePoints = [[CalculatePoints alloc]init];
                        [calculatePoints retrieveFromParse];

                        }
                        else
                        {
                            
                        }
                    }];
                    
                   

                }
          
                
            }
                else
                {
                    
                }
                
                
                
                //unsubscribe to the team's push notification chanel
                
                NSString *pushChanelName = [NSString stringWithFormat:@"%@", [self.team objectForKey:kTeams]];
                [[PFInstallation currentInstallation] removeObject:pushChanelName forKey:@"channels"];
                [[PFInstallation currentInstallation] saveInBackground];
                
                
   
                
            //send nsnotificaiton to view controllers so they can update
             NSMutableDictionary* teamInfo = [NSMutableDictionary dictionary];
            [teamInfo setObject:self.team forKey:@"team"];
            
            NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"LeftTeam" object:self userInfo:teamInfo];
            
            }];
        
        
    }
    

    
}



-(void)joinTeamButtonState
{
    
    //find the league the selected team bellongs to
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
   
    
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)" , self.selectedTeamName];
    [request setPredicate:pred];
    
    
    
    NSError *error;
    NSArray *fetchedTeamNames = [context executeFetchRequest:request error:&error];
    
//    NSLog(@"# of fetchedTeamNames %lu", (unsigned long)fetchedTeamNames.count);
//    NSLog(@"team %@", team);
//    NSLog( team.onteam ? @"Yes" : @"No");
    NSString *leagueOfSelectedTeam;
    
    
    //find out the league the team that was selected belongs to
    for (NSObject *savedTeam in fetchedTeamNames) {
        leagueOfSelectedTeam = [NSString stringWithFormat:@"%@",[savedTeam valueForKeyPath:@"league"]];
    }
    
    
//    NSLog(@"selected league %@", leagueOfSelectedTeam);
    
    //find out if the player is on a team in leagueOfSelectedTeam

    NSFetchRequest *isPlayerOnTeamInLeague = [[NSFetchRequest alloc]init];
    [isPlayerOnTeamInLeague setEntity:entityDesc];
    
    
    //determine if the player is on a team in this league
    NSPredicate *inLeague = [NSPredicate predicateWithFormat:@"(league = %@)  AND (onteam = %@)", leagueOfSelectedTeam,[NSNumber numberWithBool:YES] ];

    
//     NSLog(@"inLeague %@", inLeague);
    
    [isPlayerOnTeamInLeague setPredicate:inLeague];
    
    
    
    NSArray *playerTeamsInLeague = [context executeFetchRequest:isPlayerOnTeamInLeague error:&error];
    
//    NSLog(@"selected league count %lu", (unsigned long)playerTeamsInLeague.count);
    

    //if the player is not on a team in this league
    if (playerTeamsInLeague.count == 0) {
        [self.joinTeam setEnabled:YES];
        [self.joinTeam setSelected:NO];
    }
    
    else
    {
        
    
        for (int i = 0; i < playerTeamsInLeague.count; i++) {
        
            //find the team the player is on in the league
        
            NSPredicate *playerOnTeam = [NSPredicate predicateWithFormat:@"(onteam = %@)", [NSNumber numberWithBool:YES]];
//            NSLog(@"playerOnTeam %@", playerOnTeam);
        
            
            NSArray *playerTeams = [playerTeamsInLeague filteredArrayUsingPredicate:playerOnTeam];
//            NSLog(@"playerTeams %@", playerTeams);
        
            NSString *playersTeamName;
            
            for (NSObject *playerTeam in playerTeams) {
                playersTeamName = [NSString stringWithFormat:@"%@",[playerTeam valueForKeyPath:@"name"]];
//                NSLog(@"playersTeamName %@", playersTeamName);
            }
            
            
            
            //if the players team is the slected team that enable leave team button state
            if ([playersTeamName isEqualToString: self.selectedTeamName]) {
                
                [self.joinTeam setEnabled:YES];
                [self.joinTeam setSelected:YES];
            }
            else if(playerTeams == 0)
            {
                [self.joinTeam setEnabled:YES];
                [self.joinTeam setSelected:NO];
            }
            
            //if the player is on a different team in this league team disable the button join team button
            else
            {
                [self.joinTeam setEnabled:NO];
                [self.joinTeam setSelected:NO];
            }
        
            

        
        }
    
    
    }
}

#pragma mark Core Data


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}




@end
