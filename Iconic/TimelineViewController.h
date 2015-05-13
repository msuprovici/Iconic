//
//  TimelineViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/13/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "FeedCell.h"
#import <Parse/Parse.h>
#import "ActivityHeaderCell.h"

@interface TimelineViewController : PFQueryTableViewController <ActivityHeaderCellDelegate>


- (ActivityHeaderCell *)dequeueReusableSectionHeaderView;


@end
