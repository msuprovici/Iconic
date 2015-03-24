//
//  LogInViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 11/12/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>
#import <ParseUI/PFSignUpViewController.h>
#import <ParseUI/PFLogInViewController.h>
#import "LogInPageContentViewController.h"


@interface LogInViewController :
UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

//@property (nonatomic, strong) UIPageViewController *pageViewController;

;
@property (strong, nonatomic) IBOutlet UIButton *startWalkthroughButton;

- (IBAction)startWalkthrough:(id)sender;



- (IBAction)signUpAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *Login;
@property (strong, nonatomic) IBOutlet UIButton *SignUp;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;


//@property (strong, nonatomic) IBOutlet UILabel *mainTitle;
//@property (strong, nonatomic) IBOutlet UILabel *subTitle;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageSubTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic) NSInteger vcIndex;
@property UILabel *myLabel;

@property (strong, nonatomic) IBOutlet UILabel *separatorLine;



@end
