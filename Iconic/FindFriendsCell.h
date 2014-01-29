//
//  FindFriendsCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/29/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@protocol FindFreindsCellDelegate;

@interface FindFriendsCell : UITableViewCell
{
    id _delegate;
}


@property (nonatomic, strong) id<FindFreindsCellDelegate> delegate;


@property (nonatomic, strong) PFUser *user;


@property (strong, nonatomic) IBOutlet PFImageView *avatarImageView;

@property (strong, nonatomic) IBOutlet UILabel *photoLabel;

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

@protocol FindFreindsCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(FindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(FindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end