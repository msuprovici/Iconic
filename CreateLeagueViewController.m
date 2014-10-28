//
//  CreateLeagueViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 10/20/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "CreateLeagueViewController.h"
#import <Parse/Parse.h>
#import "CalculatePoints.h"

@interface CreateLeagueViewController ()

@property (nonatomic, assign) id currentResponder;

@end

@implementation CreateLeagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //gesture recognizer to dismiss keyboard when tapping outside of it
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    
    //set arryas for pickers
    self.totalTeamsInLeagueOptions = @[@"2", @"4"];
    
    self.minimumXPValues = @[@"0", @"1", @"2", @"3", @"4", @"5"];
    
    self.numberOfTeams = [@2 integerValue];
    
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


#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual: self.numberOfTeamsInLeague]){
        
    return self.totalTeamsInLeagueOptions.count;
        
    }
    
    else if([pickerView isEqual: self.minimumXP]){
        
        return self.minimumXPValues.count;
    }
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    if([pickerView isEqual: self.numberOfTeamsInLeague]){
        
        return self.totalTeamsInLeagueOptions[row];;
        
    }
    
    else if([pickerView isEqual: self.minimumXP]){
        
        return self.minimumXPValues[row];
    }
    else
        return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    if([pickerView isEqual: self.numberOfTeamsInLeague]){
        
        self.numberOfTeams = [[self.totalTeamsInLeagueOptions objectAtIndex:row]integerValue];
        
    }
    
    if([pickerView isEqual: self.minimumXP]){
        
        self.selectedMinimumXP = [[self.minimumXPValues objectAtIndex:row]integerValue];
    }
    
    
   
}

#pragma mark Create League button

- (IBAction)createLeagueButtonPressed:(id)sender {
    
    
    
    if ([self.leagueNameTextField.text length] != 0) {
        
        [self.leagueAddedActivityIndicator startAnimating];
    
    PFObject *league = [PFObject objectWithClassName:@"league"];
    
    [league setObject:self.leagueNameTextField.text forKey:@"league"];
    [league setObject:@"New" forKey:@"categories"];
    league[@"numberOfTeams"] = @(self.numberOfTeams);
    league[@"totalNumberOfTeams"] = @(0);
    league[@"Level"] = @(self.selectedMinimumXP);
        
    [league setObject:[PFUser currentUser] forKey:@"leagueCreator"];
   
    
    
    
    [league saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //Refresh view
            //set text view
            [self.leagueAddedActivityIndicator stopAnimating];
            
            NSString *teamName = [NSString stringWithFormat:@"New league: %@",self.leagueNameTextField.text];

            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:teamName
                                                  message:@""
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
//                                           NSLog(@"OK action");
                                           [self performSegueWithIdentifier:@"unwindToLeagues" sender:self];
                                       }];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            self.leagueNameTextField.text = @"";
            
            
//            NSLog(@"League name saved");
            CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
            [calculatePointsClass migrateLeaguesToCoreData];
            
        } else {
            
            [self.leagueAddedActivityIndicator stopAnimating];
            
            NSString *errorMessage = [NSString stringWithFormat:@"%@",[error userInfo][@"error"]];
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:errorMessage
                                                  message:@"Please use a different name"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];

            NSLog(@"Failed to save object: %@", error);
        }
        
    }];
        
    }
    else
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Please name your team"
                                              message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    [self.leagueNameTextField resignFirstResponder];

}
@end