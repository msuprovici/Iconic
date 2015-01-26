//
//  CustomPFLogInViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 6/5/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "CustomPFLogInViewController.h"
#import "PNColor.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "CalculatePoints.h"

@interface CustomPFLogInViewController ()

@end

@implementation CustomPFLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //customize log-in.  for more options go here https://parse.com/tutorials/login-and-signup-views
    [self.logInView setBackgroundColor: [UIColor whiteColor]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconicLogoBlack.png"]]];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordForgottenButton.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.logInButton.titleLabel.layer;
    layer.shadowOpacity = 0.0;
    
    //set button text
    self.logInView.logInButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.logInView.logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    // Set field text color
    self.logInView.usernameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.logInView.usernameField setTextColor:PNWeiboColor];
     [self.logInView.usernameField setBackgroundColor:PNHealYellow];
    
//    [self.logInView.logInButton setTitle:@"Test!" forState:UIControlStateNormal];
//    [self.logInView.facebookButton setTitle:@"Test!" forState:UIControlStateNormal];
//    self.logInView.facebookButton.titleLabel.text = @"Sign Up With Facebook";
//    self.logInView.signUpButton.titleLabel.text = @"Sign Up With Email";
    
    
    
    self.logInView.passwordField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.logInView.passwordField setTextColor:PNWeiboColor];
    [self.logInView.passwordField setBackgroundColor:PNHealYellow];
    
    self.logInView.passwordForgottenButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [self.logInView.passwordForgottenButton.titleLabel setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
  

}

//-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
//{
//    BOOL linkedWithFacebook = [PFFacebookUtils isLinkedWithUser:user];
//    
//    if(linkedWithFacebook)
//    {
//        NSLog(@"account linked with Facebook");
//        CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
//        [calculatePointsClass loadFacebookUserData];
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
