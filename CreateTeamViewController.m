//
//  CreateTeamViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 10/20/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "CreateTeamViewController.h"
#import <Parse/Parse.h>
#import "TeamsViewController.h"
#import "Constants.h"

@interface CreateTeamViewController ()

@property (nonatomic, assign) id currentResponder;

@end

@implementation CreateTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //gesture recognizer to dismiss keyboard when tapping outside of it
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
}

//get the league passed from the leagues view controller
-(void)initWithLeague:(PFObject *)aLeague
{
    self.league = aLeague;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    return YES;
}


//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    if ([textField.text length] != 0) {
//
//            }
//
//    textField.text = nil;
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

//Implement resignOnTap:

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


- (IBAction)createTeamAction:(id)sender {
    
    NSLog(@"createTeam Pressed ");
//    if ([self.teamNameField.text length] != 0) {
    
        NSString *leagueName = [NSString stringWithFormat:@"%@",[self.league objectForKey:kLeagues]];
        
        NSNumber *leagueLevel = [self.league objectForKey:@"Level"];
        NSString *stepGoalString = [NSString stringWithFormat:@"%@",self.dailyStepsGoal.text];
        int stepGoal = [stepGoalString intValue];
    
    
        PFObject *team = [PFObject objectWithClassName:@"TeamName"];
        
        [team setObject:self.teamNameField.text forKey:@"teams"];
        [team setObject:@(stepGoal) forKey:@"stepsGoal"];
        [team setObject:leagueName forKey:@"league"];
        [team setObject:leagueLevel forKey:@"leagueLevel"];
    
        [team setObject:[PFUser currentUser] forKey:@"teamCreator"];
        
        
        
        
        
        [team saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //Refresh view
                NSLog(@"team name saved");
                
            } else {
                NSLog(@"Failed to save object: %@", error);
            }
            
        }];
        
//    }
    
    [self.teamNameField resignFirstResponder];
    [self.dailyStepsGoal resignFirstResponder];
    
}
    
@end
