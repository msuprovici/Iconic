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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initWithAchievment:(PFObject *)anAchievment
{
    self.achievment = anAchievment;
   
//    NSLog(@"self.achievment: %@", self.achievment);
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
}


- (IBAction)shareButtonPressed:(id)sender {
}
@end
