//
//  CustomPFLogInViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 6/5/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import <ParseUI/PFSignUpViewController.h>
#import <ParseUI/PFLogInViewController.h>

@interface CustomPFLogInViewController : PFLogInViewController

@property (strong, nonatomic) UIImageView * fieldsBackground;

@end
