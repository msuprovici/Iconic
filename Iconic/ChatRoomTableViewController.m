//
//  ChatRoomTableViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 9/16/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "ChatRoomTableViewController.h"
#import "ChatRoomTableViewCell.h"
#import "Amplitude.h"


@interface ChatRoomTableViewController ()

@end

@implementation ChatRoomTableViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // Custom initialization
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Chat";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
//        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
    }
    return self;
}

//get the league passed from the leagues view controller
-(void)initWithChatTeam:(NSString *)aTeam
{
    self.team = aTeam;
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *dateTeamChatRoomVisited = [NSString stringWithFormat:@"%@ChatRoomDate",self.team];
    
    [defaults setObject:[NSDate date] forKey:dateTeamChatRoomVisited];
    [defaults synchronize];

   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //scroll up the table view all the way up if there are more then 5 messages on the screen
    if (self.objects.count > 5) {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height +50);
        [self.self.tableView setContentOffset:offset animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFTableViewController

 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
     [query includeKey:@"User"];
     [query whereKey:@"TeamName" equalTo:self.team];
 
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByAscending:@"createdAt"];
 
 return query;
 }



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"ChatRoomTableViewCell";
 
 ChatRoomTableViewCell *cell = (ChatRoomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[ChatRoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 // Configure the cell
 
     
     cell.message.text = [object objectForKey:@"Message"];
     cell.userName.text = [[object objectForKey:@"User"]objectForKey:@"username"];
     
     
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateStyle:NSDateFormatterShortStyle];
     [formatter setTimeStyle:NSDateFormatterShortStyle];
     [formatter setDoesRelativeDateFormatting:YES];
     
//     [formatter setDateFormat:@"yyyy"];
     
     //Set time zone conversions
     [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
     
     NSString *stringFromDate = [formatter stringFromDate:object.createdAt];
     cell.date.text = stringFromDate;
   

 
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


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85.0f;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 40.0f;
//}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
 */
 
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    return NO;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text length] != 0) {
        
        PFObject *comment = [PFObject objectWithClassName:@"Chat"];
        [comment setObject:[PFUser currentUser] forKey:@"User"];
        [comment setObject:[PFUser currentUser].username forKey:@"username"];
        [comment setObject:textField.text forKey:@"Message"];
        [comment setObject:self.team forKey:@"TeamName"];
        
        //save PushChannel
        //Parse push notification channels must not contain spaces
        NSRange whiteSpaceRange = [self.team rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        if (whiteSpaceRange.location != NSNotFound) {
            
            
            //            NSLog(@"Found whitespace");
            NSString *chanelNameNoSpaces = [self.team stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [comment setObject:chanelNameNoSpaces forKey:@"pushChannel"];
        }
        else
        {
            
            [comment setObject:self.team forKey:@"pushChannel"];
        }

        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //Refresh view
//                NSLog(@"Chat object saved");
                [self loadObjects];
                
                [Amplitude logEvent:@"Cgat View: Player Comment"];
                
                if (self.objects.count > 5) {
                    CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height +150);
                    [self.self.tableView setContentOffset:offset animated:YES];
                }

                } else {
                NSLog(@"Failed to save object: %@", error);
                }

        }];
    }
    else
    {
        [self loadObjects];
    }
    
    textField.text = nil;
    return YES;
}


@end
