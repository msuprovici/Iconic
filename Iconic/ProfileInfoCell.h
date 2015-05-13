//
//  ProfileInfoCell.h
//  Iconic
//
//  Created by Mike Suprovici on 12/20/13.
//  Copyright (c) 2013 Iconic All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberOfTeams;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numberFollwers;
@property (weak, nonatomic) IBOutlet UIButton *followPlayer;
@property (weak, nonatomic) IBOutlet UIButton *followingLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *teamsButton;

@end
