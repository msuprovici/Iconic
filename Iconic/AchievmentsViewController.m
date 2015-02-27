//
//  AchievmentsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/23/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "AchievmentsViewController.h"

@interface AchievmentsViewController ()

@end

@implementation AchievmentsViewController

-(void)initWithAchievment:(PFObject *)anAchievment
{
    self.achievment = anAchievment;
   
   
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"self.achievment: %@", self.achievment);
//    NSLog(@"achievment name: %@", [self.achievment objectForKey:@"achievmentName"]);
    self.achievmentName.text = [self.achievment objectForKey:@"achievmentName"];
    self.achivmentDetails.text = [self.achievment objectForKey:@"achievmentDescription"];
    
    //if this is a league championship achievment use local image
    if([[self.achievment objectForKey:@"achievmentType"] isEqualToString:@"LeagueChampion"])
       {
           [self.achievmentImage setImage:[UIImage imageNamed:@"achievment_test.png"]];
       }

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

- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)shareButtonPressed:(id)sender {
}
@end
