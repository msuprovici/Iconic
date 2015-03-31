//
//  PlayerTeamsCell.h
//  Iconic
//
//  Created by Mike Suprovici on 7/7/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>


@interface PlayerTeamsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *playerTeamLabel;

@property (strong, nonatomic) IBOutlet PFImageView *playerTeamLogo;

@end
