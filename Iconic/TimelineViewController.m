//
//  TimelineViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/13/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "TimelineViewController.h"

#import "Constants.h"
#import "Utility.h"
#import "Cache.h"



@interface TimelineViewController ()

@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderCells;
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;

@property (nonatomic, retain) NSMutableDictionary *playerActivity;

@end

@implementation TimelineViewController

@synthesize reusableSectionHeaderCells;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries;

//@synthesize playerActivity = _playerActivity;

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



- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
        // Customize the table
        
        // The className to query on
       // self.parseClassName = kActivityClassKey;//<- following
        
        self.parseClassName = @"Test";
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        //self.imageKey = @"Photo";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        
        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderCells = [NSMutableSet setWithCapacity:3];
        
        self.shouldReloadOnAppear = NO;
        
       
    }
    return self;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = self.objects.count;
    if (self.paginationEnabled && sections != 0)
        sections++;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    static NSString *CellIdentifier = @"SectionHeader";
//    ActivityHeaderCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    
//    if (section == self.objects.count) {
//        // Load More section
//        return nil;
//    }
//    
//     //ActivityHeaderCell *headerView = [self dequeueReusableSectionHeaderView];
//    
//    if (!headerView) {
//        headerView = [[ActivityHeaderCell alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:ActivityHeaderButtonsDefault];
//        headerView.delegate = self;
//        [self.reusableSectionHeaderCells addObject:headerView];
//    }
//    
//   PFObject *activity = [self.objects objectAtIndex:section];
//    [headerView setActivity:activity];
//    headerView.tag = section;
//    [headerView.likeButton setTag:section];
//    
//    NSDictionary *attributesForActivity = [[Cache sharedCache] attributesForActivity:activity];
//    
//    if (attributesForActivity) {
//        [headerView setLikeStatus:[[Cache sharedCache] isActivityLikedByCurrentUser:activity]];
//        [headerView.likeButton setTitle:[[[Cache sharedCache] likeCountForActivity:activity] description] forState:UIControlStateNormal];
//        [headerView.commentButton setTitle:[[[Cache sharedCache] commentCountForActivity:activity] description] forState:UIControlStateNormal];
//        
//        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
//            [UIView animateWithDuration:0.200f animations:^{
//                headerView.likeButton.alpha = 1.0f;
//                headerView.commentButton.alpha = 1.0f;
//            }];
//        }
//    } else {
//        headerView.likeButton.alpha = 0.0f;
//        headerView.commentButton.alpha = 0.0f;
//    
//        @synchronized(self) {
//            // check if we can update the cache
//            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:[NSNumber numberWithInt:section]];
//            if (!outstandingSectionHeaderQueryStatus) {
//                PFQuery *query = [Utility queryForActivitiesOnActivity:activity cachePolicy:kPFCachePolicyNetworkOnly];
//                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    @synchronized(self) {
//                        [self.outstandingSectionHeaderQueries removeObjectForKey:[NSNumber numberWithInt:section]];
//                        
//                        if (error) {
//                            return;
//                        }
//                        
//                        NSMutableArray *likers = [NSMutableArray array];
//                        NSMutableArray *commenters = [NSMutableArray array];
//                        
//                        BOOL isLikedByCurrentUser = NO;
//                        
//                        for (PFObject *activity in objects) {
//                            if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike] && [activity objectForKey:kPlayerActionFromUserKey]) {
//                                [likers addObject:[activity objectForKey:kPlayerActionFromUserKey]];
//                            } else if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeComment] && [activity objectForKey:kPlayerActionFromUserKey]) {
//                                [commenters addObject:[activity objectForKey:kPlayerActionFromUserKey]];
//                            }
//                            
//                            if ([[[activity objectForKey:kPlayerActionFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
//                                if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike]) {
//                                    isLikedByCurrentUser = YES;
//                                }
//                            }
//                        }
//                        
//                        [[Cache sharedCache] setAttributesForActivity:activity likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
//                        
//                        if (headerView.tag != section) {
//                            return;
//                        }
//                        
//                        [headerView setLikeStatus:[[Cache sharedCache] isActivityLikedByCurrentUser:activity]];
//                        [headerView.likeButton setTitle:[[[Cache sharedCache] likeCountForActivity:activity] description] forState:UIControlStateNormal];
//                        [headerView.commentButton setTitle:[[[Cache sharedCache] commentCountForActivity:activity] description] forState:UIControlStateNormal];
//                        
//                        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
//                            [UIView animateWithDuration:0.200f animations:^{
//                                headerView.likeButton.alpha = 1.0f;
//                                headerView.commentButton.alpha = 1.0f;
//                            }];
//                        }
//                    }
//                }];
//            }
//        }
//    }
//    
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 16.0f)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return 16.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.objects.count) {
        // Load More Section
        return 44.0f;
    }
    
    return 280.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    }
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
     PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:@"Test"];
     //PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kPlayerActionClassKey];
     [followingActivitiesQuery whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeFollow];
     [followingActivitiesQuery whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
     followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;
     followingActivitiesQuery.limit = 1000;
     
     // Using the activities from the query above, we find all of the activity by
     // the friends the current user is following
     PFQuery *activityFromFollowedUsersQuery = [PFQuery queryWithClassName:self.parseClassName];
     [activityFromFollowedUsersQuery whereKey:kActivityUserKey matchesKey:kPlayerActionToUserKey inQuery:followingActivitiesQuery];
     [activityFromFollowedUsersQuery whereKeyExists:kActivityKey];//<-kActivityKey this key needs to be revised, in anypic example it reffers to the photo take by a user.  we are replacing phtos with a user's physical activity.
     
     // We create a second query for the current user's activity
     PFQuery *activityFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
     [activityFromCurrentUserQuery whereKey:kActivityUserKey equalTo:[PFUser currentUser]];
     [activityFromCurrentUserQuery whereKeyExists:kActivityKey]; //<-kActivityKey this key needs to be revised see above
     
     // We create a final compound query that will find all of the photos that were
     // taken by the user's friends or by the user
     PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:activityFromFollowedUsersQuery, activityFromCurrentUserQuery, nil]];
     [query includeKey:kActivityUserKey];
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
 
 [query orderByDescending:@"createdAt"];
 
 return query;
 }
 


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
//    static NSString *CellIdentifier = @"followCell";
//    
//    //PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    // Configure the cell
//    /*cell.textLabel.text = [object objectForKey:self.textKey];
//     cell.imageView.file = [object objectForKey:self.imageKey];*/
//    
//    cell.activityStatusText.text = [object objectForKey:self.textKey];
//    //cell.thumbnailPhoto.image = [object objectForKey:@"Photo"];
//    
//    PFFile *imageFile = [object objectForKey:self.imageKey];
//    
//    if([imageFile isDataAvailable])
//    {
//        
//        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            if(!error)
//            {
//                cell.profilePhoto.image = [UIImage imageWithData:data];
//            }
//        }];
//        
//    }
//    //turn photo to circle
//    CALayer *imageLayer = cell.profilePhoto.layer;
//    [imageLayer setCornerRadius:cell.profilePhoto.frame.size.width/2];
//    [imageLayer setBorderWidth:0];
//    [imageLayer setMasksToBounds:YES];
//    
//    
//    
//    
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    
    static NSString *CellIdentifier = @"SectionHeader";
    ActivityHeaderCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
//    if (!headerView) {
//        headerView = [[ActivityHeaderCell alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:ActivityHeaderButtonsDefault];
//        headerView.delegate = self;
//        [self.reusableSectionHeaderCells addObject:headerView];
//    }
    
    //PFObject *activity = [self.objects objectAtIndex:section];
    
    PFObject *activity = object;
    [headerView setActivity:activity];
//    headerView.tag = object;
//    [headerView.likeButton setTag:object];
    
    NSDictionary *attributesForActivity = [[Cache sharedCache] attributesForActivity:activity];
    
    if (attributesForActivity) {
        [headerView setLikeStatus:[[Cache sharedCache] isActivityLikedByCurrentUser:activity]];
        [headerView.likeButton setTitle:[[[Cache sharedCache] likeCountForActivity:activity] description] forState:UIControlStateNormal];
        [headerView.commentButton setTitle:[[[Cache sharedCache] commentCountForActivity:activity] description] forState:UIControlStateNormal];
        
        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
            [UIView animateWithDuration:0.200f animations:^{
                headerView.likeButton.alpha = 1.0f;
                headerView.commentButton.alpha = 1.0f;
            }];
        }
    } else {
        headerView.likeButton.alpha = 0.0f;
        headerView.commentButton.alpha = 0.0f;
        
        @synchronized(self) {
            // check if we can update the cache
            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:object];
            if (!outstandingSectionHeaderQueryStatus) {
                PFQuery *query = [Utility queryForActivitiesOnActivity:activity cachePolicy:kPFCachePolicyNetworkOnly];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(self) {
                        [self.outstandingSectionHeaderQueries removeObjectForKey:object];
                        
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
                        
//                        if (headerView.tag != section) {
//                            return;
//                        }
                        
                        [headerView setLikeStatus:[[Cache sharedCache] isActivityLikedByCurrentUser:activity]];
                        [headerView.likeButton setTitle:[[[Cache sharedCache] likeCountForActivity:activity] description] forState:UIControlStateNormal];
                        [headerView.commentButton setTitle:[[[Cache sharedCache] commentCountForActivity:activity] description] forState:UIControlStateNormal];
                        
                        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.200f animations:^{
                                headerView.likeButton.alpha = 1.0f;
                                headerView.commentButton.alpha = 1.0f;
                            }];
                        }
                    }
                }];
            }
        }
    }
    
    return headerView;
    
    
    
    
    
//    static NSString *CellIdentifier = @"followCell";
    
//    if (indexPath.section == self.objects.count) {
//        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
//        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
//        
//        
//        return cell;
//    } else {
//        FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            //[cell.photoButton addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        
////        cell.photoButton.tag = indexPath.section;
////        cell.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto.png"];
////        
////        if (object) {
////            cell.imageView.file = [object objectForKey:kPAPPhotoPictureKey];
////            
////            // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
////            if ([cell.imageView.file isDataAvailable]) {
////                [cell.imageView loadInBackground];
////            }
////        }
//        
//        return cell;
//    }
    
    
    
}





//- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
//    
//    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
//    if (!cell) {
//        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
//        cell.selectionStyle =UITableViewCellSelectionStyleGray;
//        cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
//        cell.hideSeparatorBottom = YES;
//        cell.mainView.backgroundColor = [UIColor clearColor];
//    }
//    return cell;
//}


#pragma mark - PAPPhotoTimelineViewController

- (ActivityHeaderCell *)dequeueReusableSectionHeaderView {
    for (ActivityHeaderCell *sectionHeaderCell in self.reusableSectionHeaderCells) {
        if (!sectionHeaderCell.superview) {
            // we found a section header that is no longer visible
            return sectionHeaderCell;
        }
    }
    
    return nil;
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

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:0 inSection:i];
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
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self loadObjects];
}

- (void)userFollowingChanged:(NSNotification *)note {
    NSLog(@"User following changed.");
    self.shouldReloadOnAppear = YES;
}

//this is if we want to enable another activity details screen
//- (void)didTapOnActivityAction:(UIButton *)sender {
//    PFObject *activity = [self.objects objectAtIndex:sender.tag];
//    if (activity) {
//        ActivityDetailsViewController *activityDetailsVC = [[ActivityDetailsViewController alloc] initWithActivity:activity];
//        [self.navigationController pushViewController:activityDetailsVC animated:YES];
//    }
//}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
