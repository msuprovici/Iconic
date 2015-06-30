//
//  CreateTeamViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 10/20/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "CreateTeamViewController.h"
#import <Parse/Parse.h>
#import "TeamsViewController.h"
#import "Constants.h"
#import "CalculatePoints.h"
#import "Amplitude.h"

@interface CreateTeamViewController ()

@property (nonatomic, assign) id currentResponder;

@property (nonatomic, assign) NSUInteger teamNumber;

@property (nonatomic, retain) PFFile* imageFile;

@property BOOL didCreateTeam;

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
    
    //NSLog(@"createTeam Pressed ");
    if ([self.teamNameField.text length] != 0) {
        
        self.createTeamActivityIndicator.hidden = NO;
        [self.createTeamActivityIndicator startAnimating];
        
        
        [Amplitude logEvent:@"Create team: Add team pressed"];
        
        
    
        NSString *leagueName = [NSString stringWithFormat:@"%@",[self.league objectForKey:kLeagues]];
        
        //increment the number of teams in league
        PFQuery * query = [PFQuery queryWithClassName:kLeagues];
        [query whereKey:@"league" equalTo:leagueName];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if(!error)
            {
                

                
                for (PFObject * object in objects)
                {
                   
                    
                    int teamsInLeague = [[object objectForKey:@"totalNumberOfTeams"]intValue];
                    int maximumTeamsInLeague = [[object objectForKey:@"numberOfTeams"]intValue];
                    
                    //adding 1 because team # can't be 0 for round robing function
                    self.teamNumber = [[object objectForKey:@"totalNumberOfTeams"]intValue]+1;
                    
//                    NSLog(@"teamsInLeague: %d",teamsInLeague);
//                    NSLog(@"maximumTeamsInLeague: %d",maximumTeamsInLeague);
                    
                    //send nsnotificaiton to teams view controller to update create button
                    if(teamsInLeague + 1 == maximumTeamsInLeague)
                    {
                        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                        [nc postNotificationName:@"LeagueFull" object:self];
                        
                        //set boolean for league is full on parse server
                        [object setValue:[NSNumber numberWithBool:YES] forKey:@"leagueFull"];
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if(!error)
                            {
//                                NSLog(@"league object saved");
                            }
                        }];
                    }
                    
                    if (teamsInLeague < maximumTeamsInLeague) {
                        
//                        NSLog(@"teamsInLeague < maximumTeamsInLeague");
                        
                        [object incrementKey:@"totalNumberOfTeams"];
                        
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
////                                NSLog(@"league  saved");
                                
                                //create a team
                                
                                NSString *teamNumberString = [NSString stringWithFormat:@"%lu",(unsigned long)self.teamNumber];
                                
                                NSNumber *leagueLevel = [self.league objectForKey:@"Level"];
                                NSString *stepGoalString = [NSString stringWithFormat:@"%@",self.dailyStepsGoal.text];
                                
                                int stepGoal = [stepGoalString intValue];
                                
                                
                                
                                
                                //add 0s to scoreweek array so that it matches the week day
                                NSCalendar *gregorian=[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
                                [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
                               
                                NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]];//yesterday's date
                                
//                                NSLog(@"comps %@", comps);

                                NSMutableArray *scoreWeek = [[NSMutableArray alloc] init];
                                //if it's monday don't insert an object
                                if([comps weekday] == 1)
                                {
//                                    [scoreWeek addObject:[]];
                                }
                                else
                                {
                                    //add 0s to the score week array
                                    //array is always 1 day behind yesterday
                                    for(int i = 0; i < [comps weekday]-1; i++)
                                    {
                                        [scoreWeek addObject:@(0)];
                                    }
                                }
                                
                                
                                
                                
                                //create team object

                                PFObject *team = [PFObject objectWithClassName:@"TeamName"];
                                
                                [team setObject:self.teamNameField.text forKey:@"teams"];
                                [team setObject:@(stepGoal) forKey:@"stepsGoal"];
                                [team setObject:leagueName forKey:@"league"];
                                [team setObject:leagueLevel forKey:@"leagueLevel"];
                                [team setObject:@(self.teamNumber) forKey:@"teamnumber"];
                                [team setObject:teamNumberString forKey:@"teamnumberString"];
                                [team setObject:@0 forKey:@"score"];
                                [team setObject:@0 forKey:@"scoretoday"];
                                [team setObject:scoreWeek forKey:@"scoreweek"];
                                [team setObject:@1 forKey:@"round"];
                                [team setObject:@0 forKey:@"wins"];
                                [team setObject:@0 forKey:@"losses"];
                                [team setObject:@(maximumTeamsInLeague) forKey:@"numberOfTeamsInLeague"];
                                [team setObject:[NSNumber numberWithBool:FALSE] forKey:@"leadChange"];
                                [team setObject:[NSNumber numberWithBool:FALSE] forKey:@"teamLeading"];
                                [team setObject:[NSNumber numberWithBool:FALSE] forKey:@"sentSaturdayNotification"];
                                
                                [team setObject:[PFUser currentUser] forKey:@"teamCreator"];
                                
                                NSString *pushChanelName = [NSString stringWithFormat:@"%@", self.teamNameField.text];
                                
                                //save PushChannel
                                //Parse push notification channels must not contain spaces
                                NSRange whiteSpaceRange = [pushChanelName rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
                                if (whiteSpaceRange.location != NSNotFound) {
                                    
                                    
                                    //            NSLog(@"Found whitespace");
                                    NSString *chanelNameNoSpaces = [pushChanelName stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    
                                    [team setObject:chanelNameNoSpaces forKey:@"pushChannel"];
                                }
                                else
                                {
                                    
                                    [team setObject:pushChanelName forKey:@"pushChannel"];
                                }
                                
                                
                                
                                
                                if(self.didCreateTeam == YES)
                                {
                                [team setObject: self.imageFile forKey:@"teamAvatar"];
                                }
                                
                                //when the last team in the league is added - generate a schedule
                                if(teamsInLeague + 1 == maximumTeamsInLeague)
                                {
                                    
                                    //send the league name & number of teams to league schedule function
                                    NSMutableDictionary * params = [NSMutableDictionary new];
                                    params[@"numberOfTeams"] = @(maximumTeamsInLeague);
                                    params[@"league"] = leagueName;
                                    
                                    
                                    //downlaod team objects and send them to cloud function
                                    
                                    
                                    
                                    [PFCloud callFunctionInBackground:@"roundRobin"
                                                       withParameters:params
                                                                block:^(NSString *result, NSError *error) {
                                                                    if (!error) {
                                                                       //NSLog(@"%@", result);
                                                                    }
                                                                }];


                                }
                                
                                
                                
                                //save team
                                
                                [team saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        
                                        
                                        //Show alert
                                        //                NSLog(@"team name saved");
                                        [self.createTeamActivityIndicator stopAnimating];
                                        
                                        NSString *teamName = [NSString stringWithFormat:@"New team: %@",self.teamNameField.text];
                                        
                                        UIAlertController *alertController = [UIAlertController
                                                                              alertControllerWithTitle:teamName
                                                                              message:@""
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction *okAction = [UIAlertAction
                                                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                   style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action)
                                                                   {
                                                                       [Amplitude logEvent:@"Create team: Team added"];
                                                                      //segue back to teams in league
                                                                       [self performSegueWithIdentifier:@"unwindToTeams" sender:self];
                                                                   }];
                                        
                                        [alertController addAction:okAction];
                                        [self presentViewController:alertController animated:YES completion:nil];
                                        
                                        
                                        self.teamNameField.text = @"";
                                        self.dailyStepsGoal.text = @"";
                                        
                                        CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
                                        [calculatePointsClass migrateLeaguesToCoreData];
   
                                        
                                    } else {
                                                                                
                                        NSLog(@"Failed to save object: %@", error);
                                        
                                        

                                    }
                                    
                                }];
                                
                                
                                
                                //add info to activity feed
                                
                                PFObject *activity = [PFObject objectWithClassName:@"Activity"];
                                [activity setObject:[PFUser currentUser] forKey:@"user"];
                                [activity setObject:team forKey:@"toTeam"];
                                
                                
                                NSString * activityString = [NSString stringWithFormat:@"Created new team: %@",self.teamNameField.text];
                                [activity setObject:activityString forKey:@"activityString"];
                                [activity saveInBackground];
                                

                            }
                            else
                            {
                                NSLog(@"increment total number of teams failed");
                            }
                        }];
                        
                    }
                    
                    
                }
                
            }
            else
            {
                NSLog(@"leage query error");
                
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
    
    [self.teamNameField resignFirstResponder];
    [self.dailyStepsGoal resignFirstResponder];
    
}


#pragma mark - Add Player Photo

- (IBAction)addTeamLogoButtonPressed:(id)sender {

    [Amplitude logEvent:@"Create Team: Add Logo"];
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"How would you like to set your logo?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take Picture",
                            @"Choose Picture",
                            
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self showCamera];
                    break;
                case 1:
                    [self showPicker];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)showCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
-(void)showPicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    //start activity indicator
//    self.addLogoActivityIndicator.hidden = NO;
//    [self.addLogoActivityIndicator startAnimating];
//    
    //save photo to parse and display
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    self.imageFile = [PFFile fileWithName:@"team_place_holder.png" data:imageData];
    self.didCreateTeam = YES;
    
//    //stop activity indicator
//    [self.addLogoActivityIndicator stopAnimating];
//    self.addLogoActivityIndicator.hidden = YES;
//    
    
    
    
    self.addTeamLogo.image = chosenImage;
   
//    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            if (succeeded) {
//                
//                //stop activity indicator
//                [self.addLogoActivityIndicator stopAnimating];
//                
//                self.addTeamLogo.image = chosenImage;
//                
//                
//                
//                [team setObject:imageFile forKey:@"teamAvatar"];
//                
//                
//                
//                [self.view setNeedsDisplay];
//            }
//        } else {
//            // Handle error
//        }
//    }];
//    
    //    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
     [self.view setNeedsDisplay];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
