//
//  ActivityDeatailsHeaderCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/17/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@protocol ActivityDeatailsHeaderCellDelegate;

@interface ActivityDeatailsHeaderCell : PFTableViewCell

/*! @name Managing View Properties */

/// The activity displayed in the view
@property (nonatomic, strong, readonly) PFObject *activity;

/// The user that did the activity
@property (nonatomic, strong, readonly) PFUser *activeplayer;

/// Array of the users that liked the activity
@property (nonatomic, strong) NSArray *likeUsers;


/// Like button

@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) IBOutlet UILabel *ActivityLabel;

//all other images

@property (strong, nonatomic) IBOutlet PFImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UIButton *userButton;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;




/*! @name Delegate */
@property (nonatomic, strong) id<ActivityDeatailsHeaderCellDelegate> delegate;

+ (CGRect)rectForView;

- (id)initWithFrame:(CGRect)frame activity:(PFObject*)anActivity;
- (id)initWithFrame:(CGRect)frame activity:(PFObject*)anActivity activeplayer:(PFUser*)anActivity likeUsers:(NSArray*)theLikeUsers;

- (void)setLikeButtonState:(BOOL)selected;
- (void)reloadLikeBar;
@end

/*!
 The protocol defines methods a delegate of a ActivityDeatailsHeaderCell should implement.
 */
@protocol ActivityDeatailsHeaderCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the activeplayer's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the activeplayer
 */
- (void)activityDetailsHeaderCell:(ActivityDeatailsHeaderCell *)cellView didTapUserButton:(UIButton *)button user:(PFUser *)user;


@end
