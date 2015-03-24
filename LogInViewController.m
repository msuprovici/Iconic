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
#import "Amplitude.h"
#import "CalculatePoints.h"
#import "Intercom.h"
#import "Heap.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LogInViewController ()<UIScrollViewDelegate>

@property NSUInteger currentIndex;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) CMStepCounter *cmStepCounter;

@end

@implementation LogInViewController

@synthesize scrollView;
@synthesize pageControl;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.currentIndex = 0;
    
    self.Login.hidden = YES;
    self.SignUp.hidden = YES;
    self.separatorLine.hidden = YES;
    self.noNotifications.hidden = YES;
    
    // Create the data model
//    _pageTitles = @[@"Title 1", @"Title 2", @"Title 3"];
//    _pageSubTitles = @[@"Subtitle 1", @"Subtitle 2", @"Subtitle 3"];
    _pageImages = @[@"IconicOnboard1slice@2x.png", @"IconicOnboard2slice@2x.png", @"IconicOnboard3slice@2x.png", @"IconicOnboard4slice@2x.png", @"IconicOnboard6slice@2x.png", @"IconicOnboard7slice@2x.png", @"IconicOnboard8slice@2x.png", @"IconicOnboard9slice@2x.png"];
    
//    self.mainTitle.text =[NSString stringWithFormat:@"%@",[_pageTitles objectAtIndex: 0]];
//    self.subTitle.text =[NSString stringWithFormat:@"%@",[_pageSubTitles objectAtIndex: 0]];


    
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

//setting status bar manually
- (BOOL)prefersStatusBarHidden {
    return YES;
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
    
    
    [Amplitude logEvent:@"Onboard: LogIn selected"];
    
    // Create the log in view controller
    CustomPFLogInViewController *logInViewController = [[CustomPFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    
    
    CustomPFSignUpViewController *signUpViewController = [[CustomPFSignUpViewController alloc] init];
    
//    logInViewController.signUpController = [[CustomPFSignUpViewController alloc] init];
    
//    signUpViewController.fields =  PFSignUpFieldsDefault  ;
    
    
    
//    logInViewController.facebookPermissions = @[@"friends_about_me"];
//    logInViewController.fields = PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook  ;

    logInViewController.fields = PFLogInFieldsFacebook |  PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword  ;
    
//    logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsSignUpButton |PFLogInFieldsDismissButton  ;
    logInViewController.facebookPermissions = @[ @"public_profile", @"email" ];
    
    
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    


    
}
- (IBAction)signUpAction:(id)sender {
    
    [Amplitude logEvent:@"Onboard: SignUp selected"];
    
//    // Create the sign up view controller
//    CustomPFSignUpViewController *signUpViewController = [[CustomPFSignUpViewController alloc] init];
//    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
//    
//    signUpViewController.fields =  PFSignUpFieldsDefault  ;
//    
//    // Present the log in view controller
//    [self presentViewController:signUpViewController animated:YES completion:NULL];

    // Create the log in view controller
    CustomPFLogInViewController *logInViewController = [[CustomPFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    
    
    CustomPFSignUpViewController *signUpViewController = [[CustomPFSignUpViewController alloc] init];
    
    logInViewController.signUpController = [[CustomPFSignUpViewController alloc] init];
    
    signUpViewController.fields =  PFSignUpFieldsDefault  ;
    
    
    
    //    logInViewController.facebookPermissions = @[@"friends_about_me"];
    //    logInViewController.fields = PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook  ;
    
    //    logInViewController.fields = PFLogInFieldsFacebook |  PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton ;
    
    logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsSignUpButton |PFLogInFieldsDismissButton  ;
    logInViewController.facebookPermissions = @[ @"public_profile", @"email" ];
    
    
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];


    
    
}



#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    [Amplitude logEvent:@"Onboard: Log In successful"];
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    [calculatePointsClass migrateLeaguesToCoreData];
    [calculatePointsClass autoFollowUsers];
    
    BOOL linkedWithFacebook = [PFFacebookUtils isLinkedWithUser:user];
    
    if(linkedWithFacebook)
    {
//        NSLog(@"linkedWithFacebook");
        [calculatePointsClass loadFacebookUserData];
    }
    
    //eliminate null values for 1st time users
    [[PFUser currentUser] setObject:@0 forKey: @"steak"];
    [[PFUser currentUser] setObject:@0 forKey: @"streakLong"];
    [[PFUser currentUser] saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
    
    //create pointer to current user for push notifications
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"user"] = [PFUser currentUser];
    [currentInstallation saveInBackground];
    
   
        //set parse username as the user id in Amplitude
        NSString *userId =  [[PFUser currentUser] objectForKey:@"username"];
        [Amplitude setUserId:userId];
    
    
    //set parse username for Intercom
    [Intercom beginSessionForUserWithUserId:userId completion:nil];
    
    // set parse username for Heap
    NSDictionary* userProperties = @{
                                     @"name": userId,
                                     };
    
    [Heap identify:userProperties];

}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    
    [Amplitude logEvent:@"Onboard: LogIn failed"];
//    NSLog(@"Failed to log in...");
//    [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
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
        if (!field || field.length < 3) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Please fill out all of the information.  3 charachter minimum for Username/Password/Email", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
    [Amplitude logEvent:@"Onboard: SignUp successful"];
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    [calculatePointsClass migrateLeaguesToCoreData];
    [calculatePointsClass autoFollowUsers];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
    
    //create pointer to current user for push notifications
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
     currentInstallation[@"user"] = [PFUser currentUser];
    [currentInstallation saveInBackground];
    
    //set parse username as the user id in Amplitude
    NSString *userId =  [[PFUser currentUser] objectForKey:@"username"];
    [Amplitude setUserId:userId];
    
    //set parse username for Intercom
    [Intercom beginSessionForUserWithUserId:userId completion:nil];
    
    // set parse username for Heap
    NSDictionary* userProperties = @{
                                     @"name": userId,
                                     };
    
    [Heap identify:userProperties];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    
    [Amplitude logEvent:@"Onboard: SignUp failed"];
    
//    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    
    [Amplitude logEvent:@"Onboard: SignUp canceled"];
//    NSLog(@"User dismissed the signUpViewController");
}



#pragma mark - Page Control Methods


- (IBAction)startWalkthrough:(id)sender {
    NSLog(@"button pressed");
    UIImage * buttonImageMotion = [UIImage imageNamed:@"Grant_Motion_Permission_Button@2x.png"];
    UIImage * buttonImageNext = [UIImage imageNamed:@"NextButton@2x.png"];
    UIImage * buttonImageStart = [UIImage imageNamed:@"LetsGetStartedButton@2x.png"];
    UIImage * buttonImageYes = [UIImage imageNamed:@"YesButton@2x.png"];
    UIImage * buttonImageNo = [UIImage imageNamed:@"NahImGoodButton@2x.png"];
    UIImage * buttonJoin = [UIImage imageNamed:@"JoinButton@2x.png"];
    
     CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    float newPosition = scrollView.contentOffset.x+pageWidth;
    CGRect toVisible = CGRectMake(newPosition, 0, pageWidth, pageHeight);
    [scrollView scrollRectToVisible:toVisible animated:YES];
    
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    uint page = self.scrollView.frame.size.width / pageWidth;
//    if (self.currentIndex < self.pageSubTitles.count -1 ) {
//        
//        [Amplitude logEvent:@"Onboard: Next selected"];
////          NSLog(@"CurrentIndex on Button Press  %lu", (unsigned long)self.currentIndex);
//        
//        self.currentIndex = self.currentIndex+1;
////        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
    
    
//    }
    
    self.currentIndex = self.currentIndex+1;
    NSLog(@"button pressed %lu",  (unsigned long)self.currentIndex);
    
    
    if (self.currentIndex == 2) {
        [Amplitude logEvent:@"Onboard: Grant Motion Permission"];
        //        [self.startWalkthroughButton setTitle: @"Grant Motion Permission" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageMotion forState:UIControlStateNormal];
//        NSLog(@"page == 2");
        self.noNotifications.hidden = YES;
    }
    
    else if(self.currentIndex == 3)
    {
        
//        //show login options once the person selected the grant permission label
//        self.Login.hidden = NO;
//        self.SignUp.hidden = NO;
//        self.separatorLine.hidden = NO;
//        self.startWalkthroughButton.hidden = YES;
        
        
        //initialize CMStepCounter to ask the user for permission
        self.cmStepCounter = [[CMStepCounter alloc] init];
        
        if([CMStepCounter isStepCountingAvailable])
        {
            NSLog(@"CMStepCounter is Avaialble");
            [Amplitude logEvent:@"Onboard: Motion dialogue"];
            
        }
        else{
            NSLog(@"CMStepCounter is NOT Avaialble");
        }
        
        //this needs to be here so that the standarad Apple motion permission request pops up
        NSDate *today = [NSDate date];
        NSDate *yesterday = [today dateByAddingTimeInterval: -86400.0];
        [self.cmStepCounter queryStepCountStartingFrom:yesterday to:today toQueue:self.operationQueue withHandler:^(NSInteger numberOfSteps, NSError *error){
        }];
        
        [self.startWalkthroughButton setImage:buttonImageNext forState:UIControlStateNormal];
        
        self.noNotifications.hidden = YES;

        
    }
    else if(self.currentIndex == 4)
    {
        [Amplitude logEvent:@"Onboard: Next"];
        //        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageNext forState:UIControlStateNormal];
        
        self.noNotifications.hidden = YES;
    }
    
    else if(self.currentIndex == 5)
    {
        [Amplitude logEvent:@"Onboard: Next"];
        //        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageNext forState:UIControlStateNormal];
        
        self.noNotifications.hidden = YES;
    }
    
    else if(self.currentIndex == 6)
    {
        [Amplitude logEvent:@"Onboard: Next"];
        //        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
        
        [self.startWalkthroughButton setImage:buttonImageYes forState:UIControlStateNormal];
        
        self.noNotifications.hidden = NO;
    }


    
    else if (self.currentIndex == 7) {
        [Amplitude logEvent:@"Onboard: Notification Yes"];
        //        [self.startWalkthroughButton setTitle: @"test" forState: UIControlStateNormal];
        
        NSLog(@"page == 7");
        
        // Register for push notifications
        float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (ver >= 8.0) {
            // Only executes on version OS 8 or above.
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
             UIUserNotificationTypeBadge |
             UIUserNotificationTypeSound
                                              categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeSound];
            
            
        }
        
        [self.startWalkthroughButton setImage:buttonJoin forState:UIControlStateNormal];
        
        self.noNotifications.hidden = YES;

    }
    

    
    else if(self.currentIndex >= 8)
    {
        [Amplitude logEvent:@"Onboard: Join"];
        //        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
        
        [self.startWalkthroughButton setImage:buttonJoin forState:UIControlStateNormal];
        
        self.noNotifications.hidden = YES;
        
        [Amplitude logEvent:@"Onboard: LogIn selected"];
        
        // Create the log in view controller
        CustomPFLogInViewController *logInViewController = [[CustomPFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        
        CustomPFSignUpViewController *signUpViewController = [[CustomPFSignUpViewController alloc] init];
        
        //    logInViewController.signUpController = [[CustomPFSignUpViewController alloc] init];
        
        //    signUpViewController.fields =  PFSignUpFieldsDefault  ;
        
        
        
        //    logInViewController.facebookPermissions = @[@"friends_about_me"];
        //    logInViewController.fields = PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook  ;
        
        logInViewController.fields = PFLogInFieldsFacebook |  PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton ;
        
        //    logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsSignUpButton |PFLogInFieldsDismissButton  ;
        logInViewController.facebookPermissions = @[ @"public_profile", @"email" ];
        
        
         [logInViewController setSignUpController:signUpViewController]; 
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
        

    }

    
    
    else{
        [Amplitude logEvent:@"Onboard: Next"];
        //        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageNext forState:UIControlStateNormal];
        
        self.noNotifications.hidden = YES;
    }

    
//    [self.pageControl setCurrentPage:self.currentIndex];
    

    
    }


- (IBAction)noNotificationPressed:(id)sender {
    [Amplitude logEvent:@"Onboard: Notifications Denied"];
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    float newPosition = scrollView.contentOffset.x+pageWidth;
    CGRect toVisible = CGRectMake(newPosition, 0, pageWidth, pageHeight);
    [scrollView scrollRectToVisible:toVisible animated:YES];
    
    //    CGFloat pageWidth = self.scrollView.frame.size.width;
    //    uint page = self.scrollView.frame.size.width / pageWidth;
    //    if (self.currentIndex < self.pageSubTitles.count -1 ) {
    //
    //        [Amplitude logEvent:@"Onboard: Next selected"];
    ////          NSLog(@"CurrentIndex on Button Press  %lu", (unsigned long)self.currentIndex);
    //
    //        self.currentIndex = self.currentIndex+1;
    ////        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
    
    
    //    }
    
    self.currentIndex = self.currentIndex+1;

    self.noNotifications.hidden = YES;
    
    if(self.currentIndex == 7)
    {
        [Amplitude logEvent:@"Onboard: Next"];
        //        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
        
        UIImage * buttonJoin = [UIImage imageNamed:@"JoinButton@2x.png"];
        
        [self.startWalkthroughButton setImage:buttonJoin forState:UIControlStateNormal];
        
        self.noNotifications.hidden = YES;
    }
    

    
}


 - (NSOperationQueue *)operationQueue {
     if (_operationQueue == nil) {
         _operationQueue = [NSOperationQueue new];
     }
     return _operationQueue;
 }
                                                                                                                         
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    NSLog(@"scroolview end decelerating");
    UIImage * buttonImageMotion = [UIImage imageNamed:@"Grant_Motion_Permission_Button@2x.png"];
    UIImage * buttonImageNext = [UIImage imageNamed:@"NextButton@2x.png"];
    UIImage * buttonImageStart = [UIImage imageNamed:@"LetsGetStartedButton@2x.png"];
    UIImage * buttonImageYes = [UIImage imageNamed:@"YesButton@2x.png"];
    UIImage * buttonImageNo = [UIImage imageNamed:@"NahImGoodButton@2x.png"];
    
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    uint page = sender.contentOffset.x / pageWidth;
    
    
    self.currentIndex = page;
    [self.pageControl setCurrentPage:page];
    
    if (page == 0) {
        [Amplitude logEvent:@"Onboard: Get Started"];
        //        [self.startWalkthroughButton setTitle: @"Grant Motion Permission" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageStart forState:UIControlStateNormal];
       
    }
    if (page == 2) {
        [Amplitude logEvent:@"Onboard: Swipe_Motion"];
//        [self.startWalkthroughButton setTitle: @"Grant Motion Permission" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageMotion forState:UIControlStateNormal];
    }
    else if (page == 6) {
        [Amplitude logEvent:@"Onboard: Swipe_Motion"];
//        [self.startWalkthroughButton setTitle: @"test" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageYes forState:UIControlStateNormal];
    }

    
    else{
        [Amplitude logEvent:@"Onboard: Swipe"];
//        [self.startWalkthroughButton setTitle: @"Next" forState: UIControlStateNormal];
        [self.startWalkthroughButton setImage:buttonImageNext forState:UIControlStateNormal];
    }

    
//    self.mainTitle.text =[NSString stringWithFormat:@"%@",[_pageTitles objectAtIndex: page]];
//    self.subTitle.text =[NSString stringWithFormat:@"%@",[_pageSubTitles objectAtIndex: page]];
    

}






@end
