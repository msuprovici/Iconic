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
#import "VSCell.h"


@interface HomeViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

{
    
    NSArray *teamatesArray;
    
    NSArray *vsTeamsArray;
    
   
}


@property (nonatomic, strong) NSArray *contentList;


@property (nonatomic, weak) IBOutlet UITableView *teamatesTable;


@end
