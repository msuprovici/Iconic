//
//  TodayTeamsTableViewCell.h
//  Iconic
//
//  Created by Mike Suprovici on 10/3/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTeamsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *myTeamName;
@property (strong, nonatomic) IBOutlet UILabel *myTeamScore;
@property (strong, nonatomic) IBOutlet UILabel *vsTeamName;
@property (strong, nonatomic) IBOutlet UILabel *vsTeamScore;
@property (strong, nonatomic) IBOutlet UILabel *leagueName;


@end
