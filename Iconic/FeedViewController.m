//
//  FeedViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/16/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "FeedViewController.h"
#import "ActivityHeaderCell.h"
#import "CommentsViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "Cache.h"
#import "Utility.h"

@interface FeedViewController()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableDictionary *outstandingActivityObjectQueries;
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end

@implementation FeedViewController
@synthesize shouldReloadOnAppear;
@synthesize outstandingActivityObjectQueries;


@synthesize timeIntervalFormatter;
@synthesize delegate;


#pragma mark - Initialization

- (void)dealloc {
    
    //be carefull with the notifications here - we currently don't have a TabBarController
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TabBarControllerDidFinishEditingActivityNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UtilityUserFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ActivityDetailsViewControllerUserLikedUnlikedActivityNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UtilityUserLikedUnlikedActivityCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ActivityDetailsViewControllerUserCommentedOnActivityNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ActivityDetailsViewControllerUserDeletedActivityNotification object:nil];
}


- (id)initWithCoder:(NSCoder *)aDecoder

{
    
    //self = [super initWithClassName:kActivityClassKey];
   // self = [super initWithClassName:@"Test"];
    self = [super initWithCoder:aDecoder];
   
    if (self) {
        
        self.outstandingActivityObjectQueries = [NSMutableDictionary dictionary];
        
        // Custom the table
        
        // The className to query on
        
        self.parseClassName = kActivityClassKey;
        //self.parseClassName = @"Test";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishActivity:) name:TabBarControllerDidFinishEditingActivityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowingChanged:) name:UtilityUserFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidDeleteActivity:) name:ActivityDetailsViewControllerUserDeletedActivityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikeActivity:) name:ActivityDetailsViewControllerUserLikedUnlikedActivityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikeActivity:) name:UtilityUserLikedUnlikedActivityCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCommentOnActivity:) name:ActivityDetailsViewControllerUserCommentedOnActivityNotification object:nil];
    
  
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
    
    //should use delegation instead of reloading the view everytime
    [self.tableView reloadData];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
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
     
     if (![PFUser currentUser]) {
         PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
         [query setLimit:0];
         return query;
     }

     
     // Query for the friends the current user is following
     //PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:@"Test"];//<- using this for testing purposes
     PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPlayerActionClassKey];
     [followingActivitiesQuery whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeFollow];
     [followingActivitiesQuery whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
     followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;
     followingActivitiesQuery.limit = 1000;
 
     
     // Using the activities from the query above, we find all of the activity by
     // the friends the current user is following
     PFQuery *activityFromFollowedUsersQuery = [PFQuery queryWithClassName:self.parseClassName];
     [activityFromFollowedUsersQuery whereKey:kActivityUserKey matchesKey:kPlayerActionToUserKey inQuery:followingActivitiesQuery];
     [activityFromFollowedUsersQuery whereKeyExists:kActivityKey];

     
     // We create a second query for the current user's activity
     PFQuery *activityFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
     [activityFromCurrentUserQuery whereKey:kActivityUserKey equalTo:[PFUser currentUser]];
     [activityFromCurrentUserQuery whereKeyExists:kActivityKey]; //<-kActivityKey this key needs to be revised see above
     
     //retrieve my teams array from NSUserDefaults
      NSUserDefaults *Teams = [NSUserDefaults standardUserDefaults];
     NSArray * myTeams = [Teams objectForKey:kArrayOfMyTeamsNames];
     
     // We create a third query for the current user's team activity
     PFQuery *teamActivityForCurrentUser = [PFQuery queryWithClassName:self.parseClassName];
     [teamActivityForCurrentUser whereKey:@"teamName" containedIn:myTeams];//array of players teams stored in NSuserDefualuts
     
     [teamActivityForCurrentUser whereKeyExists:kActivityKey];
     
     
     
     // We create a final compound query that will find all of the activities that were
     // participated in by the user's friends or by the user
     PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:activityFromFollowedUsersQuery, activityFromCurrentUserQuery, teamActivityForCurrentUser, nil]];
     [query includeKey:kActivityUserKey];
     [query includeKey:@"team"];
     [query orderByDescending:@"createdAt"];
     
     
     // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
     query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
     
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
 
     
 
    return query;
     
 }



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"Cell";
 
 ActivityHeaderCell *cell = (ActivityHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[ActivityHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     cell.delegate = self;
 }
 
     
//     if (!cell) {
//         cell = [[ActivityHeaderCell alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:ActivityHeaderButtons];
//         cell.delegate = self;
//         [self.reusableSectionHeaderViews addObject:cell];
//     }
     
 // Configure the cell
// cell.textLabel.text = [object objectForKey:self.textKey];
// cell.imageView.file = [object objectForKey:self.imageKey];

     
     PFObject *activity = [self.objects objectAtIndex:indexPath.row];
     [cell setActivity:activity];
     cell.tag = indexPath.row;
     [cell.likeButton setTag:indexPath.row];
     
     // show points
     if (object) {
//         cell.activityStatusLabel.text = [NSString stringWithFormat:@"Scored %@ points",[object objectForKey:kActivityKey]];
         
         cell.activityStatusLabel.text = [object objectForKey:kActivityKey];
     }
     
     // add time stamp
     NSTimeInterval timeInterval = [[activity createdAt] timeIntervalSinceNow];
     NSString *timestamp = [NSString stringWithFormat:@"%@",[self.timeIntervalFormatter stringForTimeInterval:timeInterval]];
     
     //NSString *timestamp = [cell.timeIntervalFormatter stringForTimeInterval:timeInterval];
     
     //NSString *timestamp = [NSString stringWithFormat:@"%f",timeInterval];

     
     [cell.timestampLabel setText:timestamp];

     
     NSDictionary *attributesForActivity = [[Cache sharedCache] attributesForActivity:activity];
     
     if (attributesForActivity) {
         [cell setLikeStatus:[[Cache sharedCache] isActivityLikedByCurrentUser:activity]];
//         [cell.likeButton setTitle:[[[Cache sharedCache] likeCountForActivity:activity] description] forState:UIControlStateNormal];
         cell.likeCount.text = [[[Cache sharedCache] likeCountForActivity:activity] description];
//         [cell.commentButton setTitle:[[[Cache sharedCache] commentCountForActivity:activity] description] forState:UIControlStateNormal];
         cell.commentCount.text = [[[Cache sharedCache] commentCountForActivity:activity] description];
         
//         if (cell.likeButton.alpha < 1.0f || cell.commentButton.alpha < 1.0f) {
//             [UIView animateWithDuration:0.200f animations:^{
//                 cell.likeButton.alpha = 1.0f;
//                 cell.commentButton.alpha = 1.0f;
//             }];
//         }
     } else {
//         cell.likeButton.alpha = 0.0f;
//         cell.commentButton.alpha = 0.0f;
         
         @synchronized(self) {
             // check if we can update the cache
             NSNumber *outstandingActivityObjectQueryStatus = [self.outstandingActivityObjectQueries objectForKey:object];
             if (!outstandingActivityObjectQueryStatus) {
                 PFQuery *query = [Utility queryForActivitiesOnActivity:activity cachePolicy:kPFCachePolicyNetworkOnly];
                 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                     @synchronized(self) {
                         [self.outstandingActivityObjectQueries removeObjectForKey:object];
                         
                         if (error) {
                             return;
                         }
                         
                         NSMutableArray *likers = [NSMutableArray array];
                         NSMutableArray *commenters = [NSMutableArray array];
                         
                         BOOL isLikedByCurrentUser = NO;
                         
                         for (PFObject *activity in objects) {
                             if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike] && [activity objectForKey:kPlayerActionFromUserKey]) {
                                 [likers addObject:[activity objectForKey:kPlayerActionFromUserKey]];
                             } else if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeComment] && [activity objectForKey:kPlayerActionFromUserKey]) {
                                 [commenters addObject:[activity objectForKey:kPlayerActionFromUserKey]];
                             }
                             
                             if ([[[activity objectForKey:kPlayerActionFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                 if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike]) {
                                     isLikedByCurrentUser = YES;
                                 }
                             }
                         }
                         
                         [[Cache sharedCache] setAttributesForActivity:activity likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                         
                         
                         [cell setLikeStatus:[[Cache sharedCache] isActivityLikedByCurrentUser:activity]];
//                         [cell.likeButton setTitle:[[[Cache sharedCache] likeCountForActivity:activity] description] forState:UIControlStateNormal];
                         cell.likeCount.text = [[[Cache sharedCache] likeCountForActivity:activity] description];

//                         [cell.commentButton setTitle:[[[Cache sharedCache] commentCountForActivity:activity] description] forState:UIControlStateNormal];
                         cell.commentCount.text = [[[Cache sharedCache] commentCountForActivity:activity] description];

//                         if (cell.likeButton.alpha < 1.0f || cell.commentButton.alpha < 1.0f) {
//                             [UIView animateWithDuration:0.200f animations:^{
//                                 cell.likeButton.alpha = 1.0f;
//                                 cell.commentButton.alpha = 1.0f;
//                             }];
//                         }
                     }
                 }];
             }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.objects.count) {
        // Load More Section
        return 44.0f;
    }
    
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - FeedViewDelegate


- (IBAction)didTapActivityButton:(UIButton *)sender  {
    
   
    ActivityHeaderCell * cell = [[ActivityHeaderCell alloc]init];
    
    PFObject *activity = [self.objects objectAtIndex:sender.tag];
    
    
    [self activityHeaderCell:cell didTapLikeActivityButton:sender activity:activity];
    
    
    
 }

- (void)activityHeaderCell:(ActivityHeaderCell *)activityHeaderCell didTapLikeActivityButton:(UIButton *)button activity:(PFObject *)activity {
    
    [activityHeaderCell shouldEnableLikeButton:NO];
    
    BOOL liked = !button.selected;
    [activityHeaderCell setLikeStatus:liked];
    
     NSIndexPath * path = [NSIndexPath indexPathForRow:button.tag inSection:0];
    
    NSString *originalButtonTitle = button.titleLabel.text;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *likeCount = [numberFormatter numberFromString:button.titleLabel.text];
    if (liked) {
        NSLog(@"like button is tapped");
        likeCount = [NSNumber numberWithInt:[likeCount intValue] + 1];
        [[Cache sharedCache] incrementLikerCountForActivity:activity];
        
        
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
    } else {
        NSLog(@"unlike button is tapped");
        if ([likeCount intValue] > 0) {
            likeCount = [NSNumber numberWithInt:[likeCount intValue] - 1];
        }
        [[Cache sharedCache] decrementLikerCountForActivity:activity];
        
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
    }
    
    [[Cache sharedCache] setActivityIsLikedByCurrentUser:activity liked:liked];
    
//    [button setTitle:[numberFormatter stringFromNumber:likeCount] forState:UIControlStateNormal];
//    [button setTitle:[numberFormatter stringFromNumber:likeCount] forState:UIControlStateSelected];
    
    //convert button.tag, an NSInteger, to NSIndexpath
    //NSIndexPath *path = [NSIndexPath indexPathWithIndex:button.tag];
    
   
    
    if (liked) {
        
        //update cell
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        [Utility likeActivityInBackground:activity block:^(BOOL succeeded, NSError *error) {
            ActivityHeaderCell *actualHeaderCell = (ActivityHeaderCell *)[self tableView:self.tableView cellForRowAtIndexPath:path];
            [actualHeaderCell shouldEnableLikeButton:YES];
            [actualHeaderCell setLikeStatus:succeeded];
            
            if (!succeeded) {
                
                [actualHeaderCell.likeButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
            else
                NSLog(@"Like button succeded");
            
        }];
        
        //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        
        //update cell
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        [Utility unlikeActivityInBackground:activity block:^(BOOL succeeded, NSError *error) {
            ActivityHeaderCell *actualHeaderView = (ActivityHeaderCell *)[self tableView:self.tableView cellForRowAtIndexPath:path];
            [actualHeaderView shouldEnableLikeButton:YES];
            [actualHeaderView setLikeStatus:!succeeded];
            
            if (!succeeded) {
                [actualHeaderView.likeButton setTitle:originalButtonTitle forState:UIControlStateNormal];
            }
            else
                NSLog(@"Unlike button succeded");
        }];
        
       // [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}



//- (IBAction)didTapCommentOnActivityButton:(UIButton *)sender {
//    
//    //ActivityHeaderCell * cell = [[ActivityHeaderCell alloc]init];
//    
//     //NSIndexPath *indexPath = [self.objects objectAtIndex:sender.tag];
//    
//    PFObject *activity = [self.objects objectAtIndex:sender.tag];
//    
//    //[self activityHeaderCell:cell didTapCommentOnActivityButton:sender activity:activity];
//   
//  
//        
//    CommentsViewController *activityDetailsVC = [[CommentsViewController alloc] init];
//    
//    [activityDetailsVC initWithActivity:activity];
//    
//      // [self.navigationController pushViewController:activityDetailsVC animated:YES];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ActivityDetails"]) {
       
        //Find the row the button was selected from
        CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
  
        PFObject *activity = [self.objects objectAtIndex:hitIndex.row];
        
        [segue.destinationViewController initWithActivity:activity];
       
    }
}

-(void)yourButtonPressed:(id)sender
{
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSLog(@"%i",hitIndex.row);
    
    
}
//
//- (void)activityHeaderCell:(ActivityHeaderCell *)activityHeaderCell didTapCommentOnActivityButton:(UIButton *)button  activity:(PFObject *)activity {
//    CommentsViewController *activityDetailsVC = [[CommentsViewController alloc] initWithActivity:activity];
//    [self.navigationController pushViewController:activityDetailsVC animated:YES];
//}


#pragma mark - ()

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathWithIndex:i];
        }
    }
    
    return nil;
}

- (void)userDidLikeOrUnlikeActivity:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
   
}

- (void)userDidCommentOnActivity:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidDeleteActivity:(NSNotification *)note {
    // refresh timeline after a delay
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self loadObjects];
    });
}

- (void)userDidPublishActivity:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndex:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self loadObjects];
}

- (void)userFollowingChanged:(NSNotification *)note {
    NSLog(@"User following changed.");
    self.shouldReloadOnAppear = YES;
}


- (void)didTapOnActivityAction:(UIButton *)sender {
    PFObject *activity = [self.objects objectAtIndex:sender.tag];
//    if (activity) {
//        CommentsViewController *activityDetailsVC = [[CommentsViewController alloc] initWithActivity:activity];
//        [self.navigationController pushViewController:activityDetailsVC animated:YES];
//    }
}



//- (IBAction)didTapOnLikeAction:(id)sender {
//    
//    ActivityHeaderCell *cell;
//    
//    [cell.likeButton addTarget:cell action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    NSLog(@"like button pressed");
//    
//    //[cell.likeButton addTarget:cell action:cell.didTapLikeActivityButtonAction ];
//    
//}
//
//- (void)didTapLikeActivityButtonAction:(UIButton *)button {
//    
//    
//     ActivityHeaderCell *cell;
//    
//    if (delegate && [delegate respondsToSelector:@selector(activityHeaderCell:didTapLikeActivityButton:activity:)]) {
//        [delegate activityHeaderCell:cell didTapLikeActivityButton:button activity:cell.activity];
//        
//        
//    }
//}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
}

@end