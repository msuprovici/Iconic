//
//  FollowersCommentsCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/13/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FollowersCommentsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *followersComment;

@property (strong, nonatomic) IBOutlet PFImageView *followersPhoto;

@end
