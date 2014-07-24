//
//  CustomPFSignUpViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 6/5/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "CustomPFSignUpViewController.h"
#import "PNColor.h"

@interface CustomPFSignUpViewController ()

@end

@implementation CustomPFSignUpViewController

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
    
    
    //customize sign-up.  for more options go here https://parse.com/tutorials/login-and-signup-views
    
    //set backbround color
    [self.signUpView setBackgroundColor: [UIColor whiteColor]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconicLogoBlack.png"]]];
    
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.signUpView.signUpButton.titleLabel.layer;
    layer.shadowOpacity = 0.0;
    
    //set button text
    self.signUpView.signUpButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.signUpView.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    // Set field text color
    self.signUpView.usernameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.signUpView.usernameField.textColor = PNWeiboColor;
    [self.signUpView.usernameField setBackgroundColor:PNHealYellow];
    
    self.signUpView.passwordField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.signUpView.passwordField setTextColor:PNWeiboColor];
    [self.signUpView.passwordField setBackgroundColor:PNHealYellow];
    
    
    self.signUpView.emailField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.signUpView.emailField setTextColor:PNWeiboColor];
    [self.signUpView.emailField setBackgroundColor:PNHealYellow];


    
    
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
