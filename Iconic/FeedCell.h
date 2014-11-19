//
//  FeedCell.h
//  Iconic
//
//  Created by Mike Suprovici on 12/20/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *activityStatusText;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UILabel *likesCounter;
@property (weak, nonatomic) IBOutlet UILabel *commentsCounter;

@end
