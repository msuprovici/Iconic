//
//  LogInViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 11/12/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "TutorialViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

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
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    _modelArray = [NSMutableArray arrayWithObjects:[[TutorialScreens alloc] initWithImageName:@"tutorial1.png"], [[TutorialScreens alloc] initWithImageName:@"tutorial2.png"], [[TutorialScreens alloc] initWithImageName:@"tutorial3.png"], [[TutorialScreens alloc] initWithImageName:@"tutorial4.png"], nil];
    
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
    
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    TutorialViewController *imageViewController = [[TutorialViewController alloc] init];
    imageViewController.model = [_modelArray objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:imageViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    [_pageViewController didMoveToParentViewController:self];
    
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = [[UIScreen mainScreen] bounds];
    self.pageViewController.view.frame = pageViewRect;
    
    self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
    [self.view sendSubviewToBack: _pageViewController.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//Skip Login
- (IBAction)skipLogin:(id)sender {
    
    //create a new anonymous user and create an id on the parse server
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] saveInBackground];
 
}

//Login
- (IBAction)userLogin:(id)sender {
    
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    logInViewController.facebookPermissions = @[@"friends_about_me"];
    logInViewController.fields = PFLogInFieldsFacebook |  PFLogInFieldsDismissButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton ;
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
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
    NSLog(@"Failed to log in...");
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
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    TutorialViewController *contentVc = (TutorialViewController *)viewController;
    
    NSUInteger currentIndex = [_modelArray indexOfObject:[contentVc model]];
    _vcIndex = currentIndex;
    
    if (currentIndex == 0)
    {
        return nil;
    }
    
    TutorialViewController *imageViewController = [[TutorialViewController alloc] init];
    imageViewController.model = [_modelArray objectAtIndex:currentIndex - 1];
    return imageViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    TutorialViewController *contentVc = (TutorialViewController *)viewController;
    
    NSUInteger currentIndex = [_modelArray indexOfObject:[contentVc model]];
    _vcIndex = currentIndex;
    //ImageModel *model = [_modelArray objectAtIndex:_vcIndex];
    
    if (currentIndex == _modelArray.count - 1)
    {
        return nil;
    }
    
    TutorialViewController *imageViewController = [[TutorialViewController alloc] init];
    imageViewController.model = [_modelArray objectAtIndex:currentIndex + 1];
    return imageViewController;
}

#pragma mark -
#pragma mark - UIPageViewControllerDataSource Method

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return _modelArray.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}



@end
