//
//  MyFinalScoresCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/30/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFinalScoresCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *myTeamName;

@property (strong, nonatomic) IBOutlet UILabel *vsTeamName;
@property (strong, nonatomic) IBOutlet UILabel *myTeamScore;
@property (strong, nonatomic) IBOutlet UILabel *myLeague;
@property (weak, nonatomic) IBOutlet UILabel *myTeamRecord;
@property (weak, nonatomic) IBOutlet UILabel *vsTeamRecord;


@property (strong, nonatomic) IBOutlet UILabel *vsTeamScore;


@end
