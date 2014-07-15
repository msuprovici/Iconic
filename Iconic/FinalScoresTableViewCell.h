//
//  FinalScoresTableViewCell.h
//  Iconic
//
//  Created by Mike Suprovici on 7/14/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalScoresTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *myTeamName;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamName;

@property (strong, nonatomic) IBOutlet UILabel *myTeamScore;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamScore;

@end
