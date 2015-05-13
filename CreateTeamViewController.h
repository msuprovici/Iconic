//
//  CreateTeamViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 10/20/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface CreateTeamViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *teamNameField;

@property (strong, nonatomic) IBOutlet UITextField *dailyStepsGoal;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *createTeamActivityIndicator;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *addLogoActivityIndicator;

@property (strong, nonatomic) IBOutlet UIButton *createTeam;

@property (strong, nonatomic) IBOutlet UIImageView *addTeamLogo;

@property (strong, nonatomic) IBOutlet UIButton *addTeamLogoButton;

- (IBAction)addTeamLogoButtonPressed:(id)sender;


- (IBAction)createTeamAction:(id)sender;

-(void)initWithLeague:(PFObject*)aLeague;
@property (nonatomic, strong) PFObject *league;

@end
