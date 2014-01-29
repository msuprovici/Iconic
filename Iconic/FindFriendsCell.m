//
//  FindFriendsCell.m
//  Iconic
//
//  Created by Mike Suprovici on 1/29/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "FindFriendsCell.h"
#import "Constants.h"

@implementation FindFriendsCell

@synthesize delegate;
@synthesize user;
@synthesize avatarImageView;
@synthesize avatarImageButton;
@synthesize nameButton;
@synthesize activityLabel;
@synthesize followButton;


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

#pragma mark - PAPFindFriendsCell

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Configure the cell
    [avatarImageView setFile:[self.user objectForKey:kUserProfilePicSmallKey]];
    
    // Set name
//    NSString *nameString = [self.user objectForKey:kUserDisplayNameKey];
//    CGSize nameSize = [nameString sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] forWidth:144.0f lineBreakMode:UILineBreakModeTailTruncation];
//    [nameButton setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateNormal];
//    [nameButton setTitle:[self.user objectForKey:kUserDisplayNameKey] forState:UIControlStateHighlighted];
//    
//    [nameButton setFrame:CGRectMake( 60.0f, 17.0f, nameSize.width, nameSize.height)];
//    
//    // Set activity number label
//    CGSize photoLabelSize = [@"activity" sizeWithFont:[UIFont systemFontOfSize:11.0f] forWidth:144.0f lineBreakMode:UILineBreakModeTailTruncation];
//    [activityLabel setFrame:CGRectMake( 60.0f, 17.0f + nameSize.height, 140.0f, photoLabelSize.height)];
//    
//    // Set follow button
//    [followButton setFrame:CGRectMake( 208.0f, 20.0f, 103.0f, 32.0f)];
}

#pragma mark - ()

+ (CGFloat)heightForCell {
    return 67.0f;
}

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

/* Inform delegate that the follow button was tapped */
- (void)didTapFollowButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
        [self.delegate cell:self didTapFollowButton:self.user];
    }
}


@end
