//
//  CustomPFLogInViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 6/5/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "CustomPFLogInViewController.h"
#import "LogInViewController.h"
#import "PNColor.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

//#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "CalculatePoints.h"
#import "CustomPFSignUpViewController.h"
#import "Amplitude.h"

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
   
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconicLogo@2x.png"]]];
    
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
//    self.logInView.logInButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
//    [self.logInView.logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
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
    
//    self.logInView.passwordForgottenButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
//    [self.logInView.passwordForgottenButton.titleLabel setTextColor:[UIColor colorWithRed:250.0f/255.0f green:0.0f/255.0f blue:33.0f/255.0f alpha:1.0]];
    
    
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@"ForgotPasswordButton@2x.png"] forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@"ForgotPasswordButton@2X.png"] forState:UIControlStateHighlighted];
    [self.logInView.passwordForgottenButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpButton@2x.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpButton@2X.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    
    
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"LogInButton@2x.png"] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"LogInButton@2X.png"] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.logInButton setTitle:@"" forState:UIControlStateHighlighted];
    
//    // Add login field background
    self.fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclaimerText@2x.png"]];
    [self.logInView insertSubview:self.fieldsBackground atIndex:1];
    
  
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements

//    [self.logInView.signUpButton setFrame:CGRectMake(16.0f, 510.0f, 289.0, 40.0)];
    [self.logInView.signUpButton setFrame:CGRectMake(((self.view.frame.size.width - (self.view.frame.size.width - 30))/2), 2.8*(self.view.frame.size.height/4), (self.view.frame.size.width - 30), 45.0)];
//    [self.logInView.logInButton setFrame:CGRectMake(16.0f, 300.0f, 288.0f, 40.0f)];
    
     [self.logInView.logInButton setFrame:CGRectMake(((self.view.frame.size.width - (self.view.frame.size.width - 30))/2), (self.view.frame.size.height/1.9), (self.view.frame.size.width - 30), 45.0)];
    
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(((self.view.frame.size.width - 85)/2), (self.view.frame.size.height/1.8)+50, 85.0, 12.0)];
    [self.fieldsBackground setFrame:CGRectMake(((self.view.frame.size.width - 300)/2), (self.view.frame.size.height - 45), 300, 24.0)];
}


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
