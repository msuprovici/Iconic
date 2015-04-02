//
//  FeedViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/16/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import "TTTTimeIntervalFormatter.h"
#import "ActivityHeaderCell.h"

@interface FeedViewController : PFQueryTableViewController <ActivityHeaderCellDelegate>

@property (nonatomic,weak) id <ActivityHeaderCellDelegate> delegate;

- (IBAction)findPeople:(id)sender;

@end
