//
//  ActivityHeaderCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/14/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "TTTTimeIntervalFormatter.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef enum {
    ActivityHeaderButtonsNone = 0,
    ActivityHeaderButtonsLike = 1 << 0,
    ActivityHeaderButtonsComment = 1 << 1,
    ActivityHeaderButtonsUser = 1 << 2,
    
    ActivityHeaderButtonsDefault = ActivityHeaderButtonsLike | ActivityHeaderButtonsComment | ActivityHeaderButtonsUser
} ActivityHeaderButtons;

@protocol ActivityHeaderCellDelegate;


@interface ActivityHeaderCell : UITableViewCell



/*! @name Creating Activity Header View */
/*!
 Initializes the view with the specified interaction elements.
 @param buttons A bitmask specifying the interaction elements which are enabled in the view
 */
- (id)initWithFrame:(CGRect)frame buttons:(ActivityHeaderButtons)otherButtons;

/// The activity associated with this view
@property (nonatomic,strong) PFObject *activity;

/// The bitmask which specifies the enabled interaction elements in the view
@property (nonatomic, readonly, assign) ActivityHeaderButtons buttons;

/*! @name Accessing Interaction Elements */

/// The Like Activity button
//@property (nonatomic,readonly) UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;

/// The Comment On Activity button
//@property (nonatomic,readonly) UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;

/*! @name Delegate */
@property (nonatomic,weak) id <ActivityHeaderCellDelegate> delegate;

/*! @name Modifying Interaction Elements Status */

/*!
 Configures the Like Button to match the given like status.
 @param liked a BOOL indicating if the associated activity is liked by the user
 */
- (void)setLikeStatus:(BOOL)liked;

/*!
 Enable the like button to start receiving actions.
 @param enable a BOOL indicating if the like button should be enabled.
 */
- (void)shouldEnableLikeButton:(BOOL)enable;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet UIButton *userButton;

@property (strong, nonatomic) IBOutlet PFImageView *avatarImageView;

@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;



@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end


/*!
 The protocol defines methods a delegate of a ActivityHeaderCell should implement.
 All methods of the protocol are optional.
 */
@protocol ActivityHeaderCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)activityHeaderCell:(ActivityHeaderCell *)activityHeaderCell didTapUserButton:(UIButton *)button user:(PFUser *)user;

/*!
 Sent to the delegate when the like activity button is tapped
 @param activity the PFObject for the activity that is being liked or disliked
 */
- (void)activityHeaderCell:(ActivityHeaderCell *)activityHeaderCell didTapLikeActivityButton:(UIButton *)button activity:(PFObject *)activity;

/*!
 Sent to the delegate when the comment on activity button is tapped
 @param activity the PFObject for the activity that will be commented on
 */
- (void)activityHeaderCell:(ActivityHeaderCell *)activityHeaderCell didTapCommentOnActivityButton:(UIButton *)button activity:(PFObject *)activity;




@end




