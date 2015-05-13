//
//  CommentCell.h
//  Iconic
//
//  Created by Mike Suprovici on 1/13/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface CommentCell : PFTableViewCell





@property (strong, nonatomic) IBOutlet UITextField *commentField;

@end

