//
//  HomeViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TeamatesCell.h"


@interface HomeViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITableViewDelegate>

{
    
    NSArray *teamatesArray;
}


@property (nonatomic, strong) NSArray *contentList;


@property (nonatomic, weak) IBOutlet UITableView *teamatesTable;

@end
