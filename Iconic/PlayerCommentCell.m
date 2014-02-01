//
//  PlayerCommentCell.m
//  Iconic
//
//  Created by Mike Suprovici on 1/17/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "PlayerCommentCell.h"
#import "Constants.h"
#import "TTTTimeIntervalFormatter.h"
#import "Utility.h"


static TTTTimeIntervalFormatter *timeFormatter;

@implementation PlayerCommentCell

@synthesize avatarImageView;
@synthesize nameButton;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize delegate;
@synthesize user;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






#pragma mark - Delegate methods

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

#pragma mark - PlayerCommentCell methods

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Set name button properties and avatar image
 //   [self.avatarImageView setFile:[self.user objectForKey:kUserProfilePicSmallKey]];
    [self.nameButton setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateNormal];
    [self.nameButton setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateHighlighted];
//    [self.avatarImageView setFile:[self.user objectForKey:kUserProfilePicSmallKey]];
//    [self.avatarImageView loadInBackground];
    
    //turn photo to circle
    //    CALayer *imageLayer = self.avatarImageView.layer;
    //    [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
    //    [imageLayer setBorderWidth:0];
    //    [imageLayer setMasksToBounds:YES];
    
    // Set a placeholder image first
    self.avatarImageView.image = [UIImage imageNamed:@"empty_avatar.png"];
    PFFile *imageFile = [self.user objectForKey:kUserProfilePicSmallKey];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
        self.avatarImageView.image = [UIImage imageWithData:data];
     }];
    
    //turn photo to circle
        CALayer *imageLayer = self.avatarImageView.layer;
        [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
        [imageLayer setBorderWidth:0];
        [imageLayer setMasksToBounds:YES];


       
    // If user is set after the contentText, we reset the content to include padding
//    if (self.contentLabel.text) {
//        [self setContentText:self.contentLabel.text];
//    }
    [self setNeedsDisplay];
}

- (void)setContentText:(NSString *)contentString {
    
    //[self.contentLabel setText:contentString];
    
    [self setNeedsDisplay];
    
    }

- (void)setDate:(NSDate *)date {
    // Set the label with a human readable time
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date]];
    [self setNeedsDisplay];
}

/* Since we remove the compile-time check for the delegate conforming to the protocol
 in order to allow inheritance, we add run-time checks. */
- (id<PlayerCommentCellDelegate>)delegate {
    return (id<PlayerCommentCellDelegate>)delegate;
}

- (void)setDelegate:(id<PlayerCommentCellDelegate>)aDelegate {
    if (delegate != aDelegate) {
        delegate = aDelegate;
    }
}




@end
