//
//  TeamPlayerCell.m
//  Iconic
//
//  Created by Mike Suprovici on 2/5/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "TeamPlayerCell.h"
#import "Constants.h"

@implementation TeamPlayerCell
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

#pragma mark - TeamPlayerCell methods

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Set name button properties and avatar image
    //   [self.avatarImageView setFile:[self.user objectForKey:kUserProfilePicSmallKey]];
    [self.playerName setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateNormal];
    [self.playerName setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateHighlighted];
    //    [self.avatarImageView setFile:[self.user objectForKey:kUserProfilePicSmallKey]];
    //    [self.avatarImageView loadInBackground];
    
    //turn photo to circle
    //    CALayer *imageLayer = self.avatarImageView.layer;
    //    [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
    //    [imageLayer setBorderWidth:0];
    //    [imageLayer setMasksToBounds:YES];
    
    // Set a placeholder image first
    self.playerPhoto.image = [UIImage imageNamed:@"empty_avatar.png"];
    PFFile *imageFile = [self.user objectForKey:kUserProfilePicSmallKey];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
        self.playerPhoto.image = [UIImage imageWithData:data];
    }];
    
    //turn photo to circle
    CALayer *imageLayer = self.playerPhoto.layer;
    [imageLayer setCornerRadius:self.playerPhoto.frame.size.width/2];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    
    
    
    // If user is set after the contentText, we reset the content to include padding
    //    if (self.contentLabel.text) {
    //        [self setContentText:self.contentLabel.text];
    //    }
    [self setNeedsDisplay];
}




@end
