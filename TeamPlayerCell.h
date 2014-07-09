//
//  TeamPlayerCell.h
//  Iconic
//
//  Created by Mike Suprovici on 2/5/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TeamPlayerCell : PFTableViewCell


//Cell fileds

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;

@property (strong, nonatomic) IBOutlet PFImageView *playerPhoto;


@property (strong, nonatomic) IBOutlet UILabel *playerName;



@end
