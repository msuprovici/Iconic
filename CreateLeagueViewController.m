//
//  CreateLeagueViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 10/20/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "CreateLeagueViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import "CalculatePoints.h"
#import "Constants.h"
#import "Amplitude.h"

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
 
    [Amplitude logEvent:@"Create League: Add league pressed"];
    if ([self.leagueNameTextField.text length] != 0) {
        
        [self.leagueAddedActivityIndicator startAnimating];
        
        //check if legue already exists
        NSString *leagueNameEntered = [NSString stringWithFormat:@"%@",self.leagueNameTextField.text];
        
        PFQuery * query = [PFQuery queryWithClassName:kLeagues];
        [query whereKey:@"league" equalTo:leagueNameEntered];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            NSLog(@"objects.count: %lu", (unsigned long)objects.count);

            //if object with matching league name does not exist save the object
            if(objects.count == 0)
            {
        
                
                
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
                        
                        NSString *leagueName = [NSString stringWithFormat:@"New league: %@",self.leagueNameTextField.text];

                        
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:leagueName
                                                              message:@""
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction
                                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       [Amplitude logEvent:@"Create League: League added"];
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
                        
                        

                        NSLog(@"Failed to save league object: %@", error);
                    }
                    
                }];
            }
            else
            {
                
                //let alert the user to use a different league name
                [self.leagueAddedActivityIndicator stopAnimating];
                
                
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"This league already exists"
                                                      message:@"Please use a different name"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               //                                                       NSLog(@"OK action");
                                           }];
                
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        
        }];
        
        
        

        }
        else
        {   //alert use to enter a league name
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Please name your league"
                                                  message:@""
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
//                                           NSLog(@"OK action");
                                       }];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }

    [self.leagueNameTextField resignFirstResponder];

    

}
@end
