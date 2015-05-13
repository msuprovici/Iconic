//
//  LeaguesViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Iconic All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface LeaguesViewController : PFQueryTableViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *createLeague;

@end
