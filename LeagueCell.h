//
//  LeagueCell.h
//  Iconic
//
//  Created by Mike Suprovici on 2/13/14.
//  Copyright (c) 2014 Iconic All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeagueCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *leagueName;
@property (strong, nonatomic) IBOutlet UILabel *unlocksAtLevelTitle;
@property (strong, nonatomic) IBOutlet UILabel *leagueLevel;

@property (strong, nonatomic) IBOutlet UILabel *leagueLocked;
@end
