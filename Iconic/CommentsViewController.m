//
//  CommentsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/13/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "CommentsViewController.h"

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

#import "Utility.h"
#import "Constants.h"
#import "Cache.h"

#import "ActivityHeaderCell.h"
#import "ActivityDeatailsHeaderCell.h"
#import "ProfileImageView.h"

@interface CommentsViewController ()

@property (nonatomic, strong) UITextField * commentTextField;
@property (nonatomic, assign) BOOL likersQueryInProgress;
@property (nonatomic, strong) ActivityDeatailsHeaderCell *headerView;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@property (nonatomic, strong, readwrite) PFUser *player;


@end

static TTTTimeIntervalFormatter *timeFormatter;

@implementation CommentsViewController

@synthesize commentTextField;
@synthesize activity;
@synthesize headerView;
@synthesize timeIntervalFormatter;
@synthesize player;


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UtilityUserLikedUnlikedActivityCallbackFinishedNotification object:self.activity];
}


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // Custom the table
        
        // The className to query on
        //self.parseClassName = @"Test";
        
        self.parseClassName = kPlayerActionClassKey;
        
        // The key of the PFObject to display in the label of the default cell style
        // self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        //self.activity = anActivity;
        
        
        self.likersQueryInProgress = NO;
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
       
        
    }
    return self;

    
}
-(void)initWithActivity:(PFObject *)anActivity
{
    self.activity = anActivity;
    self.player = [self.activity objectForKey:kActivityUserKey];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set table header
    
//    self.headerView = [[ActivityDeatailsHeaderCell alloc] initWithFrame:[ActivityDeatailsHeaderCell rectForView] activity:self.activity];
//    
//    self.headerView.delegate = self;
//    
//    self.tableView.tableHeaderView = self.headerView;

//    self.tableView.tableHeaderView = [[ActivityDeatailsHeaderCell alloc]init];
    
    // Set table footer
//    CommentCell *footerView = [[CommentCell alloc] init];
//    commentTextField = footerView.commentField;
//    commentTextField.delegate = self;
//    self.tableView.tableFooterView = footerView;
    
    
    // Register to be notified when the keyboard will be shown to scroll the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedActivity:) name:UtilityUserLikedUnlikedActivityCallbackFinishedNotification object:self.activity];
    
    
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
    
    BOOL hasCachedLikers = [[Cache sharedCache] attributesForActivity:self.activity] != nil;
    if (!hasCachedLikers) {
   // [self loadLikers];
    }
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


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.objects.count) {
        // Load More Section
        return 44.0f;
    }
    
    return 80.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}



 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
// - (PFQuery *)queryForTable {
// PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
//     [query whereKey:kPlayerActionActivityKey equalTo:self.activity];
//     [query includeKey:kPlayerActionFromUserKey];
//     [query whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeComment];
//     [query orderByAscending:@"createdAt"];
// 
// // If Pull To Refresh is enabled, query against the network by default.
// if (self.pullToRefreshEnabled) {
// query.cachePolicy = kPFCachePolicyNetworkOnly;
// }
// 
// // If no objects are loaded in memory, we look to the cache first to fill the table
// // and then subsequently do a query against the network.
// if (self.objects.count == 0) {
// query.cachePolicy = kPFCachePolicyCacheThenNetwork;
// }
// 
// [query orderByDescending:@"createdAt"];
// 
// return query;
// }


- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
   // [self.headerView reloadLikeBar];
   // [self loadLikers];
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {


//using a cell to display the header...
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
 static NSString *CellIdentifier = @"ActivityDetailsCell";
 
 ActivityDeatailsHeaderCell *cell = (ActivityDeatailsHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[ActivityDeatailsHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     //cell.delegate = self;
 }
 
 // Configure the cell

     
     //setup activity text
     cell.ActivityLabel.text = [NSString stringWithFormat:@"Scored %@ points",[self.activity objectForKey:kActivityKey]];
     
     NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[self.activity createdAt]];
     
     [cell.timeLabel setText:timeString];
     
     PFUser *user = [self.player objectForKey:kUserDisplayNameKey];
     
     NSString * playerName = [NSString stringWithFormat:@"%@",user];
     
     [cell.userButton setTitle:playerName forState:UIControlStateNormal];
     
     //PFFile *profilePictureSmall = [user objectForKey:kUserProfilePicSmallKey];
     
//     [cell.avatarImageView setFile:[user objectForKey:kUserProfilePicSmallKey]];
//     
//     //turn photo to circle
//     CALayer *imageLayer = cell.avatarImageView.layer;
//     [imageLayer setCornerRadius:cell.avatarImageView.frame.size.width/2];
//     [imageLayer setBorderWidth:0];
//     [imageLayer setMasksToBounds:YES];
     
     
     
     
     //[cell.likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     
     
     [cell reloadLikeBar];
     

     
     
     
     
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






#pragma mark - ()

- (void)showShareSheet {
    [[self.activity objectForKey:kActivityKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
            
            // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
            if ([[[PFUser currentUser] objectId] isEqualToString:[[self.activity objectForKey:kActivityUserKey] objectId]] && [self.objects count] > 0) {
                PFObject *firstActivity = self.objects[0];
                if ([[[firstActivity objectForKey:kPlayerActionFromUserKey] objectId] isEqualToString:[[self.activity objectForKey:kActivityUserKey] objectId]]) {
                    NSString *commentString = [firstActivity objectForKey:kPlayerActionContentKey];
                    [activityItems addObject:commentString];
                }
            }
            //create the share page URL here
            /*
            [activityItems addObject:[UIImage imageWithData:data]];
            [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://anypic.org/#pic/%@", self.activity.objectId]]];
            */
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
        }
    }];
}

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    //[MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
}

/*- (void)shouldPresentAccountViewForUser:(PFUser *)user {
    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
}*/

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userLikedOrUnlikedActivity:(NSNotification *)note {
    [self.headerView reloadLikeBar];
}

- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}


- (void)loadLikers {
    if (self.likersQueryInProgress) {
        return;
    }
    
    self.likersQueryInProgress = YES;
    PFQuery *query = [Utility queryForActivitiesOnActivity:activity cachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likersQueryInProgress = NO;
        if (error) {
            [self.headerView reloadLikeBar];
            return;
        }
        
        NSMutableArray *likers = [NSMutableArray array];
        NSMutableArray *commenters = [NSMutableArray array];
        
        BOOL isLikedByCurrentUser = NO;
        
        for (PFObject *playeractivity in objects) {
            if ([[playeractivity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike] && [playeractivity objectForKey:kPlayerActionFromUserKey]) {
                [likers addObject:[playeractivity objectForKey:kPlayerActionFromUserKey]];
            } else if ([[playeractivity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeComment] && [playeractivity objectForKey:kPlayerActionFromUserKey]) {
                [commenters addObject:[playeractivity objectForKey:kPlayerActionFromUserKey]];
            }
            
            if ([[[playeractivity objectForKey:kPlayerActionFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                if ([[playeractivity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike]) {
                    isLikedByCurrentUser = YES;
                }
            }
        }
        
        [[Cache sharedCache] setAttributesForActivity:self.activity likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
        [self.headerView reloadLikeBar];
    }];
}


@end