//
//  ScheduleViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 11/13/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleGenerator.h"
#import <Parse/Parse.h>

@interface ScheduleViewController ()

@property NSMutableArray *scheduledMatchups;

@end

@implementation ScheduleViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

//method for loading table cells with scheduled matachups
- (void)loadInitialData {
    
     ScheduleGenerator *item1 = [[ScheduleGenerator alloc] init];
    //This approach takes place on the main thread
    //Warning: A long-running Parse operation is being executed on the main thread.
    
    item1.itemName = [NSString stringWithFormat: @"%@", [PFCloud callFunction:@"schedule" withParameters:@{@"NumberOfTeams":@4}]];
    [self.scheduledMatchups addObject:item1];
    
    //This approach takes place in the background but I can not yet display it in a cell
    //Get data schedule data from parse based on Number of Teams input bellow
    [PFCloud callFunctionInBackground:@"schedule"
                       withParameters:@{@"NumberOfTeams":@4}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // show matchups
                                        
                                        /*ScheduleGenerator *item1 = [[ScheduleGenerator alloc] init];
                                        item1.itemName = [NSString stringWithFormat: @"%@", result
                                        [self.scheduledMatchups addObject:item1];*/

                                        NSLog(@"%@", result);
                                    }
                                }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    
    //return the # of matchups in the array
    return [self.scheduledMatchups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Matchup";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    ScheduleGenerator *scheduleMatchup = [self.scheduledMatchups objectAtIndex:indexPath.row];
    cell.textLabel.text = scheduleMatchup.itemName;
    
    if (scheduleMatchup.selected) {
        
    //TO DO: perfom segue to VS (matchup detail) view - MS
   //the checkmark bellow is just a test and will be taken out later
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create selection here
    
    //code de-selects cell after selection
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //find the corresponding item scheduledMatchups
    ScheduleGenerator *tappedItem = [self.scheduledMatchups objectAtIndex:indexPath.row];
    
    //toggle the compeltion state of the tapped item
    tappedItem.selected = !tappedItem.selected;
    
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

@end
