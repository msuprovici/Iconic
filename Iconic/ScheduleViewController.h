//
//  ScheduleViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 11/13/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ScheduleCell.h"

@interface ScheduleViewController : PFQueryTableViewController

@property (weak, nonatomic) IBOutlet UILabel *matchupsLabel;

@end
