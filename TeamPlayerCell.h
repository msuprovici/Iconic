//
//  TeamPlayerCell.h
//  Iconic
//
//  Created by Mike Suprovici on 2/5/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface TeamPlayerCell : PFTableViewCell


//Cell fileds

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;




@property (strong, nonatomic) IBOutlet UILabel *playerName;

@property (strong, nonatomic) IBOutlet PFImageView *playerPhoto;


@end
