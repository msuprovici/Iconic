//
//  CustomPFSignUpViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 6/5/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
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
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconicLogo@2x.png"]]];
    
    
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
    self.signUpView.usernameField.placeholder = @"Username (at least 4 charachters)";
    
    self.signUpView.passwordField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.signUpView.passwordField setTextColor:PNWeiboColor];
    [self.signUpView.passwordField setBackgroundColor:PNHealYellow];
     self.signUpView.passwordField.placeholder = @"Password (at least 4 charachters)";
    
    
    self.signUpView.emailField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [self.signUpView.emailField setTextColor:PNWeiboColor];
    [self.signUpView.emailField setBackgroundColor:PNHealYellow];
    
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpButton@2x.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpButton@2X.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];


    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements

    [self.signUpView.signUpButton setFrame:CGRectMake(((self.view.frame.size.width - (self.view.frame.size.width - 30))/2), 2.1*(self.view.frame.size.height/3), (self.view.frame.size.width - 30), 45.0)];

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
