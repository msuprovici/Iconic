//
//  CreateLeagueViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 10/20/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateLeagueViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *leagueNameTextField;

@property (strong, nonatomic) IBOutlet UIPickerView *numberOfTeamsInLeague;

@property (strong, nonatomic) NSArray *totalTeamsInLeagueOptions;

@property (strong, nonatomic) IBOutlet UIPickerView *minimumXP;

@property (strong, nonatomic) NSArray *minimumXPValues;

@property (strong, nonatomic) IBOutlet UIButton *createLeague;

- (IBAction)createLeagueButtonPressed:(id)sender;

@property  NSInteger numberOfTeams;

@property  NSInteger selectedMinimumXP;

@end
