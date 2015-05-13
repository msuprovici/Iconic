//
//  FindFriendsCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/29/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>


@protocol FindFriendsCellDelegate;

@interface FindFriendsCell : UITableViewCell
{
    id _delegate;
}


@property (nonatomic, strong) id<FindFriendsCellDelegate> delegate;


@property (nonatomic, strong) PFUser *user;


@property (strong, nonatomic) IBOutlet PFImageView *avatarImageView;

@property (strong, nonatomic) IBOutlet UILabel *activityLabel;

@property (strong, nonatomic) IBOutlet UIButton *followButton;

@property (strong, nonatomic) IBOutlet UIButton *nameButton;

@property (strong, nonatomic) IBOutlet UIButton *avatarImageButton;

/*! Setters for the cell's content */
- (void)setUser:(PFUser *)user;

- (void)didTapUserButtonAction:(id)sender;
- (void)didTapFollowButtonAction:(id)sender;

/*! Static Helper methods */
+ (CGFloat)heightForCell;


@end


/*!
 The protocol defines methods a delegate that other cells should implement.
 */

@protocol FindFriendsCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(FindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(FindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end