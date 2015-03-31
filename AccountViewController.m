//
//  AccountViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/31/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "AccountViewController.h"
#import "Constants.h"
#import "AccountMyTeamCell.h"
#import "TeamPlayersViewController.h"
#import <Parse/Parse.h>
#import "PNColor.h"
@interface AccountViewController ()

@end

@implementation AccountViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        // Custom the table
        
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
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the user's data
//    PFUser * user = [PFUser currentUser];
    
    
    PFObject *user = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"objectId" equalTo:user.objectId];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    
    
    

    self.myUserName.text = [NSString stringWithFormat:@"%@", [object objectForKey:kUserDisplayNameKey]];
     self.navigationItem.title = @"Account";
    
    self.myAvgSteps.text = [NSString stringWithFormat:@"%@ Average Daily Steps", [object objectForKey:kPlayerAvgDailySteps]];
    
    

       self.myXPLevel.text = [NSString stringWithFormat:@"XP: %@", [object objectForKey:@"xp"]];
        
        self.streak.text = [NSString stringWithFormat:@"%@ days", [object objectForKey:kPlayerStreak]];
        self.streakLong.text = [NSString stringWithFormat:@"%@ days", [object objectForKey:kPlayerStreakLong]];
        
        
        NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
        
        int  numberOfTeams = (int)[RetrievedTeams integerForKey: kNumberOfTeams];
        
        if (numberOfTeams == 0) {
            self.myTeamsLabel.hidden = YES;
        }
        else
        {
            self.myTeamsLabel.hidden = NO;
        }
        
//    NSLog(%@XP: ", [user objectForKey:kPlayerXP]);
    
    //view controller header title
//    self.navigationItem.title = [NSString stringWithFormat:@"%@", [user objectForKey:kUserDisplayNameKey]];
    
    // Set a placeholder image first
    self.myProfilePhoto.image = [UIImage imageNamed:@"empty_avatar.png"];
    self.myProfilePhoto.file = (PFFile *)user[kUserProfilePicSmallKey];
    [self.myProfilePhoto loadInBackground];
//    
//    PFFile *imageFile = [user objectForKey:kUserProfilePicSmallKey];
//    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        // Now that the data is fetched, update the cell's image property.
//        self.myProfilePhoto.image = [UIImage imageWithData:data];
//    }];
    
    //turn photo to circle
    CALayer *imageLayer = self.myProfilePhoto.layer;
    [imageLayer setCornerRadius:self.myProfilePhoto.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];

    
    //if device has no camera i.e. simulator show an error message.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
//    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
     
 //*this value needs to be replaced with a dynamic value*
 PFUser * user = [PFUser currentUser];//<- use dynamic value here
     
 PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
 
 PFQuery *teamPlayersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
 [teamPlayersClass whereKey:kUserObjectIdString equalTo:user.objectId];
     [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:teamPlayersClass];
 
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
 
 return query;
 }



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     static NSString *CellIdentifier = @"MyTeamCell";
     
   AccountMyTeamCell *cell = (AccountMyTeamCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[AccountMyTeamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     cell.myTeamLabel.text = [object objectForKey:self.textKey];
     // Set a placeholder image first
     cell.playerTeamLogo.image = [UIImage imageNamed:@"team2.png"];
     cell.playerTeamLogo.file = (PFFile *)object[@"teamAvatar"];
     [cell.playerTeamLogo loadInBackground];
     CALayer *imageLayer = cell.playerTeamLogo.layer;
     [imageLayer setCornerRadius:cell.playerTeamLogo.frame.size.width/2];
     [imageLayer setBorderWidth:0];
     [imageLayer setMasksToBounds:YES];
     
//
// // Configure the cell
// cell.textLabel.text = [object objectForKey:self.textKey];
// cell.imageView.file = [object objectForKey:self.imageKey];
 
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

#pragma mark - Navigation

//pass the team to the teammates view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TeamSelectedAccountView"]) {
        
        //Find the row the button was selected from
        //        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        //        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
        
        NSIndexPath *hitIndex = [self.tableView indexPathForSelectedRow];
        
        PFObject *team = [self.objects objectAtIndex:hitIndex.row];
        
        [segue.destinationViewController initWithTeam:team];
        
        //[segue.destinationViewController initWithTeam:self.league];
        
    }
}


#pragma mark - UITableViewDataSource


//dirty way to hide all other cells that do not contain data
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    //    UIColor *color = [UIColor clearColor];
    //
    //    view.backgroundColor = color;
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 65;
}


////create a header section for Leagues
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return HeaderHeight;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//   
//    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////    sectionHeader.backgroundColor = [UIColor colorWithRed:225.0f/255.0f
////                                                    green:225.0f/255.0f
////                                                     blue:225.0f/255.0f
////                                                    alpha:1.0f];
//    
//    sectionHeader.backgroundColor = HeaderColor;
//    sectionHeader.textAlignment = HeaderAlignment;
//    sectionHeader.font = HeaderFont;
//    sectionHeader.textColor = HeaderTextColor;
//    sectionHeader.text =@"Teams";
//    
//    return sectionHeader;
//    
//}


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




//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
////#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
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

#pragma mark - Add Player Photo

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"How would you like to set your picture?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Picture",
                            @"Choose Picture",
                            
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
    }

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self showCamera];
                    break;
                case 1:
                    [self showPicker];
                    break;
                               default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)showCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];

}
-(void)showPicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //start activity indicator
    [self.activityIndicator startAnimating];
 
    //save photo to parse and display
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    PFFile *imageFile = [PFFile fileWithName:@"ProfileImage.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                
                //stop activity indicator
                [self.activityIndicator stopAnimating];
                
                self.myProfilePhoto.image = chosenImage;
                
                PFUser *user = [PFUser currentUser];
               
                user[kUserProfilePicSmallKey] = imageFile;
                [user saveInBackground];
                
                
                [self.view setNeedsDisplay];
            }
        } else {
            // Handle error
        }        
    }];
    
//    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
