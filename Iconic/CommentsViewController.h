//
//  CommentsViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/13/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//
#import "CommentCell.h"
#import "PlayerCommentCell.h"
#import "CommentCell.h"
#import <Parse/Parse.h>
#import "ActivityDeatailsHeaderCell.h"

@interface CommentsViewController : PFQueryTableViewController <UITextFieldDelegate, UIActionSheetDelegate, ActivityDeatailsHeaderCellDelegate, PlayerCommentCellDelegate>

@property (nonatomic, strong) PFObject *activity;

//- (id)initWithActivity:(PFObject*)anActivity;

-(void)initWithActivity:(PFObject*)anActivity;

@end
