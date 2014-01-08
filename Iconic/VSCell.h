//
//  VSCell.h
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNLineChart.h"

@interface VSCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *MyTeam;

@property (weak, nonatomic) IBOutlet UILabel *MyTeamScore;

@property (weak, nonatomic) IBOutlet UILabel *VSTeam;

@property (weak, nonatomic) IBOutlet UILabel *VSTeamScore;

@property (strong, nonatomic) IBOutlet PNLineChart *teamMatchChart;

@end
