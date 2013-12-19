//
//  MenuViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/15/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface SWUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *profileName;



@end

@interface MenuViewController : UITableViewController
{
    
    NSArray *playerProfile;
    
}


@end
