//
//  LogInViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 11/12/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LogInPageContentViewController.h"


@interface LogInViewController :
UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

//@property (nonatomic, strong) UIPageViewController *pageViewController;

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *startWalkthroughButton;
- (IBAction)signUpAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *Login;
@property (strong, nonatomic) IBOutlet UIButton *SignUp;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;


@property (strong, nonatomic) IBOutlet UILabel *mainTitle;
@property (strong, nonatomic) IBOutlet UILabel *subTitle;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageSubTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic) NSInteger vcIndex;
@property UILabel *myLabel;

@end
