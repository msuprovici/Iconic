//
//  TeamCell.h
//  Iconic
//
//  Created by Mike Suprovici on 2/6/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface TeamCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *teamRecord;
@property (strong, nonatomic) IBOutlet PFImageView *teamLogo;


@end
