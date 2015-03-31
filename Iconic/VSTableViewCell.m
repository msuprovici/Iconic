//
//  VSTableViewCell.m
//  Iconic
//
//  Created by Mike Suprovici on 2/28/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "VSTableViewCell.h"
#import "Constants.h"

@implementation VSTableViewCell
@synthesize user;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Set name button properties and avatar image
    self.playerName.text = [self.user objectForKey:kUserDisplayNameKey];
    
//    [self.playerName setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateNormal];
//    [self.playerName setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateHighlighted];
   
    
    // Set a placeholder image first
    self.playerPhoto.image = [UIImage imageNamed:@"empty_avatar.png"];
    self.playerPhoto.file = (PFFile *)self.user[kUserProfilePicSmallKey];
    [self.playerPhoto loadInBackground];
//    PFFile *imageFile = [self.user objectForKey:kUserProfilePicSmallKey];
//    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        // Now that the data is fetched, update the cell's image property.
//        self.playerPhoto.image = [UIImage imageWithData:data];
//    }];
    
    //turn photo to circle
    CALayer *imageLayer = self.playerPhoto.layer;
    [imageLayer setCornerRadius:self.playerPhoto.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    
    //Set Points
    self.playerPoints.text = [NSString stringWithFormat:@"%@",[self.user objectForKey:kPlayerPointsToday]];

    
       [self setNeedsDisplay];
}


@end
