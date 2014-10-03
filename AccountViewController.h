//
//  AccountViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/31/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AccountViewController : PFQueryTableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet PFImageView *myProfilePhoto;

@property (strong, nonatomic) IBOutlet UILabel *myUserName;

@property (strong, nonatomic) IBOutlet UILabel *myAvgSteps;



@property (strong, nonatomic) IBOutlet UILabel *myXPLevel;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)selectPhoto:(UIButton *)sender;


@end
