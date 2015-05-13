//
//  ProfileViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/13/13.
//  Copyright (c) 2013 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import "TeamatesCell.h"
#import "ProfileInfoCell.h"
#import "FeedCell.h"

@interface ProfileViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

{
    
    NSArray *teamatesArray;
}


@property (nonatomic, strong) NSArray *contentList;

@property (nonatomic, weak) IBOutlet UITableView *friendsTable;



@end
