//
//  PlayerCommentCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/17/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PlayerCommentCell : PFTableViewCell

{
    NSUInteger horizontalTextSpace;
    id _delegate;
}

@property (nonatomic, strong) id delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;



//Cell's buttons and views
@property (strong, nonatomic) IBOutlet UIButton *nameButton;

@property (strong, nonatomic) IBOutlet PFImageView *avatarImageView;


@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


/*! Setters for the cell's content */
- (void)setContentText:(NSString *)contentString;
- (void)setDate:(NSDate *)date;




@end


@protocol PlayerCommentCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(PlayerCommentCell *)cellView didTapUserButton:(PFUser *)aUser;

@end