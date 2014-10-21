//
//  CreateTeamViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 10/20/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateTeamViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *teamNameField;

@property (strong, nonatomic) IBOutlet UITextField *dailyStepsGoal;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *createTeamActivityIndicator;


@property (strong, nonatomic) IBOutlet UIButton *createTeam;

- (IBAction)createTeamAction:(id)sender;

-(void)initWithLeague:(PFObject*)aLeague;
@property (nonatomic, strong) PFObject *league;

@end
