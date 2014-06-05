//
//  LogInViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 11/12/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "CustomPFSignUpViewController.h"
#import "CustomPFLoginViewController.h"
#import "PNColor.h"
#import <CoreMotion/CoreMotion.h>

@interface LogInViewController ()<UIScrollViewDelegate>

@property NSUInteger currentIndex;


@property (nonatomic, strong) CMStepCounter *cmStepCounter;

@end

@implementation LogInViewController

@synthesize scrollView;
@synthesize pageControl;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentIndex = 0;
    
    self.Login.hidden = YES;
    self.SignUp.hidden = YES;
    
    // Create the data model
    _pageTitles = @[@"Title 1", @"Title 2", @"Title 3"];
    _pageSubTitles = @[@"Subtitle 1", @"Subtitle 2", @"Subtitle 3"];
    _pageImages = @[@"Walkthrough1.png", @"Walkthrough2.png", @"Walkthrough3.png"];
    
    self.mainTitle.text =[NSString stringWithFormat:@"%@",[_pageTitles objectAtIndex: 0]];
    self.subTitle.text =[NSString stringWithFormat:@"%@",[_pageSubTitles objectAtIndex: 0]];


    
    for (int i = 0; i < [_pageImages count]; i++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        //set background image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:[_pageImages objectAtIndex:i]];
        
      
         [self.scrollView addSubview:imageView];
        

    
    }
    //Set the content size of our scrollview according to the total width of our imageView objects.
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [_pageImages count], scrollView.frame.size.height);
    
    
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
   
        

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}


#pragma mark - Parse Login & SignUps actions

//Skip Login
- (IBAction)skipLogin:(id)sender {
    
    //create a new anonymous user and create an id on the parse server
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] saveInBackground];
 
}

//Login
- (IBAction)userLogin:(id)sender {
    
    // Create the log in view controller
    CustomPFLogInViewController *logInViewController = [[CustomPFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
//    logInViewController.facebookPermissions = @[@"friends_about_me"];
    logInViewController.fields = PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword  ;

//    logInViewController.fields = PFLogInFieldsFacebook |  PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton ;
    
    
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    

    
}
- (IBAction)signUpAction:(id)sender {
    
    // Create the sign up view controller
    CustomPFSignUpViewController *signUpViewController = [[CustomPFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    signUpViewController.fields =  PFSignUpFieldsDefault   ;
    
    // Present the log in view controller
    [self presentViewController:signUpViewController animated:YES completion:NULL];


    
    
}
#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
//    NSLog(@"Failed to log in...");
    [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
//    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
//    NSLog(@"User dismissed the signUpViewController");
}



#pragma mark - Page Control Methods


- (IBAction)startWalkthrough:(id)sender {
    
     CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    float newPosition = scrollView.contentOffset.x+pageWidth;
    CGRect toVisible = CGRectMake(newPosition, 0, pageWidth, pageHeight);
    [scrollView scrollRectToVisible:toVisible animated:YES];
    
    if (self.currentIndex < self.pageSubTitles.count -1 ) {
        
//          NSLog(@"CurrentIndex on Button Press  %lu", (unsigned long)self.currentIndex);
        
        self.currentIndex = self.currentIndex+1;
        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
    }
    
    [self.pageControl setCurrentPage:self.currentIndex];
    
    self.mainTitle.text =[NSString stringWithFormat:@"%@",[_pageTitles objectAtIndex:self.currentIndex]];
    self.subTitle.text =[NSString stringWithFormat:@"%@",[_pageSubTitles objectAtIndex:self.currentIndex]];
   
    if (self.currentIndex == 2) {
        
        [self.startWalkthroughButton setTitle: @"Grant Motion Permission" forState: UIControlStateNormal];
    }

    
    
    
    if([self.startWalkthroughButton.titleLabel.text  isEqualToString: @"Grant Motion Permission"])
    {
        
        //show login options once the person selected the grant permission label
        self.Login.hidden = NO;
        self.SignUp.hidden = NO;
        self.startWalkthroughButton.hidden = YES;
        
        
        //initialize CMStepCounter to ask the user for permission
        self.cmStepCounter = [[CMStepCounter alloc] init];
        
        if([CMStepCounter isStepCountingAvailable])
        {
            NSLog(@"CMStepCounter is Avaialble");
        }
        else{
             NSLog(@"CMStepCounter is NOT Avaialble");
        }
        
        
        
         }
    
    }


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    uint page = sender.contentOffset.x / pageWidth;
    
    
    self.currentIndex = page;
    [self.pageControl setCurrentPage:page];
    
    if (page == 2) {
        [self.startWalkthroughButton setTitle: @"Grant Motion Permission" forState: UIControlStateNormal];
    }
    
    else{
        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
    }

    
    self.mainTitle.text =[NSString stringWithFormat:@"%@",[_pageTitles objectAtIndex: page]];
    self.subTitle.text =[NSString stringWithFormat:@"%@",[_pageSubTitles objectAtIndex: page]];
    

}





@end
