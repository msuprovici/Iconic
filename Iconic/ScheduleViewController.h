//
//  ScheduleViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 11/13/13.
//  Copyright (c) 2013 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import "ScheduleCell.h"

@interface ScheduleViewController : PFQueryTableViewController

@property (weak, nonatomic) IBOutlet UILabel *matchupsLabel;

-(void)initWithLeague:(PFObject*)aLeague;
@property (nonatomic, strong) PFObject *league;

@end
