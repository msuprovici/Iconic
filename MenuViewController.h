//
//  MenuViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/15/13.
//  Copyright (c) 2013 Iconic All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>



@interface SWUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *profileName;

@property (strong, nonatomic) IBOutlet PFImageView *profilePhoto;


@end

@interface MenuViewController : UITableViewController
{
    
    NSArray *playerProfile;
    
}


@end
